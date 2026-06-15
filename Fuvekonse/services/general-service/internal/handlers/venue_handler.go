package handlers

import (
	"errors"
	"general-service/internal/common/utils"
	"general-service/internal/dto/venue/requests"
	venueResponses "general-service/internal/dto/venue/responses"
	"general-service/internal/mappers"
	"general-service/internal/models"
	"general-service/internal/repositories"
	"general-service/internal/services"

	"github.com/gin-gonic/gin"
)

type VenueHandler struct {
	services *services.Services
}

func NewVenueHandler(services *services.Services) *VenueHandler {
	return &VenueHandler{services: services}
}

// CreateVenue godoc
// @Summary Create a global venue (admin/staff)
// @Tags admin-venues
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body requests.VenueInput true "Venue payload"
// @Success 201 {object} map[string]interface{}
// @Router /admin/venues [post]
func (h *VenueHandler) CreateVenue(c *gin.Context) {
	ctx := c.Request.Context()

	var req requests.VenueInput
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	v := &models.Venue{
		Name:        req.Name,
		Description: req.Description,
	}

	created, err := h.services.Venue.CreateVenue(ctx, v)
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to create venue")
		return
	}

	// create any provided global locations
	if len(req.Locations) > 0 {
		for _, li := range req.Locations {
			loc := &models.Location{
				Name:        li.Name,
				Description: li.Description,
				Order:       li.Order,
			}
			if _, err := h.services.Venue.CreateLocation(ctx, created.Id.String(), loc); err != nil {
				utils.RespondInternalServerError(c, "Failed to create location")
				return
			}
		}
	}

	// refetch to include created locations
	full, err := h.services.Venue.GetVenueByID(ctx, created.Id.String())
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to load venue")
		return
	}
	resp := mappers.MapGlobalVenueToResponse(full)
	utils.RespondCreated(c, &resp, "Venue created successfully")
}

// CreateLocation godoc
// @Summary Create a global location under a venue (admin/staff)
// @Tags admin-venues
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param vid path string true "Venue ID" format(uuid)
// @Param request body requests.LocationInput true "Location payload"
// @Success 201 {object} map[string]interface{}
// @Router /admin/venues/{vid}/locations [post]
func (h *VenueHandler) CreateLocation(c *gin.Context) {
	ctx := c.Request.Context()
	vid := c.Param("vid")
	if vid == "" {
		utils.RespondValidationError(c, "Venue ID is required")
		return
	}

	var req requests.LocationInput
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	l := &models.Location{
		Name:        req.Name,
		Description: req.Description,
		Order:       req.Order,
	}

	created, err := h.services.Venue.CreateLocation(ctx, vid, l)
	if err != nil {
		if errors.Is(err, repositories.ErrGlobalVenueNotFound) {
			utils.RespondNotFound(c, "Venue not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to create location")
		return
	}

	resp := mappers.MapGlobalLocationToResponse(created)
	utils.RespondCreated(c, &resp, "Location created successfully")
}

// ListVenues godoc
// @Summary List global venues (admin/staff)
// @Tags admin-venues
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 {array} map[string]interface{} "OK"
// @Router /admin/venues [get]
func (h *VenueHandler) ListVenues(c *gin.Context) {
	ctx := c.Request.Context()
	items, err := h.services.Venue.ListVenues(ctx)
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to list venues")
		return
	}
	out := make([]venueResponses.VenueResponse, 0, len(items))
	for i := range items {
		out = append(out, mappers.MapGlobalVenueToResponse(&items[i]))
	}
	utils.RespondSuccess(c, &out, "OK")
}

// ListLocationsByVenue godoc
// @Summary List global locations for a venue (admin/staff)
// @Tags admin-venues
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param vid path string true "Venue ID" format(uuid)
// @Success 200 {array} map[string]interface{} "OK"
// @Router /admin/venues/{vid}/locations [get]
func (h *VenueHandler) ListLocationsByVenue(c *gin.Context) {
	ctx := c.Request.Context()
	vid := c.Param("vid")
	if vid == "" {
		utils.RespondValidationError(c, "Venue ID is required")
		return
	}
	items, err := h.services.Venue.ListLocationsByVenue(ctx, vid)
	if err != nil {
		if errors.Is(err, repositories.ErrGlobalVenueNotFound) {
			utils.RespondNotFound(c, "Venue not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to list locations")
		return
	}
	out := make([]venueResponses.LocationResponse, 0, len(items))
	for i := range items {
		out = append(out, mappers.MapGlobalLocationToResponse(&items[i]))
	}
	utils.RespondSuccess(c, &out, "OK")
}

// GetVenueByID godoc
// @Summary Get a global venue by id (admin/staff)
// @Tags admin-venues
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param vid path string true "Venue ID" format(uuid)
// @Success 200 {object} map[string]interface{} "OK"
// @Router /admin/venues/{vid} [get]
func (h *VenueHandler) GetVenueByID(c *gin.Context) {
	ctx := c.Request.Context()
	vid := c.Param("vid")
	if vid == "" {
		utils.RespondValidationError(c, "Venue ID is required")
		return
	}
	v, err := h.services.Venue.GetVenueByID(ctx, vid)
	if err != nil {
		if errors.Is(err, repositories.ErrGlobalVenueNotFound) {
			utils.RespondNotFound(c, "Venue not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to load venue")
		return
	}
	resp := mappers.MapGlobalVenueToResponse(v)
	utils.RespondSuccess(c, &resp, "OK")
}
