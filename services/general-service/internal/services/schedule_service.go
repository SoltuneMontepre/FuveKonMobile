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
	// build model from request
	sched := &models.Schedule{
		Name:    req.Name,
		StartAt: &req.StartAt,
		EndAt:   &req.EndAt,
	}

	if len(req.Venues) > 0 {
		sched.Venues = make([]models.ScheduleVenue, len(req.Venues))
		for i := range req.Venues {
			v := req.Venues[i]
			sv := models.ScheduleVenue{
				Name:        v.Name,
				Description: v.Description,
				Order:       v.Order,
			}
			if len(v.Events) > 0 {
				sv.Events = make([]models.ScheduleEvent, len(v.Events))
				for j := range v.Events {
					e := v.Events[j]
					sv.Events[j] = models.ScheduleEvent{
						Title:       e.Title,
						Description: e.Description,
						StartAt:     e.StartAt,
						EndAt:       e.EndAt,
					}
				}
			}
			sched.Venues[i] = sv
		}
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
	out := mappers.MapSchedulesToResponse(items)
	return out, nil
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

// CreateVenue creates a venue (and optional nested events) under a schedule.
func (s *ScheduleService) CreateVenue(ctx context.Context, scheduleIDStr string, req *requests.VenueInput) (*schedresponses.VenueResponse, error) {
	id, err := uuid.Parse(scheduleIDStr)
	if err != nil {
		return nil, errors.New("invalid schedule id")
	}

	v := &models.ScheduleVenue{
		Name:        req.Name,
		Description: req.Description,
		Order:       req.Order,
	}
	if len(req.Events) > 0 {
		v.Events = make([]models.ScheduleEvent, len(req.Events))
		for i := range req.Events {
			e := req.Events[i]
			v.Events[i] = models.ScheduleEvent{
				Title:       e.Title,
				Description: e.Description,
				StartAt:     e.StartAt,
				EndAt:       e.EndAt,
			}
		}
	}

	created, err := s.repos.Schedule.CreateVenue(ctx, id, v)
	if err != nil {
		log.Printf("Error creating venue: %v", err)
		return nil, err
	}
	resp := mappers.MapVenueToResponse(created)
	return &resp, nil
}

// UpdateVenue updates a venue's fields.
func (s *ScheduleService) UpdateVenue(ctx context.Context, venueIDStr string, req *requests.UpdateVenueRequest) (*schedresponses.VenueResponse, error) {
	id, err := uuid.Parse(venueIDStr)
	if err != nil {
		return nil, errors.New("invalid venue id")
	}

	updates := make(map[string]interface{})
	if req.Name != nil {
		updates["name"] = *req.Name
	}
	if req.Description != nil {
		updates["description"] = *req.Description
	}
	if req.Order != nil {
		updates["order"] = *req.Order
	}

	updated, err := s.repos.Schedule.UpdateVenue(ctx, id, updates)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapVenueToResponse(updated)
	return &resp, nil
}

// DeleteVenue marks a venue as deleted.
func (s *ScheduleService) DeleteVenue(ctx context.Context, venueIDStr string) error {
	id, err := uuid.Parse(venueIDStr)
	if err != nil {
		return errors.New("invalid venue id")
	}
	return s.repos.Schedule.DeleteVenue(ctx, id)
}

// CreateEvent creates an event under a schedule and venue.
func (s *ScheduleService) CreateEvent(ctx context.Context, scheduleIDStr string, venueIDStr string, req *requests.EventInput) (*schedresponses.EventResponse, error) {
	sid, err := uuid.Parse(scheduleIDStr)
	if err != nil {
		return nil, errors.New("invalid schedule id")
	}
	var vid *uuid.UUID
	if venueIDStr != "" {
		vParsed, err := uuid.Parse(venueIDStr)
		if err != nil {
			return nil, errors.New("invalid venue id")
		}
		vid = &vParsed
	}

	e := &models.ScheduleEvent{
		Title:       req.Title,
		Description: req.Description,
		StartAt:     req.StartAt,
		EndAt:       req.EndAt,
	}

	created, err := s.repos.Schedule.CreateEvent(ctx, sid, vid, e)
	if err != nil {
		log.Printf("Error creating event: %v", err)
		return nil, err
	}
	resp := mappers.MapEventToResponse(created)
	return &resp, nil
}

// UpdateEvent updates an event's fields.
func (s *ScheduleService) UpdateEvent(ctx context.Context, eventIDStr string, req *requests.UpdateEventRequest) (*schedresponses.EventResponse, error) {
	id, err := uuid.Parse(eventIDStr)
	if err != nil {
		return nil, errors.New("invalid event id")
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

	updated, err := s.repos.Schedule.UpdateEvent(ctx, id, updates)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapEventToResponse(updated)
	return &resp, nil
}

// DeleteEvent marks an event as deleted.
func (s *ScheduleService) DeleteEvent(ctx context.Context, eventIDStr string) error {
	id, err := uuid.Parse(eventIDStr)
	if err != nil {
		return errors.New("invalid event id")
	}
	return s.repos.Schedule.DeleteEvent(ctx, id)
}
