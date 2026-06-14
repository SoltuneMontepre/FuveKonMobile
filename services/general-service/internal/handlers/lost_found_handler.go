package handlers

import (
	"errors"
	"general-service/internal/common/utils"
	"general-service/internal/dto/lostfound/requests"
	"general-service/internal/repositories"
	"general-service/internal/services"
	"strconv"

	"github.com/gin-gonic/gin"
)

type LostFoundHandler struct {
	services *services.Services
}

func NewLostFoundHandler(services *services.Services) *LostFoundHandler {
	return &LostFoundHandler{services: services}
}

// CreateLostFound godoc
// @Summary Create a lost and found entry
// @Tags admin-lost-found
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body requests.CreateLostFoundRequest true "Create request"
// @Success 201 {object} map[string]interface{}
// @Router /admin/lost-found [post]
func (h *LostFoundHandler) CreateLostFound(c *gin.Context) {
	ctx := c.Request.Context()
	userID, ok := c.Get("user_id")
	if !ok {
		utils.RespondUnauthorized(c, "User ID not found in token")
		return
	}

	var req requests.CreateLostFoundRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	item, err := h.services.LostFound.Create(ctx, userID.(string), &req)
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to create lost and found entry")
		return
	}

	utils.RespondCreated(c, item, "Lost and found entry created successfully")
}

// ListLostFound godoc
// @Summary List lost and found entries
// @Tags admin-lost-found
// @Produce json
// @Security BearerAuth
// @Param item_type query string false "Filter by type (lost|found)"
// @Param status query string false "Filter by status (open|claimed|resolved)"
// @Param search query string false "Search title, description, location, contact"
// @Param page query int false "Page number"
// @Param page_size query int false "Page size (max 100)"
// @Success 200 {object} map[string]interface{}
// @Router /admin/lost-found [get]
func (h *LostFoundHandler) ListLostFound(c *gin.Context) {
	ctx := c.Request.Context()

	list, err := h.services.LostFound.List(ctx, parseLostFoundListQuery(c))
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to list lost and found entries")
		return
	}

	utils.RespondSuccess(c, list, "Successfully retrieved lost and found entries")
}

