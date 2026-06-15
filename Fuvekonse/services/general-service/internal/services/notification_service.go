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
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errors.New("invalid user id")
	}
	list, err := s.repos.Notification.ListByUserID(ctx, userID)
	if err != nil {
		log.Printf("notification list: %v", err)
		return nil, err
	}
	return mappers.MapNotificationsToResponse(list), nil
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
		EmailSent:    false,
		PushSent:     false,
	}

	if req.SendPush {
		if s.fcm == nil || !s.fcm.Enabled() {
			out.PushError = "FCM is not configured"
		} else {
			data := map[string]string{
				"kind":            req.Kind,
				"notification_id": created.Id.String(),
			}
			sent, err := s.fcm.SendToUser(ctx, targetID, req.Title, req.Body, data)
			if err != nil {
				log.Printf("admin notification push to user %s: %v", targetID, err)
				out.PushError = err.Error()
			} else if sent == 0 {
				out.PushError = "no registered device tokens"
			} else {
				out.PushSent = true
				out.DevicesNotified = sent
			}
		}
	}

	if req.SendEmail {
		if fromEmail == "" {
			out.EmailError = "SES_EMAIL_IDENTITY is not set"
			return out, nil
		}
		if s.mail == nil {
			out.EmailError = "mail service is not available"
			return out, nil
		}
		lang := LangFromCountry(user.Country)
		if err := s.mail.SendNotificationEmail(ctx, fromEmail, user.Email, req.Title, req.Body, lang); err != nil {
			log.Printf("admin notification email to %s: %v", user.Email, err)
			out.EmailError = err.Error()
			return out, nil
		}
		out.EmailSent = true
	}

	return out, nil
}
