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

// CreateTimelineItem godoc
// @Summary Create a timeline item on a schedule (admin/staff)
// @Tags admin-schedules
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Schedule ID" format(uuid)
// @Param request body requests.TimelineItemInput true "Timeline item payload"
// @Success 201 {object} map[string]interface{}
// @Router /admin/admin-schedules/{id}/timeline [post]
func (h *ScheduleHandler) CreateTimelineItem(c *gin.Context) {
	ctx := c.Request.Context()
	scheduleID := c.Param("id")
	if scheduleID == "" {
		utils.RespondValidationError(c, "Schedule ID is required")
		return
	}

	var req requests.TimelineItemInput
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	item, err := h.services.Schedule.CreateTimelineItem(ctx, scheduleID, &req)
	if err != nil {
		if errors.Is(err, repositories.ErrScheduleNotFound) {
			utils.RespondNotFound(c, "Schedule not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to create timeline item")
		return
	}

	utils.RespondCreated(c, item, "Timeline item created successfully")
}

// UpdateTimelineItem godoc
// @Summary Update a timeline item (admin/staff)
// @Tags admin-schedules
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Schedule ID" format(uuid)
// @Param tid path string true "Timeline item ID" format(uuid)
// @Param request body requests.UpdateTimelineItemRequest true "Update payload"
// @Success 200 {object} map[string]interface{}
// @Router /admin/admin-schedules/{id}/timeline/{tid} [put]
func (h *ScheduleHandler) UpdateTimelineItem(c *gin.Context) {
	ctx := c.Request.Context()
	scheduleID := c.Param("id")
	itemID := c.Param("tid")
	if scheduleID == "" {
		utils.RespondValidationError(c, "Schedule ID is required")
		return
	}
	if itemID == "" {
		utils.RespondValidationError(c, "Timeline item ID is required")
		return
	}

	var req requests.UpdateTimelineItemRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondValidationError(c, err.Error())
		return
	}

	item, err := h.services.Schedule.UpdateTimelineItem(ctx, scheduleID, itemID, &req)
	if err != nil {
		if errors.Is(err, repositories.ErrTimelineItemNotFound) {
			utils.RespondNotFound(c, "Timeline item not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to update timeline item")
		return
	}

	utils.RespondSuccess(c, item, "Timeline item updated successfully")
}

// DeleteTimelineItem godoc
// @Summary Delete a timeline item (admin/staff)
// @Tags admin-schedules
// @Produce json
// @Security BearerAuth
// @Param id path string true "Schedule ID" format(uuid)
// @Param tid path string true "Timeline item ID" format(uuid)
// @Success 204 {object} nil
// @Router /admin/admin-schedules/{id}/timeline/{tid} [delete]
func (h *ScheduleHandler) DeleteTimelineItem(c *gin.Context) {
	ctx := c.Request.Context()
	scheduleID := c.Param("id")
	itemID := c.Param("tid")
	if scheduleID == "" {
		utils.RespondValidationError(c, "Schedule ID is required")
		return
	}
	if itemID == "" {
		utils.RespondValidationError(c, "Timeline item ID is required")
		return
	}

	err := h.services.Schedule.DeleteTimelineItem(ctx, scheduleID, itemID)
	if err != nil {
		if errors.Is(err, repositories.ErrTimelineItemNotFound) {
			utils.RespondNotFound(c, "Timeline item not found")
			return
		}
		utils.RespondInternalServerError(c, "Failed to delete timeline item")
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
