package models

import (
	"time"

	"github.com/google/uuid"
)

// Notification is a per-user inbox row (e.g. ticket updates, system messages).
type Notification struct {
	Id        uuid.UUID  `gorm:"type:uuid;primaryKey" json:"id"`
	UserId    uuid.UUID  `gorm:"type:uuid;index" json:"user_id"`
	Title     string     `gorm:"type:varchar(255)" json:"title"`
	Body      string     `gorm:"type:text" json:"body"`
	Kind      string     `gorm:"type:varchar(50);index" json:"kind"` // e.g. ticket, system, dealer
	ReadAt    *time.Time `gorm:"index" json:"read_at,omitempty"`
	CreatedAt time.Time  `gorm:"autoCreateTime" json:"created_at"`
	User      User       `gorm:"foreignKey:UserId" json:"-"`
}
