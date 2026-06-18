package responses

import (
	"time"

	"github.com/google/uuid"
)

// TimelineItemResponse is one scheduled activity on a specific date.
type TimelineItemResponse struct {
	Id          uuid.UUID `json:"id"`
	Title       string    `json:"title"`
	Description string    `json:"description,omitempty"`
	StartAt     time.Time `json:"start_at"`
	EndAt       time.Time `json:"end_at"`
	Category    string    `json:"category,omitempty"`
	Location    string    `json:"location,omitempty"`
	CreatedAt   time.Time `json:"created_at"`
	ModifiedAt  time.Time `json:"modified_at"`
}

// ScheduleDayResponse groups timeline items for a single calendar date.
type ScheduleDayResponse struct {
	Date     string                 `json:"date"`
	Timeline []TimelineItemResponse `json:"timeline"`
}

// ScheduleResponse is a date-bounded schedule with timeline items grouped by day.
type ScheduleResponse struct {
	Id                uuid.UUID             `json:"id"`
	Name              string                `json:"name"`
	StartAt           *time.Time            `json:"start_at,omitempty"`
	EndAt             *time.Time            `json:"end_at,omitempty"`
	DayCount          int                   `json:"day_count"`
	TimelineItemCount int                   `json:"timeline_item_count"`
	Days              []ScheduleDayResponse `json:"days"`
	CreatedAt         time.Time             `json:"created_at"`
	ModifiedAt        time.Time             `json:"modified_at"`
}
