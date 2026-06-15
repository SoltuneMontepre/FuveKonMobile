package mappers

import (
	"general-service/internal/dto/schedule/responses"
	"general-service/internal/models"
)

func MapScheduleToResponse(s *models.Schedule) responses.ScheduleResponse {
	venues := make([]responses.VenueResponse, 0, len(s.Venues))
	for i := range s.Venues {
		v := s.Venues[i]
		locs := make([]responses.LocationResponse, 0, len(v.Locations))
		for j := range v.Locations {
			l := v.Locations[j]
			events := make([]responses.EventResponse, 0, len(l.Events))
			for k := range l.Events {
				e := l.Events[k]
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
			locs = append(locs, responses.LocationResponse{
				Id:            l.Id,
				Name:          l.Name,
				Description:   l.Description,
				Order:         l.Order,
				LocationRefId: l.LocationRefId,
				Events:        events,
				CreatedAt:     l.CreatedAt,
				ModifiedAt:    l.ModifiedAt,
			})
		}

		venues = append(venues, responses.VenueResponse{
			Id:          v.Id,
			Name:        v.Name,
			Description: v.Description,
			Order:       v.Order,
			Locations:   locs,
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
	locs := make([]responses.LocationResponse, 0, len(v.Locations))
	for i := range v.Locations {
		loc := v.Locations[i]
		events := make([]responses.EventResponse, 0, len(loc.Events))
		for j := range loc.Events {
			events = append(events, MapEventToResponse(&loc.Events[j]))
		}
		locs = append(locs, responses.LocationResponse{
			Id:            loc.Id,
			Name:          loc.Name,
			Description:   loc.Description,
			Order:         loc.Order,
			LocationRefId: loc.LocationRefId,
			Events:        events,
			CreatedAt:     loc.CreatedAt,
			ModifiedAt:    loc.ModifiedAt,
		})
	}
	return responses.VenueResponse{
		Id:          v.Id,
		Name:        v.Name,
		Description: v.Description,
		Order:       v.Order,
		Locations:   locs,
		CreatedAt:   v.CreatedAt,
		ModifiedAt:  v.ModifiedAt,
	}
}

// MapLocationToResponse converts a ScheduleLocation model to a LocationResponse.
func MapLocationToResponse(l *models.ScheduleLocation) responses.LocationResponse {
	events := make([]responses.EventResponse, 0, len(l.Events))
	for i := range l.Events {
		events = append(events, MapEventToResponse(&l.Events[i]))
	}
	return responses.LocationResponse{
		Id:            l.Id,
		Name:          l.Name,
		Description:   l.Description,
		Order:         l.Order,
		LocationRefId: l.LocationRefId,
		Events:        events,
		CreatedAt:     l.CreatedAt,
		ModifiedAt:    l.ModifiedAt,
	}
}
