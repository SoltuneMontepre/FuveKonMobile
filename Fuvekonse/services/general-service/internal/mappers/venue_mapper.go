package mappers

import (
	vresp "general-service/internal/dto/venue/responses"
	"general-service/internal/models"
)

func MapGlobalLocationToResponse(l *models.Location) vresp.LocationResponse {
	return vresp.LocationResponse{
		Id:          l.Id,
		Name:        l.Name,
		Description: l.Description,
		Order:       l.Order,
		CreatedAt:   l.CreatedAt,
		ModifiedAt:  l.ModifiedAt,
	}
}

func MapGlobalVenueToResponse(v *models.Venue) vresp.VenueResponse {
	locs := make([]vresp.LocationResponse, 0, len(v.Locations))
	for i := range v.Locations {
		locs = append(locs, MapGlobalLocationToResponse(&v.Locations[i]))
	}
	return vresp.VenueResponse{
		Id:          v.Id,
		Name:        v.Name,
		Description: v.Description,
		Locations:   locs,
		CreatedAt:   v.CreatedAt,
		ModifiedAt:  v.ModifiedAt,
	}
}
