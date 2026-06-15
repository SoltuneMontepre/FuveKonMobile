package models

import (
	"time"

	"github.com/google/uuid"
)

// Venue is a global, reusable venue entity that can contain multiple locations.
type Venue struct {
	Id          uuid.UUID  `gorm:"type:uuid;primaryKey"`
	Name        string     `gorm:"type:varchar(255)"`
	Description string     `gorm:"type:varchar(1000)"`
	CreatedAt   time.Time  `gorm:"autoCreateTime"`
	ModifiedAt  time.Time  `gorm:"autoUpdateTime"`
	DeletedAt   *time.Time `gorm:"index"`
	IsDeleted   bool       `gorm:"default:false"`
	Locations   []Location `gorm:"foreignKey:VenueId"`
}

// Location is a global, reusable location belonging to a Venue.
type Location struct {
	Id          uuid.UUID  `gorm:"type:uuid;primaryKey"`
	VenueId     uuid.UUID  `gorm:"type:uuid;index"`
	Name        string     `gorm:"type:varchar(255)"`
	Description string     `gorm:"type:varchar(1000)"`
	Order       int        `gorm:"type:int;default:0"`
	CreatedAt   time.Time  `gorm:"autoCreateTime"`
	ModifiedAt  time.Time  `gorm:"autoUpdateTime"`
	DeletedAt   *time.Time `gorm:"index"`
	IsDeleted   bool       `gorm:"default:false"`
}
