package requests

// UpdateEventSettingsRequest updates convention-wide event controls.
// Omitted fields are left unchanged.
type UpdateEventSettingsRequest struct {
	TicketSalesEnabled        *bool `json:"ticket_sales_enabled"`
	PanelRegistrationEnabled  *bool `json:"panel_registration_enabled"`
	TalentRegistrationEnabled *bool `json:"talent_registration_enabled"`
	DealerRegistrationEnabled *bool `json:"dealer_registration_enabled"`
}
