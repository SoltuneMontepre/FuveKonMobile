package services

import (
	"context"
	"errors"
	"log"
	"time"

	"general-service/internal/dto/notification/requests"
	"general-service/internal/dto/notification/responses"
	"general-service/internal/mappers"
	"general-service/internal/models"
	"general-service/internal/repositories"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

var ErrNotificationTargetUserNotFound = errors.New("target user not found")

type NotificationService struct {
	repos *repositories.Repositories
	mail  *MailService
	fcm   *FCMService
}

func NewNotificationService(repos *repositories.Repositories, mail *MailService, fcm *FCMService) *NotificationService {
	return &NotificationService{repos: repos, mail: mail, fcm: fcm}
}

func (s *NotificationService) Create(ctx context.Context, userIDStr string, req *requests.CreateNotificationRequest) (*responses.NotificationResponse, error) {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errors.New("invalid user id")
	}

	n := &models.Notification{
		UserId: userID,
		Title:  req.Title,
		Body:   req.Body,
		Kind:   req.Kind,
	}
	if err := s.repos.Notification.Create(ctx, n); err != nil {
		log.Printf("notification create: %v", err)
		return nil, err
	}
	created, err := s.repos.Notification.GetOwnedByID(ctx, userID, n.Id)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapNotificationToResponse(created)
	return &resp, nil
}

func (s *NotificationService) ListMine(ctx context.Context, userIDStr string) ([]responses.NotificationResponse, error) {
	list, _, err := s.ListMinePaginated(ctx, userIDStr, requests.ListNotificationsQuery{Page: 1, PageSize: 10000})
	return list, err
}

func (s *NotificationService) GetByID(ctx context.Context, userIDStr, idStr string) (*responses.NotificationResponse, error) {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errors.New("invalid user id")
	}
	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid notification id")
	}
	n, err := s.repos.Notification.GetOwnedByID(ctx, userID, id)
	if err != nil {
		return nil, err
	}
	resp := mappers.MapNotificationToResponse(n)
	return &resp, nil
}

func (s *NotificationService) Update(ctx context.Context, userIDStr, idStr string, req *requests.UpdateNotificationRequest) (*responses.NotificationResponse, error) {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errors.New("invalid user id")
	}
	id, err := uuid.Parse(idStr)
	if err != nil {
		return nil, errors.New("invalid notification id")
	}

	n, err := s.repos.Notification.GetOwnedByID(ctx, userID, id)
	if err != nil {
		return nil, err
	}

	if req.Title != nil {
		n.Title = *req.Title
	}
	if req.Body != nil {
		n.Body = *req.Body
	}
	if req.Kind != nil {
		n.Kind = *req.Kind
	}
	if req.MarkRead != nil {
		if *req.MarkRead {
			now := time.Now().UTC()
			n.ReadAt = &now
		} else {
			n.ReadAt = nil
		}
	}

	if err := s.repos.Notification.Save(ctx, n); err != nil {
		log.Printf("notification update: %v", err)
		return nil, err
	}
	resp := mappers.MapNotificationToResponse(n)
	return &resp, nil
}

func (s *NotificationService) Delete(ctx context.Context, userIDStr, idStr string) error {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return errors.New("invalid user id")
	}
	id, err := uuid.Parse(idStr)
	if err != nil {
		return errors.New("invalid notification id")
	}
	if err := s.repos.Notification.DeleteOwned(ctx, userID, id); err != nil {
		return err
	}
	return nil
}

// AdminCreateForUser creates a notification for the given user. If sendEmail is true, fromEmail must be non-empty
// and the same title/body are emailed (best-effort: failures are reported in EmailError but the row is still saved).
func (s *NotificationService) AdminCreateForUser(ctx context.Context, req *requests.AdminCreateNotificationRequest, fromEmail string) (*responses.AdminCreateNotificationResponse, error) {
	targetID, err := uuid.Parse(req.UserID)
	if err != nil {
		return nil, errors.New("invalid user id")
	}

	user, err := s.repos.User.FindByID(req.UserID)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrNotificationTargetUserNotFound
		}
		return nil, err
	}

	n := &models.Notification{
		UserId: targetID,
		Title:  req.Title,
		Body:   req.Body,
		Kind:   req.Kind,
	}
	if err := s.repos.Notification.Create(ctx, n); err != nil {
		log.Printf("admin notification create: %v", err)
		return nil, err
	}
	created, err := s.repos.Notification.GetOwnedByID(ctx, targetID, n.Id)
	if err != nil {
		return nil, err
	}

	out := &responses.AdminCreateNotificationResponse{
		Notification: mappers.MapNotificationToResponse(created),
	}

	emailSent, pushSent, emailErr, pushErr, devices := s.deliverForAdminCreate(
		ctx, created, user, req.SendPush, req.SendEmail, fromEmail,
	)
	out.EmailSent = emailSent
	out.PushSent = pushSent
	out.EmailError = emailErr
	out.PushError = pushErr
	out.DevicesNotified = devices

	return out, nil
}
