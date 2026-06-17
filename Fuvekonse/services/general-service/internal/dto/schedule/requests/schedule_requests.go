package requests

import "time"

// TimelineItemInput creates a timeline item on a schedule day.
type TimelineItemInput struct {
	Title       string    `json:"title" binding:"required,min=1,max=255"`
	Description string    `json:"description" binding:"omitempty,max=1000"`
	StartAt     time.Time `json:"start_at" binding:"required"`
	EndAt       time.Time `json:"end_at" binding:"required"`
	Category    string    `json:"category" binding:"omitempty,max=255"`
	Location    string    `json:"location" binding:"omitempty,max=255"`
}

// CreateScheduleRequest is the body for creating a schedule.
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

// UpdateTimelineItemRequest supports partial updates for a timeline item.
type UpdateTimelineItemRequest struct {
	Title       *string    `json:"title" binding:"omitempty,min=1,max=255"`
	Description *string    `json:"description" binding:"omitempty,max=1000"`
	StartAt     *time.Time `json:"start_at" binding:"omitempty"`
	EndAt       *time.Time `json:"end_at" binding:"omitempty"`
	Category    *string    `json:"category" binding:"omitempty,max=255"`
	Location    *string    `json:"location" binding:"omitempty,max=255"`
}
