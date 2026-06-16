package mappers

import (
	"general-service/internal/dto/lostfound/responses"
	"general-service/internal/models"
	"strings"

	"github.com/google/uuid"
)

func lostFoundDisplayCode(item *models.LostFoundItem) string {
	if code := strings.TrimSpace(item.DisplayCode); code != "" {
		return code
	}
	return formatLostFoundDisplayCode(item.Id)
}

func formatLostFoundDisplayCode(id uuid.UUID) string {
	s := strings.ReplaceAll(id.String(), "-", "")
	if len(s) >= 5 {
		return "FND-" + strings.ToUpper(s[len(s)-5:])
	}
	return "FND-" + strings.ToUpper(s)
}

func MapLostFoundClaimUserToResponse(user *models.User) responses.LostFoundClaimUserResponse {
	if user == nil {
		return responses.LostFoundClaimUserResponse{}
	}
	return responses.LostFoundClaimUserResponse{
		Id:          user.Id,
		FirstName:   user.FirstName,
		LastName:    user.LastName,
		FursonaName: user.FursonaName,
		Email:       user.Email,
		IdCard:      user.IdCard,
		Avatar:      user.Avatar,
	}
}

func MapLostFoundClaimToResponse(claim *models.LostFoundClaim) *responses.LostFoundClaimResponse {
	if claim == nil {
		return nil
	}
	return &responses.LostFoundClaimResponse{
		Id:        claim.Id,
		ItemId:    claim.ItemId,
		Status:    string(claim.Status),
		Message:   claim.Message,
		CreatedAt: claim.CreatedAt,
		ClaimedBy: MapLostFoundClaimUserToResponse(&claim.ClaimedBy),
	}
}

func MapLostFoundToResponse(item *models.LostFoundItem, claim *models.LostFoundClaim) responses.LostFoundResponse {
	resp := responses.LostFoundResponse{
		Id:                  item.Id,
		DisplayCode:         lostFoundDisplayCode(item),
		ItemType:            string(item.ItemType),
		Title:               item.Title,
		Description:         item.Description,
		Location:            item.Location,
		ImageUrl:            item.ImageUrl,
		ContactInfo:         item.ContactInfo,
		StaffNotes:          item.StaffNotes,
		Status:              string(item.Status),
		SubmittedByUserId:   item.SubmittedByUserId,
		RecipientName:       item.RecipientName,
		RecipientIdCard:     item.RecipientIdCard,
		RecipientPhone:      item.RecipientPhone,
		VerifiedDescription: item.VerifiedDescription,
		VerifiedOwnership:   item.VerifiedOwnership,
		VerifiedIdentity:    item.VerifiedIdentity,
		ReturnedAt:          item.ReturnedAt,
		ReturnedByUserId:    item.ReturnedByUserId,
		CreatedAt:           item.CreatedAt,
		ModifiedAt:          item.ModifiedAt,
	}
	if claim != nil {
		resp.ActiveClaim = MapLostFoundClaimToResponse(claim)
	}
	return resp
}

func MapLostFoundListToResponse(items []models.LostFoundItem) []responses.LostFoundResponse {
	out := make([]responses.LostFoundResponse, len(items))
	for i := range items {
		out[i] = MapLostFoundToResponse(&items[i], nil)
	}
	return out
}

func MapLostFoundToPublicResponse(item *models.LostFoundItem, userClaimStatus string) responses.LostFoundPublicResponse {
	return responses.LostFoundPublicResponse{
		Id:              item.Id,
		DisplayCode:     lostFoundDisplayCode(item),
		ItemType:        string(item.ItemType),
		Title:           item.Title,
		Description:     item.Description,
		Location:        item.Location,
		ImageUrl:        item.ImageUrl,
		ContactInfo:     item.ContactInfo,
		Status:          string(item.Status),
		UserClaimStatus: userClaimStatus,
		CreatedAt:       item.CreatedAt,
		ModifiedAt:      item.ModifiedAt,
	}
}

func MapLostFoundListToPublicResponse(items []models.LostFoundItem, claimStatusByItem map[uuid.UUID]string) []responses.LostFoundPublicResponse {
	out := make([]responses.LostFoundPublicResponse, len(items))
	for i := range items {
		status := ""
		if claimStatusByItem != nil {
			status = claimStatusByItem[items[i].Id]
		}
		out[i] = MapLostFoundToPublicResponse(&items[i], status)
	}
	return out
}

func LostFoundClaimUserFullName(user *models.User) string {
	if user == nil {
		return ""
	}
	parts := []string{
		strings.TrimSpace(user.FirstName),
		strings.TrimSpace(user.LastName),
	}
	name := strings.TrimSpace(strings.Join(parts, " "))
	if name != "" {
		return name
	}
	return strings.TrimSpace(user.FursonaName)
}
