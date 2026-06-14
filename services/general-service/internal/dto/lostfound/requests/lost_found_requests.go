package requests

type CreateLostFoundRequest struct {
	ItemType    string `json:"item_type" binding:"required,oneof=lost found"`
	Title       string `json:"title" binding:"required,min=1,max=255"`
	Description string `json:"description" binding:"max=5000"`
	Location    string `json:"location" binding:"max=255"`
	ImageUrl    string `json:"image_url" binding:"omitempty,max=500,url"`
	ContactInfo string `json:"contact_info" binding:"max=500"`
	StaffNotes  string `json:"staff_notes" binding:"max=5000"`
}

type UpdateLostFoundRequest struct {
	ItemType    *string `json:"item_type" binding:"omitempty,oneof=lost found"`
	Title       *string `json:"title" binding:"omitempty,min=1,max=255"`
	Description *string `json:"description" binding:"omitempty,max=5000"`
	Location    *string `json:"location" binding:"omitempty,max=255"`
	ImageUrl    *string `json:"image_url" binding:"omitempty,max=500"`
	ContactInfo *string `json:"contact_info" binding:"omitempty,max=500"`
	StaffNotes  *string `json:"staff_notes" binding:"omitempty,max=5000"`
}

type UpdateLostFoundStatusRequest struct {
	Status string `json:"status" binding:"required,oneof=open claimed resolved"`
}

type ListLostFoundQuery struct {
	ItemType string
	Status   string
	Search   string
	Page     int
	PageSize int
}
