package services

import (
	"context"
	"errors"
	"fmt"
	"log"
	"os"
	"strings"

	"general-service/internal/repositories"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"github.com/google/uuid"
	"google.golang.org/api/option"
)

const fcmInvalidTokenError = "registration-token-not-registered"

type FCMService struct {
	client  *messaging.Client
	repos   *repositories.Repositories
	enabled bool
}

func NewFCMService(repos *repositories.Repositories) *FCMService {
	s := &FCMService{repos: repos}

	if strings.EqualFold(strings.TrimSpace(os.Getenv("FCM_ENABLED")), "false") {
		log.Println("FCM push disabled (FCM_ENABLED=false)")
		return s
	}

	credsJSON, err := loadFCMCredentialsJSON()
	if err != nil {
		log.Printf("FCM push disabled: %v", err)
		return s
	}

	ctx := context.Background()
	app, err := firebase.NewApp(ctx, nil, option.WithCredentialsJSON(credsJSON))
	if err != nil {
		log.Printf("FCM push disabled: failed to init Firebase app: %v", err)
		return s
	}

	client, err := app.Messaging(ctx)
	if err != nil {
		log.Printf("FCM push disabled: failed to init FCM client: %v", err)
		return s
	}

	s.client = client
	s.enabled = true
	log.Println("FCM push service enabled")
	return s
}

func loadFCMCredentialsJSON() ([]byte, error) {
	if path := trimEnvPath(os.Getenv("FCM_SERVICE_ACCOUNT_PATH")); path != "" {
		data, err := os.ReadFile(path)
		if err != nil {
			return nil, fmt.Errorf("read FCM_SERVICE_ACCOUNT_PATH (%s): %w", path, err)
		}
		return data, nil
	}

	if raw := strings.TrimSpace(os.Getenv("FCM_SERVICE_ACCOUNT_JSON")); raw != "" {
		return []byte(raw), nil
	}

	return nil, errors.New("set FCM_SERVICE_ACCOUNT_JSON or FCM_SERVICE_ACCOUNT_PATH to enable push")
}

func trimEnvPath(value string) string {
	return strings.Trim(strings.TrimSpace(value), `"'`)
}

func (s *FCMService) Enabled() bool {
	return s.enabled && s.client != nil
}

// SendToUser sends a push notification to all registered devices for the user.
// Returns the number of successfully delivered messages. Invalid tokens are removed.
func (s *FCMService) SendToUser(ctx context.Context, userID uuid.UUID, title, body string, data map[string]string) (int, error) {
	if !s.Enabled() {
		return 0, errors.New("FCM is not configured")
	}

	tokens, err := s.repos.DeviceToken.ListByUserID(ctx, userID)
	if err != nil {
		return 0, err
	}
	if len(tokens) == 0 {
		return 0, nil
	}

	tokenStrings := make([]string, 0, len(tokens))
	for _, t := range tokens {
		tokenStrings = append(tokenStrings, t.Token)
	}

	msg := &messaging.MulticastMessage{
		Tokens: tokenStrings,
		Notification: &messaging.Notification{
			Title: title,
			Body:  body,
		},
		Data: data,
		Android: &messaging.AndroidConfig{
			Priority: "high",
		},
		APNS: &messaging.APNSConfig{
			Payload: &messaging.APNSPayload{
				Aps: &messaging.Aps{
					Sound: "default",
				},
			},
		},
	}

	resp, err := s.client.SendEachForMulticast(ctx, msg)
	if err != nil {
		return 0, fmt.Errorf("FCM SendEachForMulticast: %w", err)
	}

	var stale []string
	for i, r := range resp.Responses {
		if r.Success {
			continue
		}
		if r.Error != nil && isStaleFCMToken(r.Error) {
			stale = append(stale, tokenStrings[i])
		}
		log.Printf("FCM send failed for user %s token index %d: %v", userID, i, r.Error)
	}

	if len(stale) > 0 {
		if err := s.repos.DeviceToken.DeleteByTokens(ctx, stale); err != nil {
			log.Printf("FCM stale token cleanup: %v", err)
		}
	}

	return resp.SuccessCount, nil
}

func isStaleFCMToken(err error) bool {
	if err == nil {
		return false
	}
	msg := strings.ToLower(err.Error())
	return strings.Contains(msg, fcmInvalidTokenError) ||
		strings.Contains(msg, "invalid registration token") ||
		strings.Contains(msg, "not registered")
}
