package handlers

import (
	"context"
	"general-service/internal/common/utils"
	"general-service/internal/dto/event/requests"
	"general-service/internal/dto/event/responses"
	"general-service/internal/repositories"
	"general-service/internal/services"
	"net/http"

	"github.com/gin-gonic/gin"
)

type EventHandler struct {
	services *services.Services
}

func NewEventHandler(services *services.Services) *EventHandler {
	return &EventHandler{services: services}
}

// GetEventSettings godoc
// @Summary Get convention event settings
// @Description Returns registration on/off status for the public site.
// @Tags event
// @Produce json
// @Success 200 "Successfully retrieved event settings"
// @Failure 500 "Internal server error"
// @Router /event/settings [get]
func (h *EventHandler) GetEventSettings(c *gin.Context) {
	ctx := c.Request.Context()
	settings, err := h.services.Event.GetSettings(ctx)
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to retrieve event settings")
		return
	}
	utils.RespondSuccess(c, settings, "Successfully retrieved event settings")
}

// GetEventSettingsForAdmin godoc
// @Summary Get convention event settings (admin)
// @Tags admin-event
// @Produce json
// @Security BearerAuth
// @Success 200 "Successfully retrieved event settings"
// @Failure 500 "Internal server error"
// @Router /admin/event/settings [get]
func (h *EventHandler) GetEventSettingsForAdmin(c *gin.Context) {
	h.GetEventSettings(c)
}

// UpdateEventSettingsForAdmin godoc
// @Summary Update convention event settings (admin)
// @Description Set any combination of registration on/off flags for the convention.
// @Tags admin-event
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body requests.UpdateEventSettingsRequest true "Event settings update"
// @Success 200 "Event settings updated"
// @Failure 400 "Invalid request"
// @Failure 500 "Internal server error"
// @Router /admin/event/settings [patch]
func (h *EventHandler) UpdateEventSettingsForAdmin(c *gin.Context) {
	ctx := c.Request.Context()

	var req requests.UpdateEventSettingsRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	settings, err := h.services.Event.UpdateSettingsForAdmin(ctx, &req)
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to update event settings")
		return
	}

	utils.RespondSuccess(c, settings, "Event settings updated successfully")
}

func (h *EventHandler) OpenTicketSalesForAdmin(c *gin.Context) {
	h.respondFlagUpdate(c, true, h.services.Event.SetTicketSalesOpenForAdmin, "Ticket sales opened", "Failed to update ticket sales status")
}

func (h *EventHandler) CloseTicketSalesForAdmin(c *gin.Context) {
	h.respondFlagUpdate(c, false, h.services.Event.SetTicketSalesOpenForAdmin, "Ticket sales closed", "Failed to update ticket sales status")
}

func (h *EventHandler) OpenPanelRegistrationForAdmin(c *gin.Context) {
	h.respondFlagUpdate(c, true, h.services.Event.SetPanelRegistrationOpenForAdmin, "Panel registration opened", "Failed to update panel registration status")
}

func (h *EventHandler) ClosePanelRegistrationForAdmin(c *gin.Context) {
	h.respondFlagUpdate(c, false, h.services.Event.SetPanelRegistrationOpenForAdmin, "Panel registration closed", "Failed to update panel registration status")
}

func (h *EventHandler) OpenTalentRegistrationForAdmin(c *gin.Context) {
	h.respondFlagUpdate(c, true, h.services.Event.SetTalentRegistrationOpenForAdmin, "Talent registration opened", "Failed to update talent registration status")
}

func (h *EventHandler) CloseTalentRegistrationForAdmin(c *gin.Context) {
	h.respondFlagUpdate(c, false, h.services.Event.SetTalentRegistrationOpenForAdmin, "Talent registration closed", "Failed to update talent registration status")
}

func (h *EventHandler) OpenDealerRegistrationForAdmin(c *gin.Context) {
	h.respondFlagUpdate(c, true, h.services.Event.SetDealerRegistrationOpenForAdmin, "Dealer registration opened", "Failed to update dealer registration status")
}

func (h *EventHandler) CloseDealerRegistrationForAdmin(c *gin.Context) {
	h.respondFlagUpdate(c, false, h.services.Event.SetDealerRegistrationOpenForAdmin, "Dealer registration closed", "Failed to update dealer registration status")
}

func (h *EventHandler) respondFlagUpdate(
	c *gin.Context,
	open bool,
	setter func(context.Context, bool) (*responses.EventSettingsResponse, error),
	successMsg, failureMsg string,
) {
	settings, err := setter(c.Request.Context(), open)
	if err != nil {
		utils.RespondInternalServerError(c, failureMsg)
		return
	}
	utils.RespondSuccess(c, settings, successMsg)
}

func respondTicketSalesClosed(c *gin.Context) {
	utils.RespondError(c, http.StatusConflict, "TICKET_SALES_CLOSED", repositories.ErrTicketSalesClosed.Error())
}

func respondPanelRegistrationClosed(c *gin.Context) {
	utils.RespondError(c, http.StatusConflict, "PANEL_REGISTRATION_CLOSED", repositories.ErrPanelRegistrationClosed.Error())
}

func respondTalentRegistrationClosed(c *gin.Context) {
	utils.RespondError(c, http.StatusConflict, "TALENT_REGISTRATION_CLOSED", repositories.ErrTalentRegistrationClosed.Error())
}

func respondDealerRegistrationClosed(c *gin.Context) {
	utils.RespondError(c, http.StatusConflict, "DEALER_REGISTRATION_CLOSED", repositories.ErrDealerRegistrationClosed.Error())
}
