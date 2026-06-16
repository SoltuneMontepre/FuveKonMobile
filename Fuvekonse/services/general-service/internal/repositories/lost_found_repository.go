package repositories

import (
	"context"
	"errors"
	"general-service/internal/dto/lostfound/requests"
	"general-service/internal/models"
	"strings"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

var ErrLostFoundNotFound = errors.New("lost and found item not found")

type LostFoundRepository struct {
	db *gorm.DB
}

func NewLostFoundRepository(db *gorm.DB) *LostFoundRepository {
	return &LostFoundRepository{db: db}
}

func (r *LostFoundRepository) Create(ctx context.Context, item *models.LostFoundItem) (*models.LostFoundItem, error) {
	if item.Id == uuid.Nil {
		item.Id = uuid.New()
	}
	item.CreatedAt = time.Now()
	item.ModifiedAt = time.Now()

	if err := r.db.WithContext(ctx).Create(item).Error; err != nil {
		return nil, err
	}
	return item, nil
}

func (r *LostFoundRepository) GetByID(ctx context.Context, id uuid.UUID) (*models.LostFoundItem, error) {
	var item models.LostFoundItem
	err := r.db.WithContext(ctx).
		Where("id = ? AND is_deleted = ?", id, false).
		First(&item).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrLostFoundNotFound
		}
		return nil, err
	}
	return &item, nil
}

func (r *LostFoundRepository) List(ctx context.Context, q requests.ListLostFoundQuery) ([]models.LostFoundItem, int64, error) {
	page := q.Page
	if page < 1 {
		page = 1
	}
	pageSize := q.PageSize
	if pageSize < 1 {
		pageSize = 20
	}
	if pageSize > 100 {
		pageSize = 100
	}

	base := r.db.WithContext(ctx).Model(&models.LostFoundItem{}).Where("is_deleted = ?", false)

	if itemType := strings.TrimSpace(q.ItemType); itemType != "" {
		base = base.Where("item_type = ?", itemType)
	}
	if status := strings.TrimSpace(q.Status); status != "" {
		base = base.Where("status = ?", status)
	}
	if search := strings.TrimSpace(q.Search); search != "" {
		like := "%" + search + "%"
		base = base.Where(
			"title ILIKE ? OR description ILIKE ? OR location ILIKE ? OR contact_info ILIKE ? OR display_code ILIKE ?",
			like, like, like, like, like,
		)
	}

	var total int64
	if err := base.Count(&total).Error; err != nil {
		return nil, 0, err
	}

	var items []models.LostFoundItem
	offset := (page - 1) * pageSize
	err := base.
		Order("created_at DESC").
		Limit(pageSize).
		Offset(offset).
		Find(&items).Error
	if err != nil {
		return nil, 0, err
	}

	return items, total, nil
}

func (r *LostFoundRepository) Update(ctx context.Context, item *models.LostFoundItem) (*models.LostFoundItem, error) {
	if _, err := r.GetByID(ctx, item.Id); err != nil {
		return nil, err
	}

	item.ModifiedAt = time.Now()
	if err := r.db.WithContext(ctx).Save(item).Error; err != nil {
		return nil, err
	}
	return item, nil
}

func (r *LostFoundRepository) SetStatus(ctx context.Context, id uuid.UUID, status models.LostFoundItemStatus) error {
	if _, err := r.GetByID(ctx, id); err != nil {
		return err
	}

	return r.db.WithContext(ctx).Model(&models.LostFoundItem{}).
		Where("id = ?", id).
		Updates(map[string]interface{}{
			"status":      status,
			"modified_at": time.Now(),
		}).Error
}

func (r *LostFoundRepository) Delete(ctx context.Context, id uuid.UUID) error {
	if _, err := r.GetByID(ctx, id); err != nil {
		return err
	}

	now := time.Now()
	return r.db.WithContext(ctx).Model(&models.LostFoundItem{}).
		Where("id = ?", id).
		Updates(map[string]interface{}{
			"is_deleted": true,
			"deleted_at": now,
			"modified_at": now,
		}).Error
}
