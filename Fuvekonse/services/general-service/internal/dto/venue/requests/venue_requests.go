package requests

// LocationInput represents a global location inside a venue.
type LocationInput struct {
	Name        string `json:"name" binding:"required,min=1,max=255"`
	Description string `json:"description" binding:"omitempty,max=1000"`
	Order       int    `json:"order" binding:"omitempty"`
}

// VenueInput is used when creating or updating a global venue.
type VenueInput struct {
	Name        string          `json:"name" binding:"required,min=1,max=255"`
	Description string          `json:"description" binding:"omitempty,max=1000"`
	Locations   []LocationInput `json:"locations" binding:"omitempty,dive"`
}
