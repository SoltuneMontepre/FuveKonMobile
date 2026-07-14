package models

import (
	"time"

	"github.com/google/uuid"
)

// UserSession tracks a login on a specific device for multi-device session management.
type UserSession struct {
	Id         uuid.UUID  `gorm:"type:uuid;primaryKey" json:"id"`
	UserId     uuid.UUID  `gorm:"type:uuid;index;not null" json:"user_id"`
	JTI        string     `gorm:"type:varchar(64);uniqueIndex;not null" json:"jti"`
	DeviceId   string     `gorm:"type:varchar(255);index" json:"device_id,omitempty"`
	DeviceName string     `gorm:"type:varchar(255)" json:"device_name,omitempty"`
	Platform   string     `gorm:"type:varchar(40)" json:"platform,omitempty"` // ios, android, web, windows, macos, linux
	UserAgent  string     `gorm:"type:varchar(512)" json:"user_agent,omitempty"`
	IPAddress  string     `gorm:"type:varchar(64)" json:"ip_address,omitempty"`
	ExpiresAt  time.Time  `gorm:"index;not null" json:"expires_at"`
	LastSeenAt time.Time  `gorm:"not null" json:"last_seen_at"`
	RevokedAt  *time.Time `gorm:"index" json:"revoked_at,omitempty"`
	CreatedAt  time.Time  `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt  time.Time  `gorm:"autoUpdateTime" json:"updated_at"`
	User       User       `gorm:"foreignKey:UserId" json:"-"`
}
