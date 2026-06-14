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
	ErrScheduleNotFound = errors.New("schedule not found")
	ErrVenueNotFound    = errors.New("venue not found")
	ErrEventNotFound    = errors.New("event not found")
)

type ScheduleRepository struct {
	db *gorm.DB
}

func NewScheduleRepository(db *gorm.DB) *ScheduleRepository {
	return &ScheduleRepository{db: db}
}

func (r *ScheduleRepository) CreateSchedule(ctx context.Context, sched *models.Schedule) (*models.Schedule, error) {
	if sched.Id == uuid.Nil {
		sched.Id = uuid.New()
	}
	now := time.Now()
	sched.CreatedAt = now
	sched.ModifiedAt = now

	// create schedule and nested venues/events in a transaction
	err := r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(sched).Error; err != nil {
			return err
		}

		for i := range sched.Venues {
			v := &sched.Venues[i]
			if v.Id == uuid.Nil {
				v.Id = uuid.New()
			}
			v.ScheduleId = sched.Id
			v.CreatedAt = now
			v.ModifiedAt = now
			if err := tx.Create(v).Error; err != nil {
				return err
			}

			for j := range v.Events {
				e := &v.Events[j]
				if e.Id == uuid.Nil {
					e.Id = uuid.New()
				}
				e.ScheduleId = sched.Id
				vid := v.Id
				e.VenueId = &vid
				e.CreatedAt = now
				e.ModifiedAt = now
				if err := tx.Create(e).Error; err != nil {
					return err
				}
			}
		}

		return nil
	})

	if err != nil {
		return nil, err
	}

	// reload with preloads
	return r.GetScheduleByID(ctx, sched.Id)
}

func (r *ScheduleRepository) GetScheduleByID(ctx context.Context, id uuid.UUID) (*models.Schedule, error) {
	var s models.Schedule
	err := r.db.WithContext(ctx).
		Preload("Venues.Events").
		Where("id = ? AND is_deleted = ?", id, false).
		First(&s).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrScheduleNotFound
		}
		return nil, err
	}
	return &s, nil
}

func (r *ScheduleRepository) ListSchedules(ctx context.Context) ([]models.Schedule, error) {
	var out []models.Schedule
	err := r.db.WithContext(ctx).
		Preload("Venues.Events").
		Where("is_deleted = ?", false).
		Order("start_at ASC").
		Find(&out).Error
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (r *ScheduleRepository) UpdateSchedule(ctx context.Context, id uuid.UUID, updates *models.Schedule) (*models.Schedule, error) {
	existing, err := r.GetScheduleByID(ctx, id)
	if err != nil {
		return nil, err
	}

	if updates.Name != "" {
		existing.Name = updates.Name
	}
	if updates.StartAt != nil {
		existing.StartAt = updates.StartAt
	}
	if updates.EndAt != nil {
		existing.EndAt = updates.EndAt
	}
	existing.ModifiedAt = time.Now()

	if err := r.db.WithContext(ctx).Model(&models.Schedule{}).
		Where("id = ?", id).
		Updates(existing).Error; err != nil {
		return nil, err
	}

	return r.GetScheduleByID(ctx, id)
}

func (r *ScheduleRepository) DeleteSchedule(ctx context.Context, id uuid.UUID) error {
	_, err := r.GetScheduleByID(ctx, id)
	if err != nil {
		return err
	}
	now := time.Now()
	return r.db.WithContext(ctx).Model(&models.Schedule{}).
		Where("id = ?", id).
		Updates(map[string]interface{}{
			"is_deleted": true,
			"deleted_at": now,
		}).Error
}

// CreateVenue creates a new venue under a schedule (optionally with nested events).
func (r *ScheduleRepository) CreateVenue(ctx context.Context, scheduleID uuid.UUID, v *models.ScheduleVenue) (*models.ScheduleVenue, error) {
	// verify schedule exists
	var s models.Schedule
	if err := r.db.WithContext(ctx).Where("id = ? AND is_deleted = ?", scheduleID, false).First(&s).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrScheduleNotFound
		}
		return nil, err
	}

	if v.Id == uuid.Nil {
		v.Id = uuid.New()
	}
	v.ScheduleId = scheduleID
	now := time.Now()
	v.CreatedAt = now
	v.ModifiedAt = now

	// create venue and nested events in a transaction
	err := r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(v).Error; err != nil {
			return err
		}
		for i := range v.Events {
			e := &v.Events[i]
			if e.Id == uuid.Nil {
				e.Id = uuid.New()
			}
			e.ScheduleId = scheduleID
			vid := v.Id
			e.VenueId = &vid
			e.CreatedAt = now
			e.ModifiedAt = now
			if err := tx.Create(e).Error; err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return r.GetVenueByID(ctx, v.Id)
}

// GetVenueByID fetches a venue and its events by id.
func (r *ScheduleRepository) GetVenueByID(ctx context.Context, id uuid.UUID) (*models.ScheduleVenue, error) {
	var v models.ScheduleVenue
	err := r.db.WithContext(ctx).
		Preload("Events").
		Where("id = ? AND is_deleted = ?", id, false).
		First(&v).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrVenueNotFound
		}
		return nil, err
	}
	return &v, nil
}

