package services

import (
	"context"
	"general-service/internal/repositories"
	"log"

	"github.com/redis/go-redis/v9"
)

type Services struct {
	Auth         *AuthService
	User         *UserService
	Mail         *MailService
	FCM          *FCMService
	DeviceToken  *DeviceTokenService
	Ticket       *TicketService
	Event        *EventService
	Dealer       *DealerService
	Conbook      *ConbookService
	Panel        *PanelService
	Venue        *VenueService
	Schedule     *ScheduleService
	Talent       *TalentService
	Notification *NotificationService
	Analytics    *AnalyticsService
	LostFound    *LostFoundService
	S3           *S3Service
	RBAC         *RBACService
}

func NewServices(repos *repositories.Repositories, redisClient *redis.Client, loginMaxFail int, loginFailBlockMinutes int) *Services {
	mail := NewMailService(repos)
	fcm := NewFCMService(repos)
	notification := NewNotificationService(repos, mail, fcm)
	ticket := NewTicketService(repos, mail, notification)

	var s3Service *S3Service
	if svc, err := NewS3Service(context.Background()); err != nil {
		log.Printf("WARNING: S3 service not initialized: %v (upload endpoints disabled)", err)
	} else {
		s3Service = svc
	}

	return &Services{
		Auth:         NewAuthService(repos, redisClient, loginMaxFail, loginFailBlockMinutes),
		User:         NewUserService(repos),
		Mail:         mail,
		FCM:          fcm,
		DeviceToken:  NewDeviceTokenService(repos),
		Ticket:       ticket,
		Event:        NewEventService(repos),
		Dealer:       NewDealerService(repos, mail, notification),
		Conbook:      NewConbookService(repos, notification),
		Panel:        NewPanelService(repos, notification),
		Venue:        NewVenueService(repos),
		Schedule:     NewScheduleService(repos),
		Talent:       NewTalentService(repos, notification),
		Notification: notification,
		Analytics:    NewAnalyticsService(repos, ticket),
		LostFound:    NewLostFoundService(repos, notification),
		S3:           s3Service,
		RBAC:         NewRBACService(repos),
	}
}
