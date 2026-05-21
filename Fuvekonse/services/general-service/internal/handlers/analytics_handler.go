package handlers

import (
	"general-service/internal/common/utils"
	"general-service/internal/services"
	"time"

	"github.com/gin-gonic/gin"
)

type AnalyticsHandler struct {
	services *services.Services
}

func NewAnalyticsHandler(services *services.Services) *AnalyticsHandler {
	return &AnalyticsHandler{services: services}
}

// maxSpan returns the maximum allowed time span for a given granularity.
func maxSpan(granularity string) time.Duration {
	switch granularity {
	case "minute":
		return 24 * time.Hour // 1 day
	case "hour":
		return 7 * 24 * time.Hour // 7 days
	default: // "day"
		return 365 * 24 * time.Hour // 365 days
	}
}

// defaultSpan returns a sensible default span when no from/to is provided.
func defaultSpan(granularity string) time.Duration {
	switch granularity {
	case "minute":
		return 1 * time.Hour
	case "hour":
		return 24 * time.Hour
	default:
		return 90 * 24 * time.Hour
	}
}

// parseTimelineRange parses from/to/granularity query params with validation.
// Returns a clamped TimelineRange. Falls back to sensible defaults.
func parseTimelineRange(c *gin.Context, fromKey, toKey, granularityKey string) services.TimelineRange {
	granularity := "day"
	if v := c.Query(granularityKey); v == "hour" || v == "minute" {
		granularity = v
	}

	now := time.Now()
	max := maxSpan(granularity)

	var from, to time.Time

	if v := c.Query(fromKey); v != "" {
		if t, err := time.Parse(time.RFC3339, v); err == nil {
			from = t
		}
	}
	if v := c.Query(toKey); v != "" {
		if t, err := time.Parse(time.RFC3339, v); err == nil {
			to = t
		}
	}

	// Apply defaults
	if to.IsZero() {
		to = now
	}
	if from.IsZero() {
		from = to.Add(-defaultSpan(granularity))
	}

	// Clamp: to must not be in the future
	if to.After(now) {
		to = now
	}
	// Clamp: span must not exceed max
	if to.Sub(from) > max {
		from = to.Add(-max)
	}
	// Sanity: from must be before to
	if !from.Before(to) {
		from = to.Add(-defaultSpan(granularity))
	}

	return services.TimelineRange{
		From:        from,
		To:          to,
		Granularity: granularity,
	}
}

// GetDashboard godoc
// @Summary Get dashboard analytics (admin only)
// @Description Returns consolidated dashboard data: ticket stats, sales timeline, revenue, user count, dealer count, users by country. Single request for all dashboard metrics.
// @Tags admin
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param timeline_from query string false "Sales timeline start (RFC3339)"
// @Param timeline_to query string false "Sales timeline end (RFC3339)"
// @Param timeline_granularity query string false "Timeline grouping: day, hour, or minute" default(day) Enums(day,hour,minute)
// @Param revenue_from query string false "Revenue timeline start (RFC3339)"
// @Param revenue_to query string false "Revenue timeline end (RFC3339)"
// @Param revenue_granularity query string false "Revenue timeline grouping: day, hour, or minute" default(day) Enums(day,hour,minute)
// @Success 200 "Dashboard analytics"
// @Failure 401 "Unauthorized"
// @Failure 403 "Forbidden"
// @Failure 500 "Internal server error"
// @Router /admin/analytics/dashboard [get]
func (h *AnalyticsHandler) GetDashboard(c *gin.Context) {
	timeline := parseTimelineRange(c, "timeline_from", "timeline_to", "timeline_granularity")
	revenue := parseTimelineRange(c, "revenue_from", "revenue_to", "revenue_granularity")

	data, err := h.services.Analytics.GetDashboard(c.Request.Context(), timeline, revenue)
	if err != nil {
		utils.RespondInternalServerError(c, "Failed to load dashboard analytics")
		return
	}

	utils.RespondSuccess(c, data, "Dashboard analytics")
}
