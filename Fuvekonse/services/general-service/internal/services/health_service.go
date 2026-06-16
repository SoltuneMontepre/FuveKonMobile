package services

import (
	"context"
	"fmt"
	"net/http"
	"strconv"
	"time"

	healthresponses "general-service/internal/dto/health/responses"
	"general-service/internal/queue"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"github.com/aws/aws-sdk-go-v2/service/sqs/types"
	"gorm.io/gorm"
)

const (
	healthStatusHealthy = "healthy"
	healthStatusWarning = "warning"
	healthStatusError   = "error"
)

type HealthService struct {
	db       *gorm.DB
	redisSet func(ctx context.Context, key string, value interface{}, expiration time.Duration) error
	s3       *S3Service
	sqs      *queue.SQSClient
}

func NewHealthService(
	db *gorm.DB,
	redisSet func(ctx context.Context, key string, value interface{}, expiration time.Duration) error,
	s3Service *S3Service,
	sqsClient *queue.SQSClient,
) *HealthService {
	return &HealthService{
		db:       db,
		redisSet: redisSet,
		s3:       s3Service,
		sqs:      sqsClient,
	}
}

func (s *HealthService) GetSystemHealth(ctx context.Context) healthresponses.SystemHealthResponse {
	return healthresponses.SystemHealthResponse{
		CheckedAt: time.Now().UTC(),
		Services: []healthresponses.ComponentHealth{
			s.checkBackendAPI(),
			s.checkDatabase(ctx),
			s.checkRedis(ctx),
			s.checkS3(ctx),
			s.checkLambdaJobs(ctx),
		},
	}
}

func (s *HealthService) checkBackendAPI() healthresponses.ComponentHealth {
	start := time.Now()
	latency := time.Since(start).Milliseconds()
	return component(
		"backend_api",
		"Backend API",
		healthStatusHealthy,
		&latency,
		"Latency",
		fmt.Sprintf("%dms", latency),
		false,
	)
}

func (s *HealthService) checkDatabase(ctx context.Context) healthresponses.ComponentHealth {
	start := time.Now()
	sqlDB, err := s.db.DB()
	if err != nil {
		return component("database", "Database Postgres", healthStatusError, nil, "Query Time", "—", false)
	}
	if err := sqlDB.PingContext(ctx); err != nil {
		return component("database", "Database Postgres", healthStatusError, nil, "Query Time", "—", false)
	}
	latency := time.Since(start).Milliseconds()
	return component(
		"database",
		"Database Postgres",
		healthStatusHealthy,
		&latency,
		"Query Time",
		fmt.Sprintf("%dms", latency),
		false,
	)
}

func (s *HealthService) checkRedis(ctx context.Context) healthresponses.ComponentHealth {
	start := time.Now()
	if s.redisSet == nil {
		return component("redis", "Redis Cache", healthStatusError, nil, "Response", "—", false)
	}
	checkCtx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()
	if err := s.redisSet(checkCtx, "health_check", "ok", time.Minute); err != nil {
		return component("redis", "Redis Cache", healthStatusError, nil, "Response", "—", false)
	}
	latency := time.Since(start).Milliseconds()
	return component(
		"redis",
		"Redis Cache",
		healthStatusHealthy,
		&latency,
		"Response",
		fmt.Sprintf("%dms", latency),
		false,
	)
}

func (s *HealthService) checkS3(ctx context.Context) healthresponses.ComponentHealth {
	start := time.Now()
	if s.s3 == nil {
		return component("s3", "S3 Storage", healthStatusError, nil, "", "", true)
	}
	if err := s.s3.Ping(ctx); err != nil {
		return component("s3", "S3 Storage", healthStatusError, nil, "", "", true)
	}
	latency := time.Since(start).Milliseconds()
	return component(
		"s3",
		"S3 Storage",
		healthStatusHealthy,
		&latency,
		"Response",
		fmt.Sprintf("%dms", latency),
		true,
	)
}

func (s *HealthService) checkLambdaJobs(ctx context.Context) healthresponses.ComponentHealth {
	if s.sqs == nil {
		return component(
			"lambda_jobs",
			"Lambda Jobs",
			healthStatusHealthy,
			nil,
			"jobs retry",
			"0",
			false,
		)
	}

	start := time.Now()
	checkCtx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	out, err := s.sqs.Client().GetQueueAttributes(checkCtx, &sqs.GetQueueAttributesInput{
		QueueUrl: aws.String(s.sqs.QueueURL()),
		AttributeNames: []types.QueueAttributeName{
			types.QueueAttributeNameApproximateNumberOfMessages,
			types.QueueAttributeNameApproximateNumberOfMessagesNotVisible,
			types.QueueAttributeNameApproximateNumberOfMessagesDelayed,
		},
	})
	if err != nil {
		return component("lambda_jobs", "Lambda Jobs", healthStatusError, nil, "jobs retry", "—", false)
	}

	inFlight := attrInt(out.Attributes, string(types.QueueAttributeNameApproximateNumberOfMessagesNotVisible))
	pending := attrInt(out.Attributes, string(types.QueueAttributeNameApproximateNumberOfMessages))
	_ = attrInt(out.Attributes, string(types.QueueAttributeNameApproximateNumberOfMessagesDelayed))
	latency := time.Since(start).Milliseconds()

	status := healthStatusHealthy
	if inFlight > 0 || pending > 50 {
		status = healthStatusWarning
	}

	return component(
		"lambda_jobs",
		"Lambda Jobs",
		status,
		&latency,
		"jobs retry",
		strconv.Itoa(inFlight),
		false,
	)
}

// CheckS3 returns a simple health payload for GET /health/s3.
func (s *HealthService) CheckS3(ctx context.Context) (map[string]interface{}, int) {
	result := s.checkS3(ctx)
	return map[string]interface{}{
		"status":     result.Status,
		"latency_ms": result.LatencyMs,
	}, statusCode(result.Status)
}

// CheckSQS returns queue health for GET /health/sqs.
func (s *HealthService) CheckSQS(ctx context.Context) (map[string]interface{}, int) {
	result := s.checkLambdaJobs(ctx)
	return map[string]interface{}{
		"status":       result.Status,
		"latency_ms":   result.LatencyMs,
		"metric_label": result.MetricLabel,
		"metric_value": result.MetricValue,
	}, statusCode(result.Status)
}

func component(
	key, name, status string,
	latencyMs *int64,
	metricLabel, metricValue string,
	hasIcon bool,
) healthresponses.ComponentHealth {
	return healthresponses.ComponentHealth{
		Key:         key,
		Name:        name,
		Status:      status,
		LatencyMs:   latencyMs,
		MetricLabel: metricLabel,
		MetricValue: metricValue,
		HasIcon:     hasIcon,
	}
}

func statusCode(status string) int {
	if status == healthStatusError {
		return http.StatusServiceUnavailable
	}
	return http.StatusOK
}

func attrInt(attrs map[string]string, key string) int {
	if attrs == nil {
		return 0
	}
	value, err := strconv.Atoi(attrs[key])
	if err != nil {
		return 0
	}
	return value
}
