package repositories

import (
	"context"
	"errors"
	"general-service/internal/models"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

var (
	ErrLostFoundClaimNotFound      = errors.New("lost and found claim not found")
	ErrLostFoundClaimAlreadyExists = errors.New("item already has a pending claim")
)

type LostFoundClaimRepository struct {
	db *gorm.DB
}

func NewLostFoundClaimRepository(db *gorm.DB) *LostFoundClaimRepository {
	return &LostFoundClaimRepository{db: db}
}

func (r *LostFoundClaimRepository) Create(ctx context.Context, claim *models.LostFoundClaim) (*models.LostFoundClaim, error) {
	if claim.Id == uuid.Nil {
		claim.Id = uuid.New()
	}
	now := time.Now()
	claim.CreatedAt = now
	claim.ModifiedAt = now

	if err := r.db.WithContext(ctx).Create(claim).Error; err != nil {
		return nil, err
	}
	return claim, nil
}

func (r *LostFoundClaimRepository) GetPendingByItemID(ctx context.Context, itemID uuid.UUID) (*models.LostFoundClaim, error) {
	var claim models.LostFoundClaim
	err := r.db.WithContext(ctx).
		Preload("ClaimedBy").
		Where("item_id = ? AND status = ? AND is_deleted = ?", itemID, models.LostFoundClaimPending, false).
		First(&claim).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrLostFoundClaimNotFound
		}
		return nil, err
	}
	return &claim, nil
}

func (r *LostFoundClaimRepository) GetByItemAndUser(ctx context.Context, itemID, userID uuid.UUID) (*models.LostFoundClaim, error) {
	var claim models.LostFoundClaim
	err := r.db.WithContext(ctx).
		Where("item_id = ? AND claimed_by_user_id = ? AND is_deleted = ?", itemID, userID, false).
		Order("created_at DESC").
		First(&claim).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrLostFoundClaimNotFound
		}
		return nil, err
	}
	return &claim, nil
}

func (r *LostFoundClaimRepository) Update(ctx context.Context, claim *models.LostFoundClaim) (*models.LostFoundClaim, error) {
	claim.ModifiedAt = time.Now()
	if err := r.db.WithContext(ctx).Save(claim).Error; err != nil {
		return nil, err
	}
	return claim, nil
}
