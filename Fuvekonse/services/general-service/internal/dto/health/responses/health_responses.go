package responses

import "time"

type ComponentHealth struct {
	Key         string `json:"key"`
	Name        string `json:"name"`
	Status      string `json:"status"` // healthy, warning, error
	LatencyMs   *int64 `json:"latency_ms,omitempty"`
	MetricLabel string `json:"metric_label,omitempty"`
	MetricValue string `json:"metric_value,omitempty"`
	HasIcon     bool   `json:"has_icon,omitempty"`
}

type SystemHealthResponse struct {
	CheckedAt time.Time         `json:"checked_at"`
	Services  []ComponentHealth `json:"services"`
}
