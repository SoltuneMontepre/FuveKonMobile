package models

import (
	role "general-service/internal/common/constants"

	"github.com/google/uuid"
)

// Permission is a granular capability that can be granted to roles or users.
type Permission struct {
	Code    string `gorm:"primaryKey;size:64" json:"code"`
	LabelEn string `gorm:"size:100;not null" json:"label_en"`
	LabelVi string `gorm:"size:100;not null" json:"label_vi"`
}

// RolePermission stores default permissions for each application role.
type RolePermission struct {
	Role           role.UserRole `gorm:"primaryKey" json:"role"`
	PermissionCode string        `gorm:"primaryKey;size:64" json:"permission_code"`
}

// UserPermission stores per-user permission overrides.
// When present, these replace the role defaults for that user.
type UserPermission struct {
	UserID         uuid.UUID `gorm:"primaryKey;type:uuid" json:"user_id"`
	PermissionCode string    `gorm:"primaryKey;size:64" json:"permission_code"`
}
