package requests

// ListNotificationsQuery filters the authenticated user's notification inbox.
type ListNotificationsQuery struct {
	Page       int    `form:"page"`
	PageSize   int    `form:"page_size"`
	Kind       string `form:"kind"`
	UnreadOnly bool   `form:"unread_only"`
}

// AdminListNotificationsQuery filters notifications for admin listing.
type AdminListNotificationsQuery struct {
	UserID   string `form:"user_id"`
	Kind     string `form:"kind"`
	Page     int    `form:"page"`
	PageSize int    `form:"page_size"`
}
