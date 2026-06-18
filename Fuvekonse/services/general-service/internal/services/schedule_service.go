package services

import (
	"context"
	"errors"
	"general-service/internal/dto/schedule/requests"
	schedresponses "general-service/internal/dto/schedule/responses"
	"general-service/internal/mappers"
	"general-service/internal/models"
	"general-service/internal/repositories"
	"log"

	"github.com/google/uuid"
)

type ScheduleService struct {
	repos *repositories.Repositories
}

func NewScheduleService(repos *repositories.Repositories) *ScheduleService {
	return &ScheduleService{repos: repos}
}

func (s *ScheduleService) CreateSchedule(ctx context.Context, req *requests.CreateScheduleRequest) (*schedresponses.ScheduleResponse, error) {
	sched := &models.Schedule{
		Name:    req.Name,
		StartAt: &req.StartAt,
		EndAt:   &req.EndAt,
	}

	created, err := s.repos.Schedule.CreateSchedule(ctx, sched)
	if err != nil {
		log.Printf("Error creating schedule: %v", err)
		return nil, err
	}

	resp := mappers.MapScheduleToResponse(created)
	return &resp, nil
}

func (s *ScheduleService) GetScheduleByID(ctx context.Context, idStr string) (*schedresponses.ScheduleResponse, error) {
	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid schedule id")
	}
	sched, err := s.repos.Schedule.GetScheduleByID(ctx, id)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapScheduleToResponse(sched)
	return &resp, nil
}

func (s *ScheduleService) ListSchedules(ctx context.Context) ([]schedresponses.ScheduleResponse, error) {
	items, err := s.repos.Schedule.ListSchedules(ctx)
	if err != nil {
		return nil, err
	}
	return mappers.MapSchedulesToResponse(items), nil
}

func (s *ScheduleService) UpdateSchedule(ctx context.Context, idStr string, req *requests.UpdateScheduleRequest) (*schedresponses.ScheduleResponse, error) {
	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid schedule id")
	}

	updates := &models.Schedule{}
	if req.Name != nil {
		updates.Name = *req.Name
	}
	if req.StartAt != nil {
		updates.StartAt = req.StartAt
	}
	if req.EndAt != nil {
		updates.EndAt = req.EndAt
	}

	updated, err := s.repos.Schedule.UpdateSchedule(ctx, id, updates)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapScheduleToResponse(updated)
	return &resp, nil
}

func (s *ScheduleService) DeleteSchedule(ctx context.Context, idStr string) error {
	id, err := uuid.Parse(idStr)
	if err != nil {
		return errors.New("invalid schedule id")
	}
	return s.repos.Schedule.DeleteSchedule(ctx, id)
}

func (s *ScheduleService) CreateTimelineItem(
	ctx context.Context,
	scheduleIDStr string,
	req *requests.TimelineItemInput,
) (*schedresponses.TimelineItemResponse, error) {
	sid, err := uuid.Parse(scheduleIDStr)
	if err != nil {
		return nil, errors.New("invalid schedule id")
	}

	category := req.Category
	if category == "" {
		category = "Chung"
	}
	locationName := req.Location
	if locationName == "" {
		locationName = "Chung"
	}

	venue, err := s.repos.Schedule.FindOrCreateVenueByName(ctx, sid, category)
	if err != nil {
		return nil, err
	}
	location, err := s.repos.Schedule.FindOrCreateLocationByName(ctx, sid, venue.Id, locationName)
	if err != nil {
		return nil, err
	}

	e := &models.ScheduleEvent{
		Title:       req.Title,
		Description: req.Description,
		StartAt:     req.StartAt,
		EndAt:       req.EndAt,
	}
	locID := location.Id
	created, err := s.repos.Schedule.CreateEvent(ctx, sid, &locID, e)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapTimelineItemToResponse(created, category, locationName)
	return &resp, nil
}

func (s *ScheduleService) UpdateTimelineItem(
	ctx context.Context,
	scheduleIDStr string,
	itemIDStr string,
	req *requests.UpdateTimelineItemRequest,
) (*schedresponses.TimelineItemResponse, error) {
	sid, err := uuid.Parse(scheduleIDStr)
	if err != nil {
		return nil, errors.New("invalid schedule id")
	}
	id, err := uuid.Parse(itemIDStr)
	if err != nil {
		return nil, errors.New("invalid timeline item id")
	}

	existing, category, locationName, err := s.repos.Schedule.GetTimelineItemContext(ctx, id)
	if err != nil {
		return nil, err
	}
	if existing.ScheduleId != sid {
		return nil, repositories.ErrTimelineItemNotFound
	}

	updates := make(map[string]interface{})
	if req.Title != nil {
		updates["title"] = *req.Title
	}
	if req.Description != nil {
		updates["description"] = *req.Description
	}
	if req.StartAt != nil {
		updates["start_at"] = *req.StartAt
	}
	if req.EndAt != nil {
		updates["end_at"] = *req.EndAt
	}

	if req.Category != nil || req.Location != nil {
		nextCategory := category
		if req.Category != nil && *req.Category != "" {
			nextCategory = *req.Category
		}
		nextLocation := locationName
		if req.Location != nil && *req.Location != "" {
			nextLocation = *req.Location
		}
		if nextCategory == "" {
			nextCategory = "Chung"
		}
		if nextLocation == "" {
			nextLocation = "Chung"
		}

		venue, err := s.repos.Schedule.FindOrCreateVenueByName(ctx, sid, nextCategory)
		if err != nil {
			return nil, err
		}
		location, err := s.repos.Schedule.FindOrCreateLocationByName(ctx, sid, venue.Id, nextLocation)
		if err != nil {
			return nil, err
		}
		updates["location_id"] = location.Id
		category = nextCategory
		locationName = nextLocation
	}

	updated, err := s.repos.Schedule.UpdateEvent(ctx, id, updates)
	if err != nil {
		return nil, err
	}
	return s.timelineItemResponse(ctx, updated)
}

func (s *ScheduleService) DeleteTimelineItem(ctx context.Context, scheduleIDStr, itemIDStr string) error {
	sid, err := uuid.Parse(scheduleIDStr)
	if err != nil {
		return errors.New("invalid schedule id")
	}
	id, err := uuid.Parse(itemIDStr)
	if err != nil {
		return errors.New("invalid timeline item id")
	}

	existing, err := s.repos.Schedule.GetEventByID(ctx, id)
	if err != nil {
		return err
	}
	if existing.ScheduleId != sid {
		return repositories.ErrTimelineItemNotFound
	}
	return s.repos.Schedule.DeleteEvent(ctx, id)
}

func (s *ScheduleService) timelineItemResponse(
	ctx context.Context,
	event *models.ScheduleEvent,
) (*schedresponses.TimelineItemResponse, error) {
	item, category, locationName, err := s.repos.Schedule.GetTimelineItemContext(ctx, event.Id)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapTimelineItemToResponse(item, category, locationName)
	return &resp, nil
}
