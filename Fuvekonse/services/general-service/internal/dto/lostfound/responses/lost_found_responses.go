package responses

import (
	"time"

	"github.com/google/uuid"
)

type LostFoundResponse struct {
	Id                uuid.UUID `json:"id"`
	ItemType          string    `json:"item_type"`
	Title             string    `json:"title"`
	Description       string    `json:"description"`
	Location          string    `json:"location"`
	ImageUrl          string    `json:"image_url,omitempty"`
	ContactInfo       string    `json:"contact_info,omitempty"`
	StaffNotes        string    `json:"staff_notes,omitempty"`
	Status            string    `json:"status"`
	SubmittedByUserId uuid.UUID `json:"submitted_by_user_id"`
	CreatedAt         time.Time `json:"created_at"`
	ModifiedAt        time.Time `json:"modified_at"`
}

type LostFoundListResponse struct {
	Items      []LostFoundResponse `json:"items"`
	Total      int64               `json:"total"`
	Page       int                 `json:"page"`
	PageSize   int                 `json:"page_size"`
	TotalPages int                 `json:"total_pages"`
}

// LostFoundPublicResponse is returned to ticket holders (no internal staff fields).
type LostFoundPublicResponse struct {
	Id          uuid.UUID `json:"id"`
	ItemType    string    `json:"item_type"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Location    string    `json:"location"`
	ImageUrl    string    `json:"image_url,omitempty"`
	ContactInfo string    `json:"contact_info,omitempty"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"created_at"`
	ModifiedAt  time.Time `json:"modified_at"`
}

type LostFoundPublicListResponse struct {
	Items      []LostFoundPublicResponse `json:"items"`
	Total      int64                     `json:"total"`
	Page       int                       `json:"page"`
	PageSize   int                       `json:"page_size"`
	TotalPages int                       `json:"total_pages"`
}
