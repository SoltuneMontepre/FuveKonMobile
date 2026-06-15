package handlers

import (
	"errors"
	"general-service/internal/common/utils"
	"general-service/internal/dto/device/requests"
	"general-service/internal/repositories"
	"general-service/internal/services"

	"github.com/gin-gonic/gin"
)

type DeviceTokenHandler struct {
	services *services.Services
}

func NewDeviceTokenHandler(services *services.Services) *DeviceTokenHandler {
	return &DeviceTokenHandler{services: services}
}

// RegisterFCMToken godoc
// @Summary Register FCM device token
// @Description Registers or updates the FCM token for the authenticated user's device.
// @Tags devices
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body requests.RegisterFCMTokenRequest true "FCM token"
// @Success 200 {object} map[string]interface{}
// @Failure 400 "Invalid request"
// @Failure 401 "Unauthorized"
// @Failure 500 "Internal server error"
// @Router /devices/fcm-token [post]
func (h *DeviceTokenHandler) RegisterFCMToken(c *gin.Context) {
	ctx := c.Request.Context()
	userID, ok := c.Get("user_id")
	if !ok {
		utils.RespondUnauthorized(c, "User ID not found in token")
		return
	}

	var req requests.RegisterFCMTokenRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	out, err := h.services.DeviceToken.Register(ctx, userID.(string), &req)
	if err != nil {
		if errors.Is(err, services.ErrInvalidFCMPlatform) {
			utils.RespondValidationError(c, err.Error())
			return
		}
		utils.RespondInternalServerError(c, "Failed to register device token")
		return
	}

	utils.RespondSuccess(c, out, "Device token registered")
}

// UnregisterFCMToken godoc
// @Summary Unregister FCM device token
// @Description Removes an FCM token for the authenticated user (call on logout).
// @Tags devices
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body requests.UnregisterFCMTokenRequest true "FCM token to remove"
// @Success 204 "Deleted"
// @Failure 400 "Invalid request"
// @Failure 401 "Unauthorized"
// @Failure 404 "Not found"
// @Failure 500 "Internal server error"
// @Router /devices/fcm-token [delete]
func (h *DeviceTokenHandler) UnregisterFCMToken(c *gin.Context) {
	ctx := c.Request.Context()
	userID, ok := c.Get("user_id")
	if !ok {
		utils.RespondUnauthorized(c, "User ID not found in token")
		return
	}

	var req requests.UnregisterFCMTokenRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	if err := h.services.DeviceToken.Unregister(ctx, userID.(string), &req); err != nil {
		if errors.Is(err, repositories.ErrDeviceTokenNotFound) {
			utils.RespondNotFound(c, "Device token not found")
			return
		}
		if err.Error() == "invalid user id" || err.Error() == "token is required" {
			utils.RespondValidationError(c, err.Error())
			return
		}
		utils.RespondInternalServerError(c, "Failed to unregister device token")
		return
	}

	c.JSON(204, nil)
}
