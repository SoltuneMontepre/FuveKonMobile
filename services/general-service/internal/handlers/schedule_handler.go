package handlers

import (
	"errors"
	"general-service/internal/common/utils"
	"general-service/internal/dto/schedule/requests"
	"general-service/internal/repositories"
	"general-service/internal/services"

	"github.com/gin-gonic/gin"
)

type ScheduleHandler struct {
	services *services.Services
}

func NewScheduleHandler(services *services.Services) *ScheduleHandler {
	return &ScheduleHandler{services: services}
}

// CreateSchedule godoc
// @Summary Create a new schedule (admin/staff)
// @Tags admin-schedules
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body requests.CreateScheduleRequest true "Schedule payload"
// @Success 201 {object} map[string]interface{}
// @Router /admin/schedules [post]
func (h *ScheduleHandler) CreateSchedule(c *gin.Context) {
	ctx := c.Request.Context()

	var req requests.CreateScheduleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	sched, err := h.services.Schedule.CreateSchedule(ctx, &req)
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to create schedule")
		return
	}

	utils.RespondCreated(c, sched, "Schedule created successfully")
}

// ListSchedules godoc
// @Summary List public schedules
// @Tags schedules
// @Produce json
// @Success 200 {object} map[string]interface{}
// @Router /schedules [get]
func (h *ScheduleHandler) ListSchedules(c *gin.Context) {
	ctx := c.Request.Context()
	items, err := h.services.Schedule.ListSchedules(ctx)
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to list schedules")
		return
	}
	utils.RespondSuccess(c, &items, "Successfully retrieved schedules")
}

