package requests

import "time"

// EventInput is used when creating or updating an event inside a schedule/venue.
type EventInput struct {
	Title       string    `json:"title" binding:"required,min=1,max=255"`
	Description string    `json:"description" binding:"omitempty,max=1000"`
	StartAt     time.Time `json:"start_at" binding:"required"`
	EndAt       time.Time `json:"end_at" binding:"required"`
}

// CreateScheduleVenueRequest creates a venue scoped to a single schedule.
type CreateScheduleVenueRequest struct {
	Name        string `json:"name" binding:"required,min=1,max=255"`
	Description string `json:"description" binding:"omitempty,max=1000"`
	Order       int    `json:"order" binding:"omitempty"`
}

// CreateScheduleLocationRequest creates a location scoped to a schedule venue.
type CreateScheduleLocationRequest struct {
	Name        string `json:"name" binding:"required,min=1,max=255"`
	Description string `json:"description" binding:"omitempty,max=1000"`
	Order       int    `json:"order" binding:"omitempty"`
}

// CreateScheduleRequest is the body for creating a schedule with nested venues and events.
type CreateScheduleRequest struct {
	Name    string    `json:"name" binding:"required,min=1,max=255"`
	StartAt time.Time `json:"start_at" binding:"required"`
	EndAt   time.Time `json:"end_at" binding:"required"`
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

// AttachLocationRequest is used to attach an existing global Location to a schedule's venue.
type AttachLocationRequest struct {
	LocationId string `json:"location_id" binding:"required,uuid4"`
	// Optional: override name/order for this schedule-specific pivot
	Name  *string `json:"name" binding:"omitempty,min=1,max=255"`
	Order *int    `json:"order" binding:"omitempty"`
}
