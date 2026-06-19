package handlers

import (
	"general-service/internal/common/utils"
	"general-service/internal/services"

	"github.com/gin-gonic/gin"
)

type HealthHandler struct {
	health *services.HealthService
}

func NewHealthHandler(health *services.HealthService) *HealthHandler {
	return &HealthHandler{health: health}
}

// GetSystemHealth godoc
//
//	@Summary		Get consolidated system health
//	@Description	Returns health for API, database, Redis, S3, and SQS/Lambda jobs
//	@Tags			health
//	@Produce		json
//	@Success		200	{object}	map[string]interface{}
//	@Router			/admin/health [get]
func (h *HealthHandler) GetSystemHealth(c *gin.Context) {
	if h.health == nil {
		utils.RespondInternalServerError(c, "Health service not configured")
		return
	}
	result := h.health.GetSystemHealth(c.Request.Context())
	utils.RespondSuccess(c, &result, "System health")
}

// CheckS3 godoc
//
//	@Summary		Check S3 storage health
//	@Tags			health
//	@Produce		json
//	@Router			/health/s3 [get]
func (h *HealthHandler) CheckS3(c *gin.Context) {
	if h.health == nil {
		c.JSON(503, gin.H{"status": "error", "error": "Health service not configured"})
		return
	}
	body, code := h.health.CheckS3(c.Request.Context())
	c.JSON(code, body)
}

// CheckSQS godoc
//
//	@Summary		Check SQS / Lambda job queue health
//	@Tags			health
//	@Produce		json
//	@Router			/health/sqs [get]
func (h *HealthHandler) CheckSQS(c *gin.Context) {
	if h.health == nil {
		c.JSON(503, gin.H{"status": "error", "error": "Health service not configured"})
		return
	}
	body, code := h.health.CheckSQS(c.Request.Context())
	c.JSON(code, body)
}
