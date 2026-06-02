package responses

import (
	"time"

	"github.com/google/uuid"
)

type EventResponse struct {
	Id          uuid.UUID `json:"id"`
	Title       string    `json:"title"`
	Description string    `json:"description,omitempty"`
	StartAt     time.Time `json:"start_at"`
	EndAt       time.Time `json:"end_at"`
	CreatedAt   time.Time `json:"created_at"`
	ModifiedAt  time.Time `json:"modified_at"`
}

type VenueResponse struct {
	Id          uuid.UUID       `json:"id"`
	Name        string          `json:"name"`
	Description string          `json:"description,omitempty"`
	Order       int             `json:"order"`
	Events      []EventResponse `json:"events,omitempty"`
	CreatedAt   time.Time       `json:"created_at"`
	ModifiedAt  time.Time       `json:"modified_at"`
}

type ScheduleResponse struct {
	Id         uuid.UUID       `json:"id"`
	Name       string          `json:"name"`
	StartAt    *time.Time      `json:"start_at,omitempty"`
	EndAt      *time.Time      `json:"end_at,omitempty"`
	Venues     []VenueResponse `json:"venues,omitempty"`
	CreatedAt  time.Time       `json:"created_at"`
	ModifiedAt time.Time       `json:"modified_at"`
}
