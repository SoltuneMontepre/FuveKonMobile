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

// CreateVenue creates a schedule-scoped venue without requiring a global venue.
func (s *ScheduleService) CreateVenue(ctx context.Context, scheduleIDStr string, req *requests.CreateScheduleVenueRequest) (*schedresponses.VenueResponse, error) {
	sid, err := uuid.Parse(scheduleIDStr)
	if err != nil {
		return nil, errors.New("invalid schedule id")
	}

	sv := &models.ScheduleVenue{
		Name:        req.Name,
		Description: req.Description,
		Order:       req.Order,
	}
	created, err := s.repos.Schedule.CreateVenue(ctx, sid, sv)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapVenueToResponse(created)
	return &resp, nil
}

// CreateLocation creates a schedule-scoped location under a schedule venue.
func (s *ScheduleService) CreateLocation(ctx context.Context, scheduleIDStr string, venueIDStr string, req *requests.CreateScheduleLocationRequest) (*schedresponses.LocationResponse, error) {
	sid, err := uuid.Parse(scheduleIDStr)
	if err != nil {
		return nil, errors.New("invalid schedule id")
	}
	vid, err := uuid.Parse(venueIDStr)
	if err != nil {
		return nil, errors.New("invalid venue id")
	}

	if _, err := s.repos.Schedule.GetVenueByID(ctx, vid); err != nil {
		return nil, repositories.ErrVenueNotFound
	}

	sl := &models.ScheduleLocation{
		Name:        req.Name,
		Description: req.Description,
		Order:       req.Order,
	}
	created, err := s.repos.Schedule.CreateLocation(ctx, sid, vid, sl)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapLocationToResponse(created)
	return &resp, nil
}

// UpdateVenue updates a venue's fields. Accepts either a schedule-scoped venue id or a global Venue id.
func (s *ScheduleService) UpdateVenue(ctx context.Context, scheduleIDStr string, venueIDStr string, req *requests.UpdateVenueRequest) (*schedresponses.VenueResponse, error) {
	sid, err := uuid.Parse(scheduleIDStr)
	if err != nil {
		return nil, errors.New("invalid schedule id")
	}
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

	// Try as schedule-scoped venue first
	if _, err := s.repos.Schedule.GetVenueByID(ctx, id); err == nil {
		updated, err := s.repos.Schedule.UpdateVenue(ctx, id, updates)
		if err != nil {
			return nil, err
		}
		resp := mappers.MapVenueToResponse(updated)
		return &resp, nil
	}

	// Not a schedule venue; treat as a global Venue id: ensure global exists
	gl, err := s.repos.Venue.GetVenueByID(ctx, id)
	if err != nil {
		return nil, err
	}

	// Try to find an existing schedule-scoped venue referencing this global venue
	if sv, err := s.repos.Schedule.GetVenueByRef(ctx, sid, id); err == nil {
		updated, err := s.repos.Schedule.UpdateVenue(ctx, sv.Id, updates)
		if err != nil {
			return nil, err
		}
		resp := mappers.MapVenueToResponse(updated)
		return &resp, nil
	}

	// Create a schedule-scoped venue referencing the global venue then update
	newSv := &models.ScheduleVenue{
		Name:        gl.Name,
		Description: gl.Description,
		VenueRefId:  &id,
	}
	createdSv, err := s.repos.Schedule.CreateVenue(ctx, sid, newSv)
	if err != nil {
		return nil, err
	}
	updated, err := s.repos.Schedule.UpdateVenue(ctx, createdSv.Id, updates)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapVenueToResponse(updated)
	return &resp, nil
}

// DeleteVenue marks a venue as deleted. Accepts schedule-scoped or global Venue id.
func (s *ScheduleService) DeleteVenue(ctx context.Context, scheduleIDStr string, venueIDStr string) error {
	sid, err := uuid.Parse(scheduleIDStr)
	if err != nil {
		return errors.New("invalid schedule id")
	}
	id, err := uuid.Parse(venueIDStr)
	if err != nil {
		return errors.New("invalid venue id")
	}

	// Try delete as schedule-scoped venue first
	if _, err := s.repos.Schedule.GetVenueByID(ctx, id); err == nil {
		return s.repos.Schedule.DeleteVenue(ctx, id)
	}

	// Not a schedule venue; treat as global Venue id: ensure global exists
	if _, err := s.repos.Venue.GetVenueByID(ctx, id); err != nil {
		return err
	}

	// Find schedule-scoped venue referencing this global venue and delete it
	if sv, err := s.repos.Schedule.GetVenueByRef(ctx, sid, id); err == nil {
		return s.repos.Schedule.DeleteVenue(ctx, sv.Id)
	}

	return repositories.ErrVenueNotFound
}

