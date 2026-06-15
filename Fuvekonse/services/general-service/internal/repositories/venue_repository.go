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
	ErrGlobalVenueNotFound = errors.New("venue not found")
	ErrLocationNotFound    = errors.New("location not found")
)

type VenueRepository struct {
	db *gorm.DB
}

func NewVenueRepository(db *gorm.DB) *VenueRepository {
	return &VenueRepository{db: db}
}

func (r *VenueRepository) CreateVenue(ctx context.Context, v *models.Venue) (*models.Venue, error) {
	if v.Id == uuid.Nil {
		v.Id = uuid.New()
	}
	now := time.Now()
	v.CreatedAt = now
	v.ModifiedAt = now

	if err := r.db.WithContext(ctx).Create(v).Error; err != nil {
		return nil, err
	}
	return r.GetVenueByID(ctx, v.Id)
}

func (r *VenueRepository) GetVenueByID(ctx context.Context, id uuid.UUID) (*models.Venue, error) {
	var v models.Venue
	err := r.db.WithContext(ctx).
		Preload("Locations").
		Where("id = ? AND is_deleted = ?", id, false).
		First(&v).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrGlobalVenueNotFound
		}
		return nil, err
	}
	return &v, nil
}

func (r *VenueRepository) ListVenues(ctx context.Context) ([]models.Venue, error) {
	var out []models.Venue
	err := r.db.WithContext(ctx).
		Preload("Locations").
		Where("is_deleted = ?", false).
		Find(&out).Error
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (r *VenueRepository) UpdateVenue(ctx context.Context, id uuid.UUID, updates map[string]interface{}) (*models.Venue, error) {
	if _, err := r.GetVenueByID(ctx, id); err != nil {
		return nil, err
	}
	updates["modified_at"] = time.Now()
	if err := r.db.WithContext(ctx).Model(&models.Venue{}).
		Where("id = ?", id).
		Updates(updates).Error; err != nil {
		return nil, err
	}
	return r.GetVenueByID(ctx, id)
}

func (r *VenueRepository) DeleteVenue(ctx context.Context, id uuid.UUID) error {
	if _, err := r.GetVenueByID(ctx, id); err != nil {
		return err
	}
	now := time.Now()
	return r.db.WithContext(ctx).Model(&models.Venue{}).
		Where("id = ?", id).
		Updates(map[string]interface{}{
			"is_deleted":  true,
			"deleted_at":  now,
			"modified_at": now,
		}).Error
}

// Location management
func (r *VenueRepository) CreateLocation(ctx context.Context, venueID uuid.UUID, l *models.Location) (*models.Location, error) {
	// verify venue exists
	var v models.Venue
	if err := r.db.WithContext(ctx).Where("id = ? AND is_deleted = ?", venueID, false).First(&v).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrGlobalVenueNotFound
		}
		return nil, err
	}

	if l.Id == uuid.Nil {
		l.Id = uuid.New()
	}
	l.VenueId = venueID
	now := time.Now()
	l.CreatedAt = now
	l.ModifiedAt = now

	if err := r.db.WithContext(ctx).Create(l).Error; err != nil {
		return nil, err
	}
	return r.GetLocationByID(ctx, l.Id)
}

func (r *VenueRepository) GetLocationByID(ctx context.Context, id uuid.UUID) (*models.Location, error) {
	var l models.Location
	err := r.db.WithContext(ctx).
		Where("id = ? AND is_deleted = ?", id, false).
		First(&l).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrLocationNotFound
		}
		return nil, err
	}
	return &l, nil
}

func (r *VenueRepository) ListLocationsByVenue(ctx context.Context, venueID uuid.UUID) ([]models.Location, error) {
	var out []models.Location
	err := r.db.WithContext(ctx).
		Where("venue_id = ? AND is_deleted = ?", venueID, false).
		Order("order ASC").
		Find(&out).Error
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (r *VenueRepository) UpdateLocation(ctx context.Context, id uuid.UUID, updates map[string]interface{}) (*models.Location, error) {
	if _, err := r.GetLocationByID(ctx, id); err != nil {
		return nil, err
	}
	updates["modified_at"] = time.Now()
	if err := r.db.WithContext(ctx).Model(&models.Location{}).
		Where("id = ?", id).
		Updates(updates).Error; err != nil {
		return nil, err
	}
	return r.GetLocationByID(ctx, id)
}

func (r *VenueRepository) DeleteLocation(ctx context.Context, id uuid.UUID) error {
	if _, err := r.GetLocationByID(ctx, id); err != nil {
		return err
	}
	now := time.Now()
	return r.db.WithContext(ctx).Model(&models.Location{}).
		Where("id = ?", id).
		Updates(map[string]interface{}{
			"is_deleted":  true,
			"deleted_at":  now,
			"modified_at": now,
		}).Error
}
