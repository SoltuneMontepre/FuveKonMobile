package repositories

import "gorm.io/gorm"

type Repositories struct {
	User    *UserRepository
	Ticket  *TicketRepository
	Event   *EventSettingsRepository
	Dealer  *DealerRepository
	Conbook *ConbookRepository
	Panel   *PanelRepository
	Talent    *TalentRepository
	LostFound *LostFoundRepository
}

func NewRepositories(db *gorm.DB) *Repositories {
	return &Repositories{
		User:    NewUserRepository(db),
		Ticket:  NewTicketRepository(db),
		Event:   NewEventSettingsRepository(db),
		Dealer:  NewDealerRepository(db),
		Conbook: NewConbookRepository(db),
		Panel:   NewPanelRepository(db),
		Talent:    NewTalentRepository(db),
		LostFound: NewLostFoundRepository(db),
	}
}