// CreateEvent creates an event under a schedule and venue. The `scheduleVenueIDStr` is the
// schedule-scoped venue id (route `vid`) and `locationParamStr` may be either a schedule-scoped
// location id or a global Location id. If a global Location id is provided, the location will
// be attached to the schedule (created) and then used for the event.
func (s *ScheduleService) CreateEvent(ctx context.Context, scheduleIDStr string, scheduleVenueIDStr string, locationParamStr string, req *requests.EventInput) (*schedresponses.EventResponse, error) {
	sid, err := uuid.Parse(scheduleIDStr)
	if err != nil {
		return nil, errors.New("invalid schedule id")
	}

	if scheduleVenueIDStr == "" {
		return nil, errors.New("invalid venue id")
	}
	parsedVid, err := uuid.Parse(scheduleVenueIDStr)
	if err != nil {
		return nil, errors.New("invalid venue id")
	}

	var scheduleVenueId uuid.UUID
	// Try as schedule-scoped venue id first
	if sv, err := s.repos.Schedule.GetVenueByID(ctx, parsedVid); err == nil {
		scheduleVenueId = sv.Id
	} else {
		// Treat as global venue id: ensure global exists
		gl, err := s.repos.Venue.GetVenueByID(ctx, parsedVid)
		if err != nil {
			return nil, err
		}
		// try find schedule venue referencing this global id
		if sv2, err := s.repos.Schedule.GetVenueByRef(ctx, sid, parsedVid); err == nil {
			scheduleVenueId = sv2.Id
		} else {
			// create schedule-scoped venue referencing global
			newSv := &models.ScheduleVenue{
				Name:        gl.Name,
				Description: gl.Description,
				VenueRefId:  &parsedVid,
			}
			createdSv, err := s.repos.Schedule.CreateVenue(ctx, sid, newSv)
			if err != nil {
				return nil, err
			}
			scheduleVenueId = createdSv.Id
		}
	}

	var locId *uuid.UUID
	if locationParamStr != "" {
		parsedLoc, err := uuid.Parse(locationParamStr)
		if err != nil {
			return nil, errors.New("invalid location id")
		}

		// First, try to treat the param as a schedule-scoped location id.
		if _, err := s.repos.Schedule.GetLocationByID(ctx, parsedLoc); err == nil {
			locId = &parsedLoc
		} else {
			// Not a schedule location — try global location by id.
			gl, err := s.repos.Venue.GetLocationByID(ctx, parsedLoc)
			if err != nil {
				return nil, err
			}

			// Check for an existing ScheduleLocation that references this global location
			if sl, err := s.repos.Schedule.GetLocationByRef(ctx, sid, scheduleVenueId, parsedLoc); err == nil {
				locId = &sl.Id
			} else {
				// Create a schedule-scoped location attached to the schedule's venue.
				sl := &models.ScheduleLocation{
					Name:          gl.Name,
					Description:   gl.Description,
					Order:         gl.Order,
					LocationRefId: &parsedLoc,
				}
				createdSl, err := s.repos.Schedule.CreateLocation(ctx, sid, scheduleVenueId, sl)
				if err != nil {
					return nil, err
				}
				locId = &createdSl.Id
			}
		}
	}

	e := &models.ScheduleEvent{
		Title:       req.Title,
		Description: req.Description,
		StartAt:     req.StartAt,
		EndAt:       req.EndAt,
	}

	created, err := s.repos.Schedule.CreateEvent(ctx, sid, locId, e)
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

// AttachLocation attaches an existing global Location to a schedule's venue as a ScheduleLocation pivot.
func (s *ScheduleService) AttachLocation(ctx context.Context, scheduleIDStr string, venueIDStr string, req *requests.AttachLocationRequest) (*schedresponses.LocationResponse, error) {
	sid, err := uuid.Parse(scheduleIDStr)
	if err != nil {
		return nil, errors.New("invalid schedule id")
	}
	vid, err := uuid.Parse(venueIDStr)
	if err != nil {
		return nil, errors.New("invalid venue id")
	}

	lid, err := uuid.Parse(req.LocationId)
	if err != nil {
		return nil, errors.New("invalid location id")
	}

	// verify global location exists
	gl, err := s.repos.Venue.GetLocationByID(ctx, lid)
	if err != nil {
		return nil, err
	}

	// Resolve venue id to a schedule-scoped venue id (create if necessary)
	var scheduleVenueId uuid.UUID
	if sv, err := s.repos.Schedule.GetVenueByID(ctx, vid); err == nil {
		scheduleVenueId = sv.Id
	} else {
		// ensure global venue exists
		gVenue, err := s.repos.Venue.GetVenueByID(ctx, vid)
		if err != nil {
			return nil, err
		}
		if sv2, err := s.repos.Schedule.GetVenueByRef(ctx, sid, vid); err == nil {
			scheduleVenueId = sv2.Id
		} else {
			// create schedule-scoped venue referencing the global venue
			newSv := &models.ScheduleVenue{
				Name:        gVenue.Name,
				Description: gVenue.Description,
				VenueRefId:  &vid,
			}
			createdSv, err := s.repos.Schedule.CreateVenue(ctx, sid, newSv)
			if err != nil {
				return nil, err
			}
			scheduleVenueId = createdSv.Id
		}
	}

	sl := &models.ScheduleLocation{
		Name:          gl.Name,
		Description:   gl.Description,
		Order:         gl.Order,
		LocationRefId: &lid,
	}
	if req.Name != nil && *req.Name != "" {
		sl.Name = *req.Name
	}
	if req.Order != nil {
		sl.Order = *req.Order
	}

	created, err := s.repos.Schedule.CreateLocation(ctx, sid, scheduleVenueId, sl)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapLocationToResponse(created)
	return &resp, nil
}
