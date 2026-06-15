package services

import (
	"context"
	"general-service/internal/dto/event/requests"
	"general-service/internal/dto/event/responses"
	"general-service/internal/models"
	"general-service/internal/repositories"
)

type EventService struct {
	repos *repositories.Repositories
}

func NewEventService(repos *repositories.Repositories) *EventService {
	return &EventService{repos: repos}
}

func (s *EventService) GetSettings(ctx context.Context) (*responses.EventSettingsResponse, error) {
	settings, err := s.repos.Event.GetOrCreate(ctx)
	if err != nil {
		return nil, err
	}
	return mapEventSettings(settings), nil
}

func (s *EventService) UpdateSettingsForAdmin(ctx context.Context, req *requests.UpdateEventSettingsRequest) (*responses.EventSettingsResponse, error) {
	updates := make(map[string]interface{})
	if req.TicketSalesEnabled != nil {
		updates["ticket_sales_enabled"] = *req.TicketSalesEnabled
	}
	if req.PanelRegistrationEnabled != nil {
		updates["panel_registration_enabled"] = *req.PanelRegistrationEnabled
	}
	if req.TalentRegistrationEnabled != nil {
		updates["talent_registration_enabled"] = *req.TalentRegistrationEnabled
	}
	if req.DealerRegistrationEnabled != nil {
		updates["dealer_registration_enabled"] = *req.DealerRegistrationEnabled
	}
	if len(updates) == 0 {
		return s.GetSettings(ctx)
	}

	updated, err := s.repos.Event.Update(ctx, updates)
	if err != nil {
		return nil, err
	}
	return mapEventSettings(updated), nil
}

func (s *EventService) SetTicketSalesOpenForAdmin(ctx context.Context, open bool) (*responses.EventSettingsResponse, error) {
	return s.updateFlag(ctx, "ticket_sales_enabled", open)
}

func (s *EventService) SetPanelRegistrationOpenForAdmin(ctx context.Context, open bool) (*responses.EventSettingsResponse, error) {
	return s.updateFlag(ctx, "panel_registration_enabled", open)
}

func (s *EventService) SetTalentRegistrationOpenForAdmin(ctx context.Context, open bool) (*responses.EventSettingsResponse, error) {
	return s.updateFlag(ctx, "talent_registration_enabled", open)
}

func (s *EventService) SetDealerRegistrationOpenForAdmin(ctx context.Context, open bool) (*responses.EventSettingsResponse, error) {
	return s.updateFlag(ctx, "dealer_registration_enabled", open)
}

func (s *EventService) IsTicketSalesOpen(ctx context.Context) (bool, error) {
	return s.repos.Event.IsTicketSalesOpen(ctx)
}

func (s *EventService) updateFlag(ctx context.Context, column string, open bool) (*responses.EventSettingsResponse, error) {
	updated, err := s.repos.Event.Update(ctx, map[string]interface{}{column: open})
	if err != nil {
		return nil, err
	}
	return mapEventSettings(updated), nil
}

func mapEventSettings(settings *models.EventSettings) *responses.EventSettingsResponse {
	return &responses.EventSettingsResponse{
		TicketSalesEnabled:        settings.TicketSalesEnabled,
		PanelRegistrationEnabled:  settings.PanelRegistrationEnabled,
		TalentRegistrationEnabled: settings.TalentRegistrationEnabled,
		DealerRegistrationEnabled: settings.DealerRegistrationEnabled,
		ModifiedAt:                settings.ModifiedAt,
	}
}
