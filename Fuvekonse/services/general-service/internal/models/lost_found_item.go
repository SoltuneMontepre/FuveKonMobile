package models

import (
	"time"

	"github.com/google/uuid"
)

type LostFoundItemType string

const (
	LostFoundTypeLost  LostFoundItemType = "lost"
	LostFoundTypeFound LostFoundItemType = "found"
)

type LostFoundItemStatus string

const (
	LostFoundStatusOpen     LostFoundItemStatus = "open"
	LostFoundStatusClaimed  LostFoundItemStatus = "claimed"
	LostFoundStatusResolved LostFoundItemStatus = "resolved"
)

// LostFoundItem is a lost-or-found entry created by staff/admin at the event.
type LostFoundItem struct {
	Id                uuid.UUID           `gorm:"type:uuid;primaryKey"`
	DisplayCode       string              `gorm:"type:varchar(20);uniqueIndex"`
	ItemType          LostFoundItemType   `gorm:"type:varchar(20);index;not null"`
	Title             string              `gorm:"type:varchar(255);not null"`
	Description       string              `gorm:"type:text"`
	Location          string              `gorm:"type:varchar(255)"`
	ImageUrl          string              `gorm:"type:varchar(500)"`
	ContactInfo       string              `gorm:"type:varchar(500)"`
	StaffNotes        string              `gorm:"type:text"`
	Status            LostFoundItemStatus `gorm:"type:varchar(20);default:'open';index"`
	SubmittedByUserId uuid.UUID           `gorm:"type:uuid;index;not null"`
	RecipientName     string              `gorm:"type:varchar(255)"`
	RecipientIdCard   string              `gorm:"type:varchar(50)"`
	RecipientPhone    string              `gorm:"type:varchar(30)"`
	VerifiedDescription bool              `gorm:"default:false"`
	VerifiedOwnership   bool              `gorm:"default:false"`
	VerifiedIdentity    bool              `gorm:"default:false"`
	ReturnedAt          *time.Time        `gorm:"index"`
	ReturnedByUserId    *uuid.UUID          `gorm:"type:uuid;index"`
	CreatedAt         time.Time           `gorm:"autoCreateTime"`
	ModifiedAt        time.Time           `gorm:"autoUpdateTime"`
	DeletedAt         *time.Time          `gorm:"index"`
	IsDeleted         bool                `gorm:"default:false"`
	SubmittedBy       User                `gorm:"foreignKey:SubmittedByUserId"`
}
