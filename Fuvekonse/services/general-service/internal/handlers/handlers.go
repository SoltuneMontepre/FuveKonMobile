package handlers

import (
	"general-service/internal/queue"
	"general-service/internal/services"
)

type Handlers struct {
	Auth         *AuthHandler
	User         *UserHandler
	Ticket       *TicketHandler
	Event        *EventHandler
	Dealer       *DealerHandler
	Conbook      *ConbookHandler
	Panel        *PanelHandler
	Venue        *VenueHandler
	Schedule     *ScheduleHandler
	Talent       *TalentHandler
	Notification *NotificationHandler
	DeviceToken  *DeviceTokenHandler
	Analytics    *AnalyticsHandler
	DevMail      *DevMailHandler
	LostFound    *LostFoundHandler
	S3           *S3Handler
	RBAC         *RBACHandler
	Health       *HealthHandler
}

func NewHandlers(services *services.Services, queuePublisher queue.Publisher, health *services.HealthService) *Handlers {
	return &Handlers{
		Auth:         NewAuthHandler(services),
		User:         NewUserHandler(services),
		Ticket:       NewTicketHandler(services, queuePublisher),
		Event:        NewEventHandler(services),
		Dealer:       NewDealerHandler(services),
		Conbook:      NewConbookHandler(services),
		Panel:        NewPanelHandler(services),
		Venue:        NewVenueHandler(services),
		Schedule:     NewScheduleHandler(services),
		Talent:       NewTalentHandler(services),
		Notification: NewNotificationHandler(services),
		DeviceToken:  NewDeviceTokenHandler(services),
		Analytics:    NewAnalyticsHandler(services),
		DevMail:      NewDevMailHandler(services),
		LostFound:    NewLostFoundHandler(services),
		S3:           NewS3Handler(services),
		RBAC:         NewRBACHandler(services),
		Health:       NewHealthHandler(health),
	}
}
