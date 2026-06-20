package repositories

import (
	"context"
	"errors"
	"general-service/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

var ErrNotificationNotFound = errors.New("notification not found")

type NotificationListFilter struct {
	UserID     *uuid.UUID
	Kind       string
	UnreadOnly bool
	Page       int
	PageSize   int
}

type NotificationRepository struct {
	db *gorm.DB
}

func NewNotificationRepository(db *gorm.DB) *NotificationRepository {
	return &NotificationRepository{db: db}
}

func (r *NotificationRepository) Create(ctx context.Context, n *models.Notification) error {
	return r.db.WithContext(ctx).Create(n).Error
}

func (r *NotificationRepository) CreateBatch(ctx context.Context, notifications []models.Notification) error {
	if len(notifications) == 0 {
		return nil
	}
	return r.db.WithContext(ctx).CreateInBatches(notifications, 100).Error
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

func (r *NotificationRepository) applyListFilter(q *gorm.DB, filter NotificationListFilter) *gorm.DB {
	if filter.UserID != nil {
		q = q.Where("user_id = ?", *filter.UserID)
	}
	if filter.Kind != "" {
		q = q.Where("kind = ?", filter.Kind)
	}
	if filter.UnreadOnly {
		q = q.Where("read_at IS NULL")
	}
	return q
}

func (r *NotificationRepository) ListFiltered(ctx context.Context, filter NotificationListFilter) ([]models.Notification, int64, error) {
	base := r.db.WithContext(ctx).Model(&models.Notification{})
	base = r.applyListFilter(base, filter)

	var total int64
	if err := base.Count(&total).Error; err != nil {
		return nil, 0, err
	}

	page := filter.Page
	if page < 1 {
		page = 1
	}
	pageSize := filter.PageSize
	if pageSize <= 0 {
		pageSize = 50
	}
	offset := (page - 1) * pageSize

	var list []models.Notification
	err := r.applyListFilter(r.db.WithContext(ctx), filter).
		Order("created_at DESC").
		Offset(offset).
		Limit(pageSize).
	Find(&list).Error
	return list, total, err
}

func (r *NotificationRepository) ListByUserID(ctx context.Context, userID uuid.UUID) ([]models.Notification, error) {
	list, _, err := r.ListFiltered(ctx, NotificationListFilter{
		UserID:   &userID,
		Page:     1,
		PageSize: 10000,
	})
	return list, err
}

func (r *NotificationRepository) CountUnreadByUserID(ctx context.Context, userID uuid.UUID) (int64, error) {
	var count int64
	err := r.db.WithContext(ctx).Model(&models.Notification{}).
		Where("user_id = ? AND read_at IS NULL", userID).
		Count(&count).Error
	return count, err
}

func (r *NotificationRepository) MarkAllReadByUserID(ctx context.Context, userID uuid.UUID) (int64, error) {
	now := r.db.NowFunc()
	res := r.db.WithContext(ctx).Model(&models.Notification{}).
		Where("user_id = ? AND read_at IS NULL", userID).
		Update("read_at", now)
	return res.RowsAffected, res.Error
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