// GetScheduleByID godoc
// @Summary Get one schedule by ID
// @Tags schedules
// @Produce json
// @Param id path string true "Schedule ID" format(uuid)
// @Success 200 {object} map[string]interface{}
// @Router /schedules/{id} [get]
func (h *ScheduleHandler) GetScheduleByID(c *gin.Context) {
	ctx := c.Request.Context()
	id := c.Param("id")
	if id == "" {
		utils.RespondValidationError(c, "Schedule ID is required")
		return
	}
	sched, err := h.services.Schedule.GetScheduleByID(ctx, id)
	if err != nil {
		if errors.Is(err, repositories.ErrScheduleNotFound) {
			utils.RespondNotFound(c, "Schedule not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to retrieve schedule")
		return
	}
	utils.RespondSuccess(c, sched, "Successfully retrieved schedule")
}

// UpdateSchedule godoc
// @Summary Update a schedule (admin/staff)
// @Tags admin-schedules
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Schedule ID" format(uuid)
// @Param request body requests.UpdateScheduleRequest true "Update payload"
// @Success 200 {object} map[string]interface{}
// @Router /admin/schedules/{id} [put]
func (h *ScheduleHandler) UpdateSchedule(c *gin.Context) {
	ctx := c.Request.Context()
	id := c.Param("id")
	if id == "" {
		utils.RespondValidationError(c, "Schedule ID is required")
		return
	}

	var req requests.UpdateScheduleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	sched, err := h.services.Schedule.UpdateSchedule(ctx, id, &req)
	if err != nil {
		if errors.Is(err, repositories.ErrScheduleNotFound) {
			utils.RespondNotFound(c, "Schedule not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to update schedule")
		return
	}

	utils.RespondSuccess(c, sched, "Schedule updated successfully")
}

// CreateVenue godoc
// @Summary Create a new venue under a schedule (admin/staff)
// @Tags admin-schedules
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Schedule ID" format(uuid)
// @Param request body requests.VenueInput true "Venue payload"
// @Success 201 {object} map[string]interface{}
// @Router /admin/admin-schedules/{id}/venues [post]
func (h *ScheduleHandler) CreateVenue(c *gin.Context) {
	ctx := c.Request.Context()
	scheduleID := c.Param("id")
	if scheduleID == "" {
		utils.RespondValidationError(c, "Schedule ID is required")
		return
	}

	var req requests.VenueInput
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	venue, err := h.services.Schedule.CreateVenue(ctx, scheduleID, &req)
	if err != nil {
		if errors.Is(err, repositories.ErrScheduleNotFound) {
			utils.RespondNotFound(c, "Schedule not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to create venue")
		return
	}

	utils.RespondCreated(c, venue, "Venue created successfully")
}

// UpdateVenue godoc
// @Summary Update a venue (admin/staff)
// @Tags admin-schedules
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Schedule ID" format(uuid)
// @Param vid path string true "Venue ID" format(uuid)
// @Param request body requests.UpdateVenueRequest true "Update payload"
// @Success 200 {object} map[string]interface{}
// @Router /admin/admin-schedules/{id}/venues/{vid} [put]
func (h *ScheduleHandler) UpdateVenue(c *gin.Context) {
	ctx := c.Request.Context()
	// scheduleID := c.Param("id") // not used for update
	vid := c.Param("vid")
	if vid == "" {
		utils.RespondValidationError(c, "Venue ID is required")
		return
	}

	var req requests.UpdateVenueRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	venue, err := h.services.Schedule.UpdateVenue(ctx, vid, &req)
	if err != nil {
		if errors.Is(err, repositories.ErrVenueNotFound) {
			utils.RespondNotFound(c, "Venue not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to update venue")
		return
	}

	utils.RespondSuccess(c, venue, "Venue updated successfully")
}

// DeleteVenue godoc
// @Summary Delete a venue (admin/staff)
// @Tags admin-schedules
// @Produce json
// @Security BearerAuth
// @Param id path string true "Schedule ID" format(uuid)
// @Param vid path string true "Venue ID" format(uuid)
// @Success 204 {object} nil
// @Router /admin/admin-schedules/{id}/venues/{vid} [delete]
func (h *ScheduleHandler) DeleteVenue(c *gin.Context) {
	ctx := c.Request.Context()
	vid := c.Param("vid")
	if vid == "" {
		utils.RespondValidationError(c, "Venue ID is required")
		return
	}

	err := h.services.Schedule.DeleteVenue(ctx, vid)
	if err != nil {
		if errors.Is(err, repositories.ErrVenueNotFound) {
			utils.RespondNotFound(c, "Venue not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to delete venue")
		return
	}

	c.JSON(204, nil)
}

// CreateEvent godoc
// @Summary Create a new event under a venue (admin/staff)
// @Tags admin-schedules
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Schedule ID" format(uuid)
// @Param vid path string true "Venue ID" format(uuid)
// @Param request body requests.EventInput true "Event payload"
// @Success 201 {object} map[string]interface{}
// @Router /admin/admin-schedules/{id}/venues/{vid}/events [post]
func (h *ScheduleHandler) CreateEvent(c *gin.Context) {
	ctx := c.Request.Context()
	scheduleID := c.Param("id")
	if scheduleID == "" {
		utils.RespondValidationError(c, "Schedule ID is required")
		return
	}
	vid := c.Param("vid")
	if vid == "" {
		utils.RespondValidationError(c, "Venue ID is required")
		return
	}

	var req requests.EventInput
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	event, err := h.services.Schedule.CreateEvent(ctx, scheduleID, vid, &req)
	if err != nil {
		if errors.Is(err, repositories.ErrScheduleNotFound) {
			utils.RespondNotFound(c, "Schedule not found")
			return
		}
		if errors.Is(err, repositories.ErrVenueNotFound) {
			utils.RespondNotFound(c, "Venue not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to create event")
		return
	}

	utils.RespondCreated(c, event, "Event created successfully")
}

// UpdateEvent godoc
// @Summary Update an event (admin/staff)
// @Tags admin-schedules
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Schedule ID" format(uuid)
// @Param vid path string true "Venue ID" format(uuid)
// @Param eid path string true "Event ID" format(uuid)
// @Param request body requests.UpdateEventRequest true "Update payload"
// @Success 200 {object} map[string]interface{}
// @Router /admin/admin-schedules/{id}/venues/{vid}/events/{eid} [put]
func (h *ScheduleHandler) UpdateEvent(c *gin.Context) {
	ctx := c.Request.Context()
	// scheduleID := c.Param("id")
	// vid := c.Param("vid")
	eid := c.Param("eid")
	if eid == "" {
		utils.RespondValidationError(c, "Event ID is required")
		return
	}

	var req requests.UpdateEventRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	event, err := h.services.Schedule.UpdateEvent(ctx, eid, &req)
	if err != nil {
		if errors.Is(err, repositories.ErrEventNotFound) {
			utils.RespondNotFound(c, "Event not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to update event")
		return
	}

	utils.RespondSuccess(c, event, "Event updated successfully")
}

// DeleteEvent godoc
// @Summary Delete an event (admin/staff)
// @Tags admin-schedules
// @Produce json
// @Security BearerAuth
// @Param id path string true "Schedule ID" format(uuid)
// @Param vid path string true "Venue ID" format(uuid)
// @Param eid path string true "Event ID" format(uuid)
// @Success 204 {object} nil
// @Router /admin/admin-schedules/{id}/venues/{vid}/events/{eid} [delete]
func (h *ScheduleHandler) DeleteEvent(c *gin.Context) {
	ctx := c.Request.Context()
	eid := c.Param("eid")
	if eid == "" {
		utils.RespondValidationError(c, "Event ID is required")
		return
	}

	err := h.services.Schedule.DeleteEvent(ctx, eid)
	if err != nil {
		if errors.Is(err, repositories.ErrEventNotFound) {
			utils.RespondNotFound(c, "Event not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to delete event")
		return
	}

	c.JSON(204, nil)
}

// DeleteSchedule godoc
// @Summary Delete a schedule (admin/staff)
// @Tags admin-schedules
// @Produce json
// @Security BearerAuth
// @Param id path string true "Schedule ID" format(uuid)
// @Success 204 {object} nil
// @Router /admin/schedules/{id} [delete]
func (h *ScheduleHandler) DeleteSchedule(c *gin.Context) {
	ctx := c.Request.Context()
	id := c.Param("id")
	if id == "" {
		utils.RespondValidationError(c, "Schedule ID is required")
		return
	}

	err := h.services.Schedule.DeleteSchedule(ctx, id)
	if err != nil {
		if errors.Is(err, repositories.ErrScheduleNotFound) {
			utils.RespondNotFound(c, "Schedule not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to delete schedule")
		return
	}

	c.JSON(204, nil)
}
