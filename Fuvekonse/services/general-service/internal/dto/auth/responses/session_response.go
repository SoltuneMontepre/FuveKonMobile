package responses

import "time"

// SessionResponse is one signed-in device/session for the account.
type SessionResponse struct {
	Id         string    `json:"id"`
	DeviceName string    `json:"device_name"`
	Platform   string    `json:"platform"`
	DeviceId   string    `json:"device_id,omitempty"`
	LastSeenAt time.Time `json:"last_seen_at"`
	CreatedAt  time.Time `json:"created_at"`
	IsCurrent  bool      `json:"is_current"`
}

// ListSessionsResponse wraps active sessions for the authenticated user.
type ListSessionsResponse struct {
	Sessions []SessionResponse `json:"sessions"`
}
