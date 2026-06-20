package services

import (
	"context"
	"errors"
	"log"
	"math"
	"strings"

	role "general-service/internal/common/constants"
	"general-service/internal/dto/notification/requests"
	"general-service/internal/dto/notification/responses"
	"general-service/internal/mappers"
	"general-service/internal/models"
	"general-service/internal/repositories"

	"github.com/google/uuid"
)

const maxBroadcastRecipients = 5000

type notificationDeliveryOptions struct {
	sendPush  bool
	sendEmail bool
	fromEmail string
	user      *models.User
}

// NotifyUser creates an in-app notification and sends FCM push (best-effort). Never fails the caller.
func (s *NotificationService) NotifyUser(ctx context.Context, userID uuid.UUID, title, body, kind string) {
	if _, err := s.createAndDeliver(ctx, userID, title, body, kind, notificationDeliveryOptions{sendPush: true}); err != nil {
		log.Printf("NotifyUser %s: %v", userID, err)
	}
}

func (s *NotificationService) createAndDeliver(
	ctx context.Context,
	userID uuid.UUID,
	title, body, kind string,
	opts notificationDeliveryOptions,
) (*models.Notification, error) {
	n := &models.Notification{
		UserId: userID,
		Title:  title,
		Body:   body,
		Kind:   kind,
	}
	if err := s.repos.Notification.Create(ctx, n); err != nil {
		return nil, err
	}

	if opts.sendPush && s.fcm != nil && s.fcm.Enabled() {
		data := map[string]string{
			"kind":            kind,
			"notification_id": n.Id.String(),
		}
		if _, err := s.fcm.SendToUser(ctx, userID, title, body, data); err != nil {
			log.Printf("FCM push to user %s: %v", userID, err)
		}
	}

	if opts.sendEmail && opts.fromEmail != "" && s.mail != nil && opts.user != nil && opts.user.Email != "" {
		lang := LangFromCountry(opts.user.Country)
		if err := s.mail.SendNotificationEmail(ctx, opts.fromEmail, opts.user.Email, title, body, lang); err != nil {
			log.Printf("notification email to %s: %v", opts.user.Email, err)
		}
	}

	return n, nil
}

func (s *NotificationService) deliverForAdminCreate(
	ctx context.Context,
	created *models.Notification,
	user *models.User,
	sendPush, sendEmail bool,
	fromEmail string,
) (emailSent, pushSent bool, emailErr, pushErr string, devices int) {
	if sendPush {
		if s.fcm == nil || !s.fcm.Enabled() {
			pushErr = "FCM is not configured"
		} else {
			data := map[string]string{
				"kind":            created.Kind,
				"notification_id": created.Id.String(),
			}
			sent, err := s.fcm.SendToUser(ctx, created.UserId, created.Title, created.Body, data)
			if err != nil {
				pushErr = err.Error()
			} else if sent == 0 {
				pushErr = "no registered device tokens"
			} else {
				pushSent = true
				devices = sent
			}
		}
	}

	if sendEmail {
		if fromEmail == "" {
			emailErr = "SES_EMAIL_IDENTITY is not set"
		} else if s.mail == nil {
			emailErr = "mail service is not available"
		} else if user.Email == "" {
			emailErr = "user has no email"
		} else if err := s.mail.SendNotificationEmail(ctx, fromEmail, user.Email, created.Title, created.Body, LangFromCountry(user.Country)); err != nil {
			emailErr = err.Error()
		} else {
			emailSent = true
		}
	}

	return emailSent, pushSent, emailErr, pushErr, devices
}

func normalizeNotificationPagination(page, pageSize int) (int, int) {
	if page < 1 {
		page = 1
	}
	if pageSize <= 0 {
		pageSize = 50
	}
	if pageSize > 100 {
		pageSize = 100
	}
	return page, pageSize
}

func buildNotificationPaginationMeta(page, pageSize int, total int64) map[string]interface{} {
	totalPages := int64(0)
	if pageSize > 0 {
		totalPages = int64(math.Ceil(float64(total) / float64(pageSize)))
	}
	return map[string]interface{}{
		"currentPage": page,
		"pageSize":    pageSize,
		"totalPages":  totalPages,
		"totalItems":  total,
	}
}

func (s *NotificationService) CountUnread(ctx context.Context, userIDStr string) (*responses.UnreadCountResponse, error) {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errInvalidUserID()
	}
	count, err := s.repos.Notification.CountUnreadByUserID(ctx, userID)
	if err != nil {
		return nil, err
	}
	return &responses.UnreadCountResponse{Count: count}, nil
}

func (s *NotificationService) MarkAllRead(ctx context.Context, userIDStr string) (*responses.MarkAllReadResponse, error) {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, errInvalidUserID()
	}
	updated, err := s.repos.Notification.MarkAllReadByUserID(ctx, userID)
	if err != nil {
		return nil, err
	}
	return &responses.MarkAllReadResponse{Updated: updated}, nil
}

