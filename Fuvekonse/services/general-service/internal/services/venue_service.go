package services

import (
	"context"
	"errors"
	"general-service/internal/models"
	"general-service/internal/repositories"

	"github.com/google/uuid"
)

type VenueService struct {
	repos *repositories.Repositories
}

func NewVenueService(repos *repositories.Repositories) *VenueService {
	return &VenueService{repos: repos}
}

func (s *VenueService) CreateVenue(ctx context.Context, v *models.Venue) (*models.Venue, error) {
	return s.repos.Venue.CreateVenue(ctx, v)
}

func (s *VenueService) CreateLocation(ctx context.Context, venueIDStr string, l *models.Location) (*models.Location, error) {
	vid, err := uuid.Parse(venueIDStr)
	if err != nil {
		return nil, errors.New("invalid venue id")
	}
	return s.repos.Venue.CreateLocation(ctx, vid, l)
}

func (s *VenueService) GetVenueByID(ctx context.Context, idStr string) (*models.Venue, error) {
	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid venue id")
	}
	return s.repos.Venue.GetVenueByID(ctx, id)
}

func (s *VenueService) ListVenues(ctx context.Context) ([]models.Venue, error) {
	return s.repos.Venue.ListVenues(ctx)
}

func (s *VenueService) ListLocationsByVenue(ctx context.Context, venueIDStr string) ([]models.Location, error) {
	vid, err := uuid.Parse(venueIDStr)
	if err != nil {
		return nil, errors.New("invalid venue id")
	}
	return s.repos.Venue.ListLocationsByVenue(ctx, vid)
}
