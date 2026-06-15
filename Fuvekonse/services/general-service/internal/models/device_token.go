package models

import (
	"time"

	"github.com/google/uuid"
)

// DeviceToken stores an FCM registration token for a user's mobile device.
type DeviceToken struct {
	Id        uuid.UUID `gorm:"type:uuid;primaryKey" json:"id"`
	UserId    uuid.UUID `gorm:"type:uuid;index" json:"user_id"`
	Token     string    `gorm:"type:varchar(512);uniqueIndex" json:"token"`
	Platform  string    `gorm:"type:varchar(20)" json:"platform"` // ios, android
	DeviceId  string    `gorm:"type:varchar(255);index" json:"device_id,omitempty"`
	CreatedAt time.Time `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt time.Time `gorm:"autoUpdateTime" json:"updated_at"`
	User      User      `gorm:"foreignKey:UserId" json:"-"`
}
