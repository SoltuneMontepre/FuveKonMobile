package repositories

import (
	"context"
	"errors"
	"time"

	"general-service/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

var ErrUserSessionNotFound = errors.New("user session not found")

type UserSessionRepository struct {
	db *gorm.DB
}

func NewUserSessionRepository(db *gorm.DB) *UserSessionRepository {
	return &UserSessionRepository{db: db}
}

// CreateLoginSession revokes any active session for the same user+device_id (when device_id set), then inserts the new row.
func (r *UserSessionRepository) CreateLoginSession(ctx context.Context, session *models.UserSession) error {
	now := time.Now()
	if session.DeviceId != "" {
		_ = r.db.WithContext(ctx).
			Model(&models.UserSession{}).
			Where("user_id = ? AND device_id = ? AND revoked_at IS NULL", session.UserId, session.DeviceId).
			Update("revoked_at", now).Error
	}

	return r.db.WithContext(ctx).Create(session).Error
}

func (r *UserSessionRepository) FindByJTI(ctx context.Context, jti string) (*models.UserSession, error) {
	var session models.UserSession
	err := r.db.WithContext(ctx).Where("jti = ?", jti).First(&session).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, ErrUserSessionNotFound
	}
	if err != nil {
		return nil, err
	}
	return &session, nil
}

func (r *UserSessionRepository) ListActiveByUserID(ctx context.Context, userID uuid.UUID) ([]models.UserSession, error) {
	var list []models.UserSession
	now := time.Now()
	err := r.db.WithContext(ctx).
		Where("user_id = ? AND revoked_at IS NULL AND expires_at > ?", userID, now).
		Order("last_seen_at DESC").
		Find(&list).Error
	return list, err
}

func (r *UserSessionRepository) FindOwnedByID(ctx context.Context, userID, sessionID uuid.UUID) (*models.UserSession, error) {
	var session models.UserSession
	err := r.db.WithContext(ctx).
		Where("id = ? AND user_id = ?", sessionID, userID).
		First(&session).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, ErrUserSessionNotFound
	}
	if err != nil {
		return nil, err
	}
	return &session, nil
}

func (r *UserSessionRepository) RevokeByID(ctx context.Context, userID, sessionID uuid.UUID) error {
	now := time.Now()
	res := r.db.WithContext(ctx).
		Model(&models.UserSession{}).
		Where("id = ? AND user_id = ? AND revoked_at IS NULL", sessionID, userID).
		Update("revoked_at", now)
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return ErrUserSessionNotFound
	}
	return nil
}

func (r *UserSessionRepository) RevokeByJTI(ctx context.Context, jti string) error {
	now := time.Now()
	res := r.db.WithContext(ctx).
		Model(&models.UserSession{}).
		Where("jti = ? AND revoked_at IS NULL", jti).
		Update("revoked_at", now)
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return ErrUserSessionNotFound
	}
	return nil
}

func (r *UserSessionRepository) RevokeAllForUser(ctx context.Context, userID uuid.UUID) error {
	now := time.Now()
	return r.db.WithContext(ctx).
		Model(&models.UserSession{}).
		Where("user_id = ? AND revoked_at IS NULL", userID).
		Update("revoked_at", now).Error
}

func (r *UserSessionRepository) TouchLastSeen(ctx context.Context, sessionID uuid.UUID) error {
	return r.db.WithContext(ctx).
		Model(&models.UserSession{}).
		Where("id = ?", sessionID).
		Update("last_seen_at", time.Now()).Error
}
