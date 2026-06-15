package responses

import "time"

// EventSettingsResponse is the public/admin view of convention controls.
type EventSettingsResponse struct {
	TicketSalesEnabled        bool      `json:"ticket_sales_enabled"`
	PanelRegistrationEnabled  bool      `json:"panel_registration_enabled"`
	TalentRegistrationEnabled bool      `json:"talent_registration_enabled"`
	DealerRegistrationEnabled bool      `json:"dealer_registration_enabled"`
	ModifiedAt                time.Time `json:"modified_at"`
}
