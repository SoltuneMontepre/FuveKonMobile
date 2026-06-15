package services

import (
	"context"
	"errors"
	"strings"

	"general-service/internal/dto/device/requests"
	"general-service/internal/dto/device/responses"
	"general-service/internal/models"
	"general-service/internal/repositories"

	"github.com/google/uuid"
)

var (
	ErrInvalidFCMPlatform = errors.New("platform must be ios or android")
)

type DeviceTokenService struct {
	repos *repositories.Repositories
}

func NewDeviceTokenService(repos *repositories.Repositories) *DeviceTokenService {
	return &DeviceTokenService{repos: repos}
}

func (s *DeviceTokenService) Register(ctx context.Context, userIDStr string, req *requests.RegisterFCMTokenRequest) (*responses.DeviceTokenResponse, error) {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errors.New("invalid user id")
	}

	platform := strings.ToLower(strings.TrimSpace(req.Platform))
	if platform != "ios" && platform != "android" {
		return nil, ErrInvalidFCMPlatform
	}

	token := strings.TrimSpace(req.Token)
	if token == "" {
		return nil, errors.New("token is required")
	}

	dt := &models.DeviceToken{
		Id:       uuid.New(),
		UserId:   userID,
		Token:    token,
		Platform: platform,
		DeviceId: strings.TrimSpace(req.DeviceId),
	}
	if err := s.repos.DeviceToken.Upsert(ctx, dt); err != nil {
		return nil, err
	}

	return &responses.DeviceTokenResponse{
		Platform: platform,
		DeviceId: dt.DeviceId,
	}, nil
}

func (s *DeviceTokenService) Unregister(ctx context.Context, userIDStr string, req *requests.UnregisterFCMTokenRequest) error {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return errors.New("invalid user id")
	}

	token := strings.TrimSpace(req.Token)
	if token == "" {
		return errors.New("token is required")
	}

	return s.repos.DeviceToken.DeleteOwnedByToken(ctx, userID, token)
}