func (s *NotificationService) ListMinePaginated(ctx context.Context, userIDStr string, q requests.ListNotificationsQuery) ([]responses.NotificationResponse, map[string]interface{}, error) {
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, nil, errInvalidUserID()
	}
	page, pageSize := normalizeNotificationPagination(q.Page, q.PageSize)
	list, total, err := s.repos.Notification.ListFiltered(ctx, repositories.NotificationListFilter{
		UserID:     &userID,
		Kind:       strings.TrimSpace(q.Kind),
		UnreadOnly: q.UnreadOnly,
		Page:       page,
		PageSize:   pageSize,
	})
	if err != nil {
		log.Printf("notification list: %v", err)
		return nil, nil, err
	}
	meta := buildNotificationPaginationMeta(page, pageSize, total)
	return mappers.MapNotificationsToResponse(list), meta, nil
}

func (s *NotificationService) AdminList(ctx context.Context, q requests.AdminListNotificationsQuery) ([]responses.NotificationResponse, map[string]interface{}, error) {
	filter := repositories.NotificationListFilter{
		Kind: strings.TrimSpace(q.Kind),
	}
	page, pageSize := normalizeNotificationPagination(q.Page, q.PageSize)
	filter.Page = page
	filter.PageSize = pageSize

	if uid := strings.TrimSpace(q.UserID); uid != "" {
		userID, err := uuid.Parse(uid)
		if err != nil {
			return nil, nil, errors.New("invalid user id")
		}
		filter.UserID = &userID
	}

	list, total, err := s.repos.Notification.ListFiltered(ctx, filter)
	if err != nil {
		return nil, nil, err
	}
	meta := buildNotificationPaginationMeta(page, pageSize, total)
	return mappers.MapNotificationsToResponse(list), meta, nil
}

func (s *NotificationService) AdminBroadcast(ctx context.Context, req *requests.AdminBroadcastNotificationRequest, fromEmail string) (*responses.AdminBroadcastNotificationResponse, error) {
	var roleFilter *role.UserRole
	if roleStr := strings.TrimSpace(req.Role); roleStr != "" {
		parsed, err := role.ParseUserRole(roleStr)
		if err != nil {
			return nil, err
		}
		roleFilter = &parsed
	}

	userIDs, err := s.repos.User.ListActiveUserIDs(ctx, roleFilter)
	if err != nil {
		return nil, err
	}
	if len(userIDs) == 0 {
		return &responses.AdminBroadcastNotificationResponse{}, nil
	}
	if len(userIDs) > maxBroadcastRecipients {
		return nil, errors.New("too many recipients; narrow the audience with role or split into smaller broadcasts")
	}

	kind := strings.TrimSpace(req.Kind)
	if kind == "" {
		kind = role.NotificationKindBroadcast
	}

	out := &responses.AdminBroadcastNotificationResponse{
		Recipients: len(userIDs),
	}

	rows := make([]models.Notification, 0, len(userIDs))
	for _, uid := range userIDs {
		rows = append(rows, models.Notification{
			Id:     uuid.New(),
			UserId: uid,
			Title:  req.Title,
			Body:   req.Body,
			Kind:   kind,
		})
	}
	if err := s.repos.Notification.CreateBatch(ctx, rows); err != nil {
		return nil, err
	}
	out.InboxCreated = len(rows)

	userCache := map[uuid.UUID]*models.User{}
	loadUser := func(id uuid.UUID) *models.User {
		if u, ok := userCache[id]; ok {
			return u
		}
		u, err := s.repos.User.FindByID(id.String())
		if err != nil {
			return nil
		}
		userCache[id] = u
		return u
	}

	for i := range rows {
		n := &rows[i]
		if req.SendPush && s.fcm != nil && s.fcm.Enabled() {
			data := map[string]string{
				"kind":            kind,
				"notification_id": n.Id.String(),
			}
			sent, err := s.fcm.SendToUser(ctx, n.UserId, req.Title, req.Body, data)
			if err != nil {
				out.PushErrors++
			} else {
				out.PushDevicesSent += sent
			}
		}
		if req.SendEmail && fromEmail != "" && s.mail != nil {
			user := loadUser(n.UserId)
			if user == nil || user.Email == "" {
				out.EmailErrors++
				continue
			}
			if err := s.mail.SendNotificationEmail(ctx, fromEmail, user.Email, req.Title, req.Body, LangFromCountry(user.Country)); err != nil {
				out.EmailErrors++
			} else {
				out.EmailsSent++
			}
		}
	}

	if req.SendEmail && fromEmail == "" {
		out.Error = "SES_EMAIL_IDENTITY is not set; inbox rows were created but email was skipped"
	}
	if req.SendPush && (s.fcm == nil || !s.fcm.Enabled()) {
		if out.Error != "" {
			out.Error += "; FCM is not configured"
		} else {
			out.Error = "FCM is not configured; inbox rows were created but push was skipped"
		}
	}

	return out, nil
}

func errInvalidUserID() error {
	return errors.New("invalid user id")
}
