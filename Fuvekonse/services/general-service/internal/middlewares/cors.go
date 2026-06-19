package middlewares

import (
	"os"
	"slices"
	"strings"

	"github.com/gin-gonic/gin"
)

func isOriginAllowed(origin string, trimmedOrigins []string) bool {
	if origin == "" {
		return false
	}
	if slices.Contains(trimmedOrigins, origin) {
		return true
	}
	// Local dev: Flutter web uses dynamic localhost ports.
	if strings.EqualFold(strings.TrimSpace(os.Getenv("ENV")), "development") {
		return strings.HasPrefix(origin, "http://localhost:") ||
			strings.HasPrefix(origin, "http://127.0.0.1:")
	}
	return false
}

func handlePreflightRequest(c *gin.Context, origin string, trimmedOrigins []string) bool {
	if origin == "" {
		return false
	}
	if isOriginAllowed(origin, trimmedOrigins) {
		setCorsHeaders(c, origin)
		c.Header("Access-Control-Max-Age", "43200")
		c.AbortWithStatus(204)
		return true
	}
	c.AbortWithStatus(403)
	return true
}

func setCorsHeaders(c *gin.Context, origin string) {
	c.Header("Access-Control-Allow-Origin", origin)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization, Accept, Origin, X-Requested-With")
	c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS")
	c.Header("Access-Control-Expose-Headers", "Set-Cookie")
}

func handleActualRequest(c *gin.Context, origin string, trimmedOrigins []string) {
	if origin != "" && isOriginAllowed(origin, trimmedOrigins) {
		setCorsHeaders(c, origin)
	}
}

func CorsMiddleware(allowedOrigins string) gin.HandlerFunc {
	trimmedOrigins := []string{}
	if allowedOrigins != "" {
		origins := strings.Split(allowedOrigins, ",")
		for _, o := range origins {
			trimmedOrigins = append(trimmedOrigins, strings.TrimSpace(o))
		}
	}

	return func(c *gin.Context) {
		c.Header("Vary", "Origin")
		if len(trimmedOrigins) == 0 {
			c.Next()
			return
		}
		origin := c.Request.Header.Get("Origin")

		// Handle preflight OPTIONS requests
		if c.Request.Method == "OPTIONS" {
			if handlePreflightRequest(c, origin, trimmedOrigins) {
				return
			}
		} else {
			// For actual requests (non-OPTIONS), allow them to proceed
			// but only set CORS headers if origin is allowed
			handleActualRequest(c, origin, trimmedOrigins)
		}
		c.Next()
	}
}
