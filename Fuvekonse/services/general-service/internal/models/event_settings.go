package models

import (
	"time"

	"github.com/google/uuid"
)

// DefaultEventSettingsID is the fixed primary key for the singleton event settings row.
var DefaultEventSettingsID = uuid.MustParse("00000000-0000-0000-0000-000000000001")

// EventSettings stores convention-wide controls (registrations on/off, etc.).
// The table holds a single row identified by DefaultEventSettingsID.
type EventSettings struct {
	ID                         uuid.UUID `gorm:"type:uuid;primaryKey" json:"id"`
	TicketSalesEnabled         bool      `gorm:"default:true" json:"ticket_sales_enabled"`
	PanelRegistrationEnabled   bool      `gorm:"default:true" json:"panel_registration_enabled"`
	TalentRegistrationEnabled  bool      `gorm:"default:true" json:"talent_registration_enabled"`
	DealerRegistrationEnabled  bool      `gorm:"default:true" json:"dealer_registration_enabled"`
	ModifiedAt                 time.Time `gorm:"autoUpdateTime" json:"modified_at"`
}
