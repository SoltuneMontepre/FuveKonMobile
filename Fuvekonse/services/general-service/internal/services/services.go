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
}

func NewServices(repos *repositories.Repositories, redisClient *redis.Client, loginMaxFail int, loginFailBlockMinutes int) *Services {
	mail := NewMailService(repos)
	fcm := NewFCMService(repos)
	ticket := NewTicketService(repos, mail)

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
		Dealer:       NewDealerService(repos, mail),
		Conbook:      NewConbookService(repos),
		Panel:        NewPanelService(repos),
		Venue:        NewVenueService(repos),
		Schedule:     NewScheduleService(repos),
		Talent:       NewTalentService(repos),
		Notification: NewNotificationService(repos, mail, fcm),
		Analytics:    NewAnalyticsService(repos, ticket),
		LostFound:    NewLostFoundService(repos),
		S3:           s3Service,
	}
}