// GetLostFoundByID godoc
// @Summary Get a lost and found entry by ID
// @Tags admin-lost-found
// @Produce json
// @Security BearerAuth
// @Param id path string true "Item ID" format(uuid)
// @Success 200 {object} map[string]interface{}
// @Router /admin/lost-found/{id} [get]
func (h *LostFoundHandler) GetLostFoundByID(c *gin.Context) {
	ctx := c.Request.Context()
	id := c.Param("id")
	if id == "" {
		utils.RespondValidationError(c, "Item ID is required")
		return
	}

	item, err := h.services.LostFound.GetByID(ctx, id)
	if err != nil {
		if errors.Is(err, repositories.ErrLostFoundNotFound) {
			utils.RespondNotFound(c, "Lost and found entry not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to retrieve lost and found entry")
		return
	}

	utils.RespondSuccess(c, item, "Successfully retrieved lost and found entry")
}

// UpdateLostFound godoc
// @Summary Update a lost and found entry
// @Tags admin-lost-found
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Item ID" format(uuid)
// @Param request body requests.UpdateLostFoundRequest true "Update request"
// @Success 200 {object} map[string]interface{}
// @Router /admin/lost-found/{id} [put]
func (h *LostFoundHandler) UpdateLostFound(c *gin.Context) {
	ctx := c.Request.Context()
	id := c.Param("id")
	if id == "" {
		utils.RespondValidationError(c, "Item ID is required")
		return
	}

	var req requests.UpdateLostFoundRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	item, err := h.services.LostFound.Update(ctx, id, &req)
	if err != nil {
		if errors.Is(err, repositories.ErrLostFoundNotFound) {
			utils.RespondNotFound(c, "Lost and found entry not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to update lost and found entry")
		return
	}

	utils.RespondSuccess(c, item, "Lost and found entry updated successfully")
}

// UpdateLostFoundStatus godoc
// @Summary Update status of a lost and found entry
// @Tags admin-lost-found
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Item ID" format(uuid)
// @Param request body requests.UpdateLostFoundStatusRequest true "Status update"
// @Success 200 {object} map[string]interface{}
// @Router /admin/lost-found/{id}/status [patch]
func (h *LostFoundHandler) UpdateLostFoundStatus(c *gin.Context) {
	ctx := c.Request.Context()
	id := c.Param("id")
	if id == "" {
		utils.RespondValidationError(c, "Item ID is required")
		return
	}

	var req requests.UpdateLostFoundStatusRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	item, err := h.services.LostFound.UpdateStatus(ctx, id, &req)
	if err != nil {
		if errors.Is(err, repositories.ErrLostFoundNotFound) {
			utils.RespondNotFound(c, "Lost and found entry not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to update lost and found status")
		return
	}

	utils.RespondSuccess(c, item, "Lost and found status updated successfully")
}

// DeleteLostFound godoc
// @Summary Delete a lost and found entry
// @Tags admin-lost-found
// @Produce json
// @Security BearerAuth
// @Param id path string true "Item ID" format(uuid)
// @Success 204
// @Router /admin/lost-found/{id} [delete]
func (h *LostFoundHandler) DeleteLostFound(c *gin.Context) {
	ctx := c.Request.Context()
	id := c.Param("id")
	if id == "" {
		utils.RespondValidationError(c, "Item ID is required")
		return
	}

	err := h.services.LostFound.Delete(ctx, id)
	if err != nil {
		if errors.Is(err, repositories.ErrLostFoundNotFound) {
			utils.RespondNotFound(c, "Lost and found entry not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to delete lost and found entry")
		return
	}

	c.JSON(204, nil)
}

func parseLostFoundListQuery(c *gin.Context) requests.ListLostFoundQuery {
	query := requests.ListLostFoundQuery{
		ItemType: c.Query("item_type"),
		Status:   c.Query("status"),
		Search:   c.Query("search"),
		Page:     1,
		PageSize: 20,
	}

	if pageStr := c.Query("page"); pageStr != "" {
		if page, err := strconv.Atoi(pageStr); err == nil && page > 0 {
			query.Page = page
		}
	}
	if pageSizeStr := c.Query("page_size"); pageSizeStr != "" {
		if pageSize, err := strconv.Atoi(pageSizeStr); err == nil && pageSize > 0 {
			query.PageSize = pageSize
		}
	}

	return query
}

func (h *LostFoundHandler) handleLostFoundTicketError(c *gin.Context, err error) bool {
	switch {
	case errors.Is(err, services.ErrLostFoundTicketRequired),
		errors.Is(err, services.ErrLostFoundTicketNotApproved):
		utils.RespondError(c, 403, "FORBIDDEN", err.Error())
		return true
	case err.Error() == "failed to check user ticket":
		utils.RespondInternalServerError(c, err.Error())
		return true
	}
	return false
}

// ListLostFoundForTicketHolder godoc
// @Summary List open lost and found entries (ticket holders)
// @Tags lost-found
// @Produce json
// @Security BearerAuth
// @Param item_type query string false "Filter by type (lost|found)"
// @Param search query string false "Search title, description, location, contact"
// @Param page query int false "Page number"
// @Param page_size query int false "Page size (max 100)"
// @Success 200 {object} map[string]interface{}
// @Router /lost-found [get]
func (h *LostFoundHandler) ListLostFoundForTicketHolder(c *gin.Context) {
	ctx := c.Request.Context()
	userID, ok := c.Get("user_id")
	if !ok {
		utils.RespondUnauthorized(c, "User ID not found in token")
		return
	}

	list, err := h.services.LostFound.ListForTicketHolder(ctx, userID.(string), parseLostFoundListQuery(c))
	if err != nil {
		if h.handleLostFoundTicketError(c, err) {
			return
		}
		utils.RespondInternalServerError(c, "Failed to list lost and found entries")
		return
	}

	utils.RespondSuccess(c, list, "Successfully retrieved lost and found entries")
}

// GetLostFoundByIDForTicketHolder godoc
// @Summary Get an open lost and found entry by ID (ticket holders)
// @Tags lost-found
// @Produce json
// @Security BearerAuth
// @Param id path string true "Item ID" format(uuid)
// @Success 200 {object} map[string]interface{}
// @Router /lost-found/{id} [get]
func (h *LostFoundHandler) GetLostFoundByIDForTicketHolder(c *gin.Context) {
	ctx := c.Request.Context()
	userID, ok := c.Get("user_id")
	if !ok {
		utils.RespondUnauthorized(c, "User ID not found in token")
		return
	}

	id := c.Param("id")
	if id == "" {
		utils.RespondValidationError(c, "Item ID is required")
		return
	}

	item, err := h.services.LostFound.GetForTicketHolder(ctx, userID.(string), id)
	if err != nil {
		if h.handleLostFoundTicketError(c, err) {
			return
		}
		if errors.Is(err, repositories.ErrLostFoundNotFound) {
			utils.RespondNotFound(c, "Lost and found entry not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to retrieve lost and found entry")
		return
	}

	utils.RespondSuccess(c, item, "Successfully retrieved lost and found entry")
}
