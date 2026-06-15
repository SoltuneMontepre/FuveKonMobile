package mappers

import (
	"general-service/internal/dto/lostfound/responses"
	"general-service/internal/models"
)

func MapLostFoundToResponse(item *models.LostFoundItem) responses.LostFoundResponse {
	return responses.LostFoundResponse{
		Id:                item.Id,
		ItemType:          string(item.ItemType),
		Title:             item.Title,
		Description:       item.Description,
		Location:          item.Location,
		ImageUrl:          item.ImageUrl,
		ContactInfo:       item.ContactInfo,
		StaffNotes:        item.StaffNotes,
		Status:            string(item.Status),
		SubmittedByUserId: item.SubmittedByUserId,
		ClaimedByUserId:   item.ClaimedByUserId,
		ClaimMessage:      item.ClaimMessage,
		ClaimedAt:         item.ClaimedAt,
		ConfirmedByUserId: item.ConfirmedByUserId,
		ConfirmedAt:       item.ConfirmedAt,
		CreatedAt:         item.CreatedAt,
		ModifiedAt:        item.ModifiedAt,
	}
}

func MapLostFoundListToResponse(items []models.LostFoundItem) []responses.LostFoundResponse {
	out := make([]responses.LostFoundResponse, len(items))
	for i := range items {
		out[i] = MapLostFoundToResponse(&items[i])
	}
	return out
}

func MapLostFoundToPublicResponse(item *models.LostFoundItem) responses.LostFoundPublicResponse {
	return responses.LostFoundPublicResponse{
		Id:          item.Id,
		ItemType:    string(item.ItemType),
		Title:       item.Title,
		Description: item.Description,
		Location:    item.Location,
		ImageUrl:    item.ImageUrl,
		ContactInfo: item.ContactInfo,
		Status:      string(item.Status),
		CreatedAt:   item.CreatedAt,
		ModifiedAt:  item.ModifiedAt,
	}
}

func MapLostFoundListToPublicResponse(items []models.LostFoundItem) []responses.LostFoundPublicResponse {
	out := make([]responses.LostFoundPublicResponse, len(items))
	for i := range items {
		out[i] = MapLostFoundToPublicResponse(&items[i])
	}
	return out
}
