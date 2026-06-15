package repositories

import (
	"context"
	"errors"
	"general-service/internal/models"

	"gorm.io/gorm"
)

var (
	ErrTicketSalesClosed          = errors.New("ticket sales are currently closed")
	ErrPanelRegistrationClosed    = errors.New("panel registration is currently closed")
	ErrTalentRegistrationClosed   = errors.New("talent registration is currently closed")
	ErrDealerRegistrationClosed   = errors.New("dealer registration is currently closed")
)

type EventSettingsRepository struct {
	db *gorm.DB
}

func NewEventSettingsRepository(db *gorm.DB) *EventSettingsRepository {
	return &EventSettingsRepository{db: db}
}

func defaultEventSettings() models.EventSettings {
	return models.EventSettings{
		ID:                        models.DefaultEventSettingsID,
		TicketSalesEnabled:        true,
		PanelRegistrationEnabled:  true,
		TalentRegistrationEnabled: true,
		DealerRegistrationEnabled: true,
	}
}

// GetOrCreate returns the singleton event settings row, creating defaults if missing.
func (r *EventSettingsRepository) GetOrCreate(ctx context.Context) (*models.EventSettings, error) {
	var settings models.EventSettings
	err := r.db.WithContext(ctx).First(&settings, "id = ?", models.DefaultEventSettingsID).Error
	if err == nil {
		return &settings, nil
	}
	if !errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, err
	}

	settings = defaultEventSettings()
	if err := r.db.WithContext(ctx).Create(&settings).Error; err != nil {
		return nil, err
	}
	return &settings, nil
}

// Update applies partial updates to the singleton settings row.
func (r *EventSettingsRepository) Update(ctx context.Context, updates map[string]interface{}) (*models.EventSettings, error) {
	if _, err := r.GetOrCreate(ctx); err != nil {
		return nil, err
	}

	if err := r.db.WithContext(ctx).
		Model(&models.EventSettings{}).
		Where("id = ?", models.DefaultEventSettingsID).
		Updates(updates).Error; err != nil {
		return nil, err
	}

	return r.GetOrCreate(ctx)
}

// IsTicketSalesOpen reports whether ticket purchases/upgrades are allowed.
func (r *EventSettingsRepository) IsTicketSalesOpen(ctx context.Context) (bool, error) {
	settings, err := r.GetOrCreate(ctx)
	if err != nil {
		return false, err
	}
	return settings.TicketSalesEnabled, nil
}

func (r *EventSettingsRepository) IsPanelRegistrationOpen(ctx context.Context) (bool, error) {
	settings, err := r.GetOrCreate(ctx)
	if err != nil {
		return false, err
	}
	return settings.PanelRegistrationEnabled, nil
}

func (r *EventSettingsRepository) IsTalentRegistrationOpen(ctx context.Context) (bool, error) {
	settings, err := r.GetOrCreate(ctx)
	if err != nil {
		return false, err
	}
	return settings.TalentRegistrationEnabled, nil
}

func (r *EventSettingsRepository) IsDealerRegistrationOpen(ctx context.Context) (bool, error) {
	settings, err := r.GetOrCreate(ctx)
	if err != nil {
		return false, err
	}
	return settings.DealerRegistrationEnabled, nil
}
