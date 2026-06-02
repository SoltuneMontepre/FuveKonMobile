package repositories

import (
	"context"
	"errors"
	"general-service/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

var ErrNotificationNotFound = errors.New("notification not found")

type NotificationRepository struct {
	db *gorm.DB
}

func NewNotificationRepository(db *gorm.DB) *NotificationRepository {
	return &NotificationRepository{db: db}
}

func (r *NotificationRepository) Create(ctx context.Context, n *models.Notification) error {
	return r.db.WithContext(ctx).Create(n).Error
}

// GetOwnedByID returns a notification only if it belongs to userID.
func (r *NotificationRepository) GetOwnedByID(ctx context.Context, userID, id uuid.UUID) (*models.Notification, error) {
	var n models.Notification
	err := r.db.WithContext(ctx).
		Where("id = ? AND user_id = ?", id, userID).
		First(&n).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrNotificationNotFound
		}
		return nil, err
	}
	return &n, nil
}

func (r *NotificationRepository) ListByUserID(ctx context.Context, userID uuid.UUID) ([]models.Notification, error) {
	var list []models.Notification
	err := r.db.WithContext(ctx).
		Where("user_id = ?", userID).
		Order("created_at DESC").
		Find(&list).Error
	return list, err
}

func (r *NotificationRepository) Save(ctx context.Context, n *models.Notification) error {
	return r.db.WithContext(ctx).Save(n).Error
}

func (r *NotificationRepository) DeleteOwned(ctx context.Context, userID, id uuid.UUID) error {
	res := r.db.WithContext(ctx).
		Where("id = ? AND user_id = ?", id, userID).
		Delete(&models.Notification{})
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return ErrNotificationNotFound
	}
	return nil
}
