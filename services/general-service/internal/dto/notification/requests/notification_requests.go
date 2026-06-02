package requests

// CreateNotificationRequest creates a notification for the authenticated user.
type CreateNotificationRequest struct {
	Title string `json:"title" binding:"required,min=1,max=255"`
	Body  string `json:"body" binding:"max=10000"`
	Kind  string `json:"kind" binding:"omitempty,max=50"`
}

// UpdateNotificationRequest updates fields; omitted fields are unchanged.
// MarkRead: true sets read_at to now, false clears read_at, nil leaves read_at unchanged.
type UpdateNotificationRequest struct {
	Title    *string `json:"title" binding:"omitempty,min=1,max=255"`
	Body     *string `json:"body" binding:"omitempty,max=10000"`
	Kind     *string `json:"kind" binding:"omitempty,max=50"`
	MarkRead *bool   `json:"mark_read"`
}

// AdminCreateNotificationRequest creates a notification for another user (admin). Optionally sends the same content by email and/or FCM push.
type AdminCreateNotificationRequest struct {
	UserID    string `json:"user_id" binding:"required,uuid"`
	Title     string `json:"title" binding:"required,min=1,max=255"`
	Body      string `json:"body" binding:"max=10000"`
	Kind      string `json:"kind" binding:"omitempty,max=50"`
	SendEmail bool   `json:"send_email"`
	SendPush  bool   `json:"send_push"`
}
