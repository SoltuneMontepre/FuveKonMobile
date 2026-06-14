package repositories

import (
	"context"
	"errors"
	"general-service/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

var ErrDeviceTokenNotFound = errors.New("device token not found")

type DeviceTokenRepository struct {
	db *gorm.DB
}

func NewDeviceTokenRepository(db *gorm.DB) *DeviceTokenRepository {
	return &DeviceTokenRepository{db: db}
}

// Upsert creates or updates a token row. The token string is globally unique; reassignment updates user/platform/device.
func (r *DeviceTokenRepository) Upsert(ctx context.Context, dt *models.DeviceToken) error {
	var existing models.DeviceToken
	err := r.db.WithContext(ctx).Where("token = ?", dt.Token).First(&existing).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return r.db.WithContext(ctx).Create(dt).Error
	}
	if err != nil {
		return err
	}

	existing.UserId = dt.UserId
	existing.Platform = dt.Platform
	existing.DeviceId = dt.DeviceId
	return r.db.WithContext(ctx).Save(&existing).Error
}

func (r *DeviceTokenRepository) ListByUserID(ctx context.Context, userID uuid.UUID) ([]models.DeviceToken, error) {
	var list []models.DeviceToken
	err := r.db.WithContext(ctx).Where("user_id = ?", userID).Find(&list).Error
	return list, err
}

func (r *DeviceTokenRepository) DeleteOwnedByToken(ctx context.Context, userID uuid.UUID, token string) error {
	res := r.db.WithContext(ctx).Where("user_id = ? AND token = ?", userID, token).Delete(&models.DeviceToken{})
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return ErrDeviceTokenNotFound
	}
	return nil
}

func (r *DeviceTokenRepository) DeleteByTokens(ctx context.Context, tokens []string) error {
	if len(tokens) == 0 {
		return nil
	}
	return r.db.WithContext(ctx).Where("token IN ?", tokens).Delete(&models.DeviceToken{}).Error
}