// ListVenuesBySchedule lists venues for a schedule (including events).
func (r *ScheduleRepository) ListVenuesBySchedule(ctx context.Context, scheduleID uuid.UUID) ([]models.ScheduleVenue, error) {
	var out []models.ScheduleVenue
	err := r.db.WithContext(ctx).
		Preload("Events").
		Where("schedule_id = ? AND is_deleted = ?", scheduleID, false).
		Order("order ASC").
		Find(&out).Error
	if err != nil {
		return nil, err
	}
	return out, nil
}

// UpdateVenue updates venue fields specified in the updates map.
func (r *ScheduleRepository) UpdateVenue(ctx context.Context, id uuid.UUID, updates map[string]interface{}) (*models.ScheduleVenue, error) {
	if _, err := r.GetVenueByID(ctx, id); err != nil {
		return nil, err
	}
	updates["modified_at"] = time.Now()
	if err := r.db.WithContext(ctx).Model(&models.ScheduleVenue{}).
		Where("id = ?", id).
		Updates(updates).Error; err != nil {
		return nil, err
	}
	return r.GetVenueByID(ctx, id)
}

// DeleteVenue marks a venue as deleted.
func (r *ScheduleRepository) DeleteVenue(ctx context.Context, id uuid.UUID) error {
	if _, err := r.GetVenueByID(ctx, id); err != nil {
		return err
	}
	now := time.Now()
	return r.db.WithContext(ctx).Model(&models.ScheduleVenue{}).
		Where("id = ?", id).
		Updates(map[string]interface{}{
			"is_deleted":  true,
			"deleted_at":  now,
			"modified_at": now,
		}).Error
}

// CreateEvent creates an event under a schedule with optional venue association.
func (r *ScheduleRepository) CreateEvent(ctx context.Context, scheduleID uuid.UUID, venueID *uuid.UUID, e *models.ScheduleEvent) (*models.ScheduleEvent, error) {
	// verify schedule exists
	var s models.Schedule
	if err := r.db.WithContext(ctx).Where("id = ? AND is_deleted = ?", scheduleID, false).First(&s).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrScheduleNotFound
		}
		return nil, err
	}
	// if venue provided, verify it exists
	if venueID != nil {
		var v models.ScheduleVenue
		if err := r.db.WithContext(ctx).Where("id = ? AND is_deleted = ?", *venueID, false).First(&v).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return nil, ErrVenueNotFound
			}
			return nil, err
		}
	}

	if e.Id == uuid.Nil {
		e.Id = uuid.New()
	}
	e.ScheduleId = scheduleID
	e.VenueId = venueID
	now := time.Now()
	e.CreatedAt = now
	e.ModifiedAt = now

	if err := r.db.WithContext(ctx).Create(e).Error; err != nil {
		return nil, err
	}
	return r.GetEventByID(ctx, e.Id)
}

// GetEventByID fetches an event by id.
func (r *ScheduleRepository) GetEventByID(ctx context.Context, id uuid.UUID) (*models.ScheduleEvent, error) {
	var e models.ScheduleEvent
	err := r.db.WithContext(ctx).
		Where("id = ? AND is_deleted = ?", id, false).
		First(&e).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrEventNotFound
		}
		return nil, err
	}
	return &e, nil
}

// ListEventsByVenue lists events for a given venue.
func (r *ScheduleRepository) ListEventsByVenue(ctx context.Context, venueID uuid.UUID) ([]models.ScheduleEvent, error) {
	var out []models.ScheduleEvent
	err := r.db.WithContext(ctx).
		Where("venue_id = ? AND is_deleted = ?", venueID, false).
		Order("start_at ASC").
		Find(&out).Error
	if err != nil {
		return nil, err
	}
	return out, nil
}

// UpdateEvent updates event fields specified in the updates map.
func (r *ScheduleRepository) UpdateEvent(ctx context.Context, id uuid.UUID, updates map[string]interface{}) (*models.ScheduleEvent, error) {
	if _, err := r.GetEventByID(ctx, id); err != nil {
		return nil, err
	}
	updates["modified_at"] = time.Now()
	if err := r.db.WithContext(ctx).Model(&models.ScheduleEvent{}).
		Where("id = ?", id).
		Updates(updates).Error; err != nil {
		return nil, err
	}
	return r.GetEventByID(ctx, id)
}

// DeleteEvent marks an event as deleted.
func (r *ScheduleRepository) DeleteEvent(ctx context.Context, id uuid.UUID) error {
	if _, err := r.GetEventByID(ctx, id); err != nil {
		return err
	}
	now := time.Now()
	return r.db.WithContext(ctx).Model(&models.ScheduleEvent{}).
		Where("id = ?", id).
		Updates(map[string]interface{}{
			"is_deleted":  true,
			"deleted_at":  now,
			"modified_at": now,
		}).Error
}
