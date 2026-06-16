package models

import (
	"time"

	"github.com/google/uuid"
)

type LostFoundClaimStatus string

const (
	LostFoundClaimPending  LostFoundClaimStatus = "pending"
	LostFoundClaimApproved LostFoundClaimStatus = "approved"
	LostFoundClaimRejected LostFoundClaimStatus = "rejected"
)

// LostFoundClaim records a ticket holder asserting ownership of a found item.
type LostFoundClaim struct {
	Id               uuid.UUID            `gorm:"type:uuid;primaryKey"`
	ItemId           uuid.UUID            `gorm:"type:uuid;index;not null"`
	ClaimedByUserId  uuid.UUID            `gorm:"type:uuid;index;not null"`
	Message          string               `gorm:"type:text"`
	Status           LostFoundClaimStatus `gorm:"type:varchar(20);default:'pending';index"`
	ReviewedAt       *time.Time           `gorm:"index"`
	ReviewedByUserId *uuid.UUID           `gorm:"type:uuid;index"`
	CreatedAt        time.Time            `gorm:"autoCreateTime"`
	ModifiedAt       time.Time            `gorm:"autoUpdateTime"`
	DeletedAt        *time.Time           `gorm:"index"`
	IsDeleted        bool                 `gorm:"default:false"`
	Item             LostFoundItem        `gorm:"foreignKey:ItemId"`
	ClaimedBy        User                 `gorm:"foreignKey:ClaimedByUserId"`
}
