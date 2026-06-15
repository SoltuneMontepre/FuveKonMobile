package handlers

import (
	"general-service/internal/queue"
	"general-service/internal/services"
)

type Handlers struct {
	Auth         *AuthHandler
	User         *UserHandler
	Ticket       *TicketHandler
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
	Event        *EventHandler
}

func NewHandlers(services *services.Services, queuePublisher queue.Publisher) *Handlers {
	return &Handlers{
		Auth:         NewAuthHandler(services),
		User:         NewUserHandler(services),
		Ticket:       NewTicketHandler(services, queuePublisher),
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
		Event:        NewEventHandler(services),
	}
}
