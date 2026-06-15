package responses

import (
	"time"

	"github.com/google/uuid"
)

type LocationResponse struct {
	Id          uuid.UUID `json:"id"`
	Name        string    `json:"name"`
	Description string    `json:"description,omitempty"`
	Order       int       `json:"order"`
	CreatedAt   time.Time `json:"created_at"`
	ModifiedAt  time.Time `json:"modified_at"`
}

type VenueResponse struct {
	Id          uuid.UUID          `json:"id"`
	Name        string             `json:"name"`
	Description string             `json:"description,omitempty"`
	Locations   []LocationResponse `json:"locations,omitempty"`
	CreatedAt   time.Time          `json:"created_at"`
	ModifiedAt  time.Time          `json:"modified_at"`
}
