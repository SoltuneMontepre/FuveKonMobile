package handlers

import (
	"errors"
	"general-service/internal/common/utils"
	"general-service/internal/dto/notification/requests"
	"general-service/internal/repositories"
	"general-service/internal/services"

	"github.com/gin-gonic/gin"
)

type NotificationHandler struct {
	services *services.Services
}

func NewNotificationHandler(services *services.Services) *NotificationHandler {
	return &NotificationHandler{services: services}
}

// CreateNotification godoc
// @Summary Create a notification
// @Description Creates a notification for the authenticated user.
// @Tags notifications
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body requests.CreateNotificationRequest true "Create notification"
// @Success 201 {object} map[string]interface{}
// @Failure 400 "Invalid request"
// @Failure 401 "Unauthorized"
// @Failure 500 "Internal server error"
// @Router /notifications [post]
func (h *NotificationHandler) CreateNotification(c *gin.Context) {
	ctx := c.Request.Context()
	userID, ok := c.Get("user_id")
	if !ok {
		utils.RespondUnauthorized(c, "User ID not found in token")
		return
	}
	var req requests.CreateNotificationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}
	out, err := h.services.Notification.Create(ctx, userID.(string), &req)
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to create notification")
		return
	}
	utils.RespondCreated(c, out, "Notification created")
}

// ListMyNotifications godoc
// @Summary List my notifications
// @Description Returns all notifications for the authenticated user, newest first.
// @Tags notifications
// @Produce json
// @Security BearerAuth
// @Success 200 {object} map[string]interface{}
// @Failure 401 "Unauthorized"
// @Failure 500 "Internal server error"
// @Router /notifications [get]
func (h *NotificationHandler) ListMyNotifications(c *gin.Context) {
	ctx := c.Request.Context()
	userID, ok := c.Get("user_id")
	if !ok {
		utils.RespondUnauthorized(c, "User ID not found in token")
		return
	}
	list, err := h.services.Notification.ListMine(ctx, userID.(string))
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to list notifications")
		return
	}
	utils.RespondSuccess(c, &list, "OK")
}

// GetNotificationByID godoc
// @Summary Get a notification by ID
// @Description Returns one notification if it belongs to the authenticated user.
// @Tags notifications
// @Produce json
// @Security BearerAuth
// @Param id path string true "Notification ID" format(uuid)
// @Success 200 {object} map[string]interface{}
// @Failure 400 "Invalid id"
// @Failure 401 "Unauthorized"
// @Failure 404 "Not found"
// @Failure 500 "Internal server error"
// @Router /notifications/{id} [get]
func (h *NotificationHandler) GetNotificationByID(c *gin.Context) {
	ctx := c.Request.Context()
	userID, ok := c.Get("user_id")
	if !ok {
		utils.RespondUnauthorized(c, "User ID not found in token")
		return
	}
	id := c.Param("id")
	if id == "" {
		utils.RespondValidationError(c, "Notification ID is required")
		return
	}
	out, err := h.services.Notification.GetByID(ctx, userID.(string), id)
	if err != nil {
		if errors.Is(err, repositories.ErrNotificationNotFound) {
			utils.RespondNotFound(c, "Notification not found")
			return
		}
		utils.RespondValidationError(c, err.Error())
		return
	}
	utils.RespondSuccess(c, out, "OK")
}

// UpdateNotification godoc
// @Summary Update a notification
// @Description Updates fields on a notification owned by the authenticated user.
// @Tags notifications
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Notification ID" format(uuid)
// @Param request body requests.UpdateNotificationRequest true "Update body"
// @Success 200 {object} map[string]interface{}
// @Failure 400 "Invalid request"
// @Failure 401 "Unauthorized"
// @Failure 404 "Not found"
// @Failure 500 "Internal server error"
// @Router /notifications/{id} [put]
func (h *NotificationHandler) UpdateNotification(c *gin.Context) {
	ctx := c.Request.Context()
	userID, ok := c.Get("user_id")
	if !ok {
		utils.RespondUnauthorized(c, "User ID not found in token")
		return
	}
	id := c.Param("id")
	if id == "" {
		utils.RespondValidationError(c, "Notification ID is required")
		return
	}
	var req requests.UpdateNotificationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}
	out, err := h.services.Notification.Update(ctx, userID.(string), id, &req)
	if err != nil {
		if errors.Is(err, repositories.ErrNotificationNotFound) {
			utils.RespondNotFound(c, "Notification not found")
			return
		}
		utils.RespondValidationError(c, err.Error())
		return
	}
	utils.RespondSuccess(c, out, "Notification updated")
}

// DeleteNotification godoc
// @Summary Delete a notification
// @Description Deletes a notification owned by the authenticated user.
// @Tags notifications
// @Produce json
// @Security BearerAuth
// @Param id path string true "Notification ID" format(uuid)
// @Success 204 "Deleted"
// @Failure 400 "Invalid id"
// @Failure 401 "Unauthorized"
// @Failure 404 "Not found"
// @Failure 500 "Internal server error"
// @Router /notifications/{id} [delete]
func (h *NotificationHandler) DeleteNotification(c *gin.Context) {
	ctx := c.Request.Context()
	userID, ok := c.Get("user_id")
	if !ok {
		utils.RespondUnauthorized(c, "User ID not found in token")
		return
	}
	id := c.Param("id")
	if id == "" {
		utils.RespondValidationError(c, "Notification ID is required")
		return
	}
	if err := h.services.Notification.Delete(ctx, userID.(string), id); err != nil {
		if errors.Is(err, repositories.ErrNotificationNotFound) {
			utils.RespondNotFound(c, "Notification not found")
			return
		}
		utils.RespondValidationError(c, err.Error())
		return
	}
	c.JSON(204, nil)
}

// AdminCreateNotification godoc
// @Summary Admin: create user notification (optional email)
// @Description Creates a notification for the given user_id. Set send_email true to also email the user (same title/body, language from user country). Set send_push true to also send an FCM push to registered mobile devices. Requires SES_EMAIL_IDENTITY when send_email is true; requires FCM credentials when send_push is true.
// @Tags admin-notifications
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body requests.AdminCreateNotificationRequest true "Create for user"
// @Success 201 {object} map[string]interface{}
// @Failure 400 "Invalid request or mail not configured"
// @Failure 401 "Unauthorized"
// @Failure 403 "Forbidden"
// @Failure 404 "User not found"
// @Failure 500 "Internal server error"
// @Router /admin/notifications [post]
func (h *NotificationHandler) AdminCreateNotification(c *gin.Context) {
	ctx := c.Request.Context()
	var req requests.AdminCreateNotificationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	fromEmail := getEnvOr("SES_EMAIL_IDENTITY", "")
	if req.SendEmail && fromEmail == "" {
		utils.RespondError(c, 400, "MAIL_NOT_CONFIGURED", "Sending email requires SES_EMAIL_IDENTITY to be set")
		return
	}

	out, err := h.services.Notification.AdminCreateForUser(ctx, &req, fromEmail)
	if err != nil {
		if errors.Is(err, services.ErrNotificationTargetUserNotFound) {
			utils.RespondNotFound(c, "User not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to create notification")
		return
	}

	utils.RespondCreated(c, out, "Notification created")
}
