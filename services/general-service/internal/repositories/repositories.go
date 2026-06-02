package repositories

import "gorm.io/gorm"

type Repositories struct {
	User         *UserRepository
	Ticket       *TicketRepository
	Dealer       *DealerRepository
	Conbook      *ConbookRepository
	Panel        *PanelRepository
	Schedule     *ScheduleRepository
	Talent       *TalentRepository
	Notification *NotificationRepository
	DeviceToken  *DeviceTokenRepository
	LostFound    *LostFoundRepository
}

func NewRepositories(db *gorm.DB) *Repositories {
	return &Repositories{
		User:         NewUserRepository(db),
		Ticket:       NewTicketRepository(db),
		Dealer:       NewDealerRepository(db),
		Conbook:      NewConbookRepository(db),
		Panel:        NewPanelRepository(db),
		Schedule:     NewScheduleRepository(db),
		Talent:       NewTalentRepository(db),
		Notification: NewNotificationRepository(db),
		DeviceToken:  NewDeviceTokenRepository(db),
		LostFound:    NewLostFoundRepository(db),
	}
}
