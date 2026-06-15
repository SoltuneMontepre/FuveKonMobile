package mappers

import (
	"general-service/internal/dto/notification/responses"
	"general-service/internal/models"
)

func MapNotificationToResponse(n *models.Notification) responses.NotificationResponse {
	return responses.NotificationResponse{
		Id:        n.Id,
		UserId:    n.UserId,
		Title:     n.Title,
		Body:      n.Body,
		Kind:      n.Kind,
		ReadAt:    n.ReadAt,
		CreatedAt: n.CreatedAt,
	}
}

func MapNotificationsToResponse(list []models.Notification) []responses.NotificationResponse {
	out := make([]responses.NotificationResponse, len(list))
	for i := range list {
		out[i] = MapNotificationToResponse(&list[i])
	}
	return out
}
