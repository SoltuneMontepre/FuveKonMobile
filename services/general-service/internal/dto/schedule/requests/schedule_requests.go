package requests

import "time"

// EventInput is used when creating or updating an event inside a schedule/venue.
type EventInput struct {
	Title       string    `json:"title" binding:"required,min=1,max=255"`
	Description string    `json:"description" binding:"omitempty,max=1000"`
	StartAt     time.Time `json:"start_at" binding:"required"`
	EndAt       time.Time `json:"end_at" binding:"required"`
}

// VenueInput is used when creating or updating a venue inside a schedule.
type VenueInput struct {
	Name        string       `json:"name" binding:"required,min=1,max=255"`
	Description string       `json:"description" binding:"omitempty,max=1000"`
	Order       int          `json:"order" binding:"omitempty"`
	Events      []EventInput `json:"events" binding:"omitempty,dive"`
}

// CreateScheduleRequest is the body for creating a schedule with nested venues and events.
type CreateScheduleRequest struct {
	Name    string       `json:"name" binding:"required,min=1,max=255"`
	StartAt time.Time    `json:"start_at" binding:"required"`
	EndAt   time.Time    `json:"end_at" binding:"required"`
	Venues  []VenueInput `json:"venues" binding:"omitempty,dive"`
}

// UpdateScheduleRequest supports partial updates of a schedule's top-level fields.
type UpdateScheduleRequest struct {
	Name    *string    `json:"name" binding:"omitempty,min=1,max=255"`
	StartAt *time.Time `json:"start_at" binding:"omitempty"`
	EndAt   *time.Time `json:"end_at" binding:"omitempty"`
}

// UpdateVenueRequest supports partial updates for a venue.
type UpdateVenueRequest struct {
	Name        *string `json:"name" binding:"omitempty,min=1,max=255"`
	Description *string `json:"description" binding:"omitempty,max=1000"`
	Order       *int    `json:"order" binding:"omitempty"`
}

// UpdateEventRequest supports partial updates for an event.
type UpdateEventRequest struct {
	Title       *string    `json:"title" binding:"omitempty,min=1,max=255"`
	Description *string    `json:"description" binding:"omitempty,max=1000"`
	StartAt     *time.Time `json:"start_at" binding:"omitempty"`
	EndAt       *time.Time `json:"end_at" binding:"omitempty"`
}
