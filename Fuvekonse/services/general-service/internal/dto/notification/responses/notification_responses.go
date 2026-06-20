package responses

import (
	"time"

	"github.com/google/uuid"
)

type NotificationResponse struct {
	Id        uuid.UUID  `json:"id"`
	UserId    uuid.UUID  `json:"user_id"`
	Title     string     `json:"title"`
	Body      string     `json:"body"`
	Kind      string     `json:"kind"`
	ReadAt    *time.Time `json:"read_at,omitempty"`
	CreatedAt time.Time  `json:"created_at"`
}

// AdminCreateNotificationResponse is returned when an admin creates a notification (and optionally emails/pushes it).
type AdminCreateNotificationResponse struct {
	Notification    NotificationResponse `json:"notification"`
	EmailSent       bool                 `json:"email_sent"`
	EmailError      string               `json:"email_error,omitempty"`
	PushSent        bool                 `json:"push_sent"`
	PushError       string               `json:"push_error,omitempty"`
	DevicesNotified int                  `json:"devices_notified,omitempty"`
}

type UnreadCountResponse struct {
	Count int64 `json:"count"`
}

type MarkAllReadResponse struct {
	Updated int64 `json:"updated"`
}

// AdminBroadcastNotificationResponse summarizes a role/all-users broadcast.
type AdminBroadcastNotificationResponse struct {
	Recipients      int    `json:"recipients"`
	InboxCreated    int    `json:"inbox_created"`
	EmailsSent      int    `json:"emails_sent"`
	PushDevicesSent int    `json:"push_devices_sent"`
	EmailErrors     int    `json:"email_errors,omitempty"`
	PushErrors      int    `json:"push_errors,omitempty"`
	Error           string `json:"error,omitempty"`
}
