package mappers

import (
	"general-service/internal/dto/schedule/responses"
	"general-service/internal/models"
)

func MapScheduleToResponse(s *models.Schedule) responses.ScheduleResponse {
	venues := make([]responses.VenueResponse, 0, len(s.Venues))
	for i := range s.Venues {
		v := s.Venues[i]
		events := make([]responses.EventResponse, 0, len(v.Events))
		for j := range v.Events {
			e := v.Events[j]
			events = append(events, responses.EventResponse{
				Id:          e.Id,
				Title:       e.Title,
				Description: e.Description,
				StartAt:     e.StartAt,
				EndAt:       e.EndAt,
				CreatedAt:   e.CreatedAt,
				ModifiedAt:  e.ModifiedAt,
			})
		}

		venues = append(venues, responses.VenueResponse{
			Id:          v.Id,
			Name:        v.Name,
			Description: v.Description,
			Order:       v.Order,
			Events:      events,
			CreatedAt:   v.CreatedAt,
			ModifiedAt:  v.ModifiedAt,
		})
	}

	return responses.ScheduleResponse{
		Id:         s.Id,
		Name:       s.Name,
		StartAt:    s.StartAt,
		EndAt:      s.EndAt,
		Venues:     venues,
		CreatedAt:  s.CreatedAt,
		ModifiedAt: s.ModifiedAt,
	}
}

func MapSchedulesToResponse(items []models.Schedule) []responses.ScheduleResponse {
	out := make([]responses.ScheduleResponse, len(items))
	for i := range items {
		out[i] = MapScheduleToResponse(&items[i])
	}
	return out
}

// MapEventToResponse converts a ScheduleEvent model to an EventResponse.
func MapEventToResponse(e *models.ScheduleEvent) responses.EventResponse {
	return responses.EventResponse{
		Id:          e.Id,
		Title:       e.Title,
		Description: e.Description,
		StartAt:     e.StartAt,
		EndAt:       e.EndAt,
		CreatedAt:   e.CreatedAt,
		ModifiedAt:  e.ModifiedAt,
	}
}

// MapVenueToResponse converts a ScheduleVenue model to a VenueResponse (including events).
func MapVenueToResponse(v *models.ScheduleVenue) responses.VenueResponse {
	events := make([]responses.EventResponse, 0, len(v.Events))
	for i := range v.Events {
		events = append(events, MapEventToResponse(&v.Events[i]))
	}
	return responses.VenueResponse{
		Id:          v.Id,
		Name:        v.Name,
		Description: v.Description,
		Order:       v.Order,
		Events:      events,
		CreatedAt:   v.CreatedAt,
		ModifiedAt:  v.ModifiedAt,
	}
}
