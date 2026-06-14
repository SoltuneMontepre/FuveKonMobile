package models

import (
	"time"

	"github.com/google/uuid"
)

// Schedule represents a day's schedule containing venues and events.
type Schedule struct {
	Id         uuid.UUID       `gorm:"type:uuid;primaryKey"`
	Name       string          `gorm:"type:varchar(255)"`
	StartAt    *time.Time      `gorm:"index"`
	EndAt      *time.Time      `gorm:"index"`
	CreatedAt  time.Time       `gorm:"autoCreateTime"`
	ModifiedAt time.Time       `gorm:"autoUpdateTime"`
	DeletedAt  *time.Time      `gorm:"index"`
	IsDeleted  bool            `gorm:"default:false"`
	Venues     []ScheduleVenue `gorm:"foreignKey:ScheduleId"`
}

// ScheduleVenue is one venue/track within a schedule and can contain many events.
type ScheduleVenue struct {
	Id          uuid.UUID       `gorm:"type:uuid;primaryKey"`
	ScheduleId  uuid.UUID       `gorm:"type:uuid;index"`
	Name        string          `gorm:"type:varchar(255)"`
	Description string          `gorm:"type:varchar(1000)"`
	Order       int             `gorm:"type:int;default:0"`
	CreatedAt   time.Time       `gorm:"autoCreateTime"`
	ModifiedAt  time.Time       `gorm:"autoUpdateTime"`
	DeletedAt   *time.Time      `gorm:"index"`
	IsDeleted   bool            `gorm:"default:false"`
	Events      []ScheduleEvent `gorm:"foreignKey:VenueId"`
}

// ScheduleEvent is a scheduled item that may belong to a specific venue.
type ScheduleEvent struct {
	Id          uuid.UUID  `gorm:"type:uuid;primaryKey"`
	ScheduleId  uuid.UUID  `gorm:"type:uuid;index"`
	VenueId     *uuid.UUID `gorm:"type:uuid;index;null"`
	Title       string     `gorm:"type:varchar(255)"`
	Description string     `gorm:"type:varchar(1000)"`
	StartAt     time.Time  `gorm:"index"`
	EndAt       time.Time  `gorm:"index"`
	CreatedAt   time.Time  `gorm:"autoCreateTime"`
	ModifiedAt  time.Time  `gorm:"autoUpdateTime"`
	DeletedAt   *time.Time `gorm:"index"`
	IsDeleted   bool       `gorm:"default:false"`
}
