package responses

import (
	"time"

	"github.com/google/uuid"
)

type LostFoundResponse struct {
	Id                  uuid.UUID  `json:"id"`
	DisplayCode         string     `json:"display_code"`
	ItemType            string     `json:"item_type"`
	Title               string     `json:"title"`
	Description         string     `json:"description"`
	Location            string     `json:"location"`
	ImageUrl            string     `json:"image_url,omitempty"`
	ContactInfo         string     `json:"contact_info,omitempty"`
	StaffNotes          string     `json:"staff_notes,omitempty"`
	Status              string     `json:"status"`
	SubmittedByUserId   uuid.UUID  `json:"submitted_by_user_id"`
	RecipientName       string     `json:"recipient_name,omitempty"`
	RecipientIdCard     string     `json:"recipient_id_card,omitempty"`
	RecipientPhone      string     `json:"recipient_phone,omitempty"`
	VerifiedDescription bool       `json:"verified_description"`
	VerifiedOwnership   bool       `json:"verified_ownership"`
	VerifiedIdentity    bool       `json:"verified_identity"`
	ReturnedAt          *time.Time             `json:"returned_at,omitempty"`
	ReturnedByUserId    *uuid.UUID             `json:"returned_by_user_id,omitempty"`
	ActiveClaim         *LostFoundClaimResponse `json:"active_claim,omitempty"`
	CreatedAt           time.Time              `json:"created_at"`
	ModifiedAt          time.Time              `json:"modified_at"`
}

type LostFoundClaimUserResponse struct {
	Id          uuid.UUID `json:"id"`
	FirstName   string    `json:"first_name,omitempty"`
	LastName    string    `json:"last_name,omitempty"`
	FursonaName string    `json:"fursona_name,omitempty"`
	Email       string    `json:"email,omitempty"`
	IdCard      string    `json:"id_card,omitempty"`
	Avatar      string    `json:"avatar,omitempty"`
}

type LostFoundClaimResponse struct {
	Id        uuid.UUID                  `json:"id"`
	ItemId    uuid.UUID                  `json:"item_id"`
	Status    string                     `json:"status"`
	Message   string                     `json:"message,omitempty"`
	CreatedAt time.Time                  `json:"created_at"`
	ClaimedBy LostFoundClaimUserResponse `json:"claimed_by"`
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
	DisplayCode string    `json:"display_code"`
	ItemType    string    `json:"item_type"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Location    string    `json:"location"`
	ImageUrl    string    `json:"image_url,omitempty"`
	ContactInfo string    `json:"contact_info,omitempty"`
	Status          string    `json:"status"`
	UserClaimStatus string    `json:"user_claim_status,omitempty"`
	CreatedAt       time.Time `json:"created_at"`
	ModifiedAt      time.Time `json:"modified_at"`
}

type LostFoundClaimResultResponse struct {
	ItemId  uuid.UUID `json:"item_id"`
	Status  string    `json:"status"`
	Message string    `json:"message"`
}

type LostFoundPublicListResponse struct {
	Items      []LostFoundPublicResponse `json:"items"`
	Total      int64                     `json:"total"`
	Page       int                       `json:"page"`
	PageSize   int                       `json:"page_size"`
	TotalPages int                       `json:"total_pages"`
}
