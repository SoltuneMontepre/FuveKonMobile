package middlewares

import (
	role "general-service/internal/common/constants"
	"general-service/internal/common/utils"
	"general-service/internal/repositories"
	"slices"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// RequirePermission checks that the authenticated user has a specific permission.
// Admin role always passes. Staff and other roles are checked against effective permissions.
func RequirePermission(rbacRepo *repositories.RBACRepository, permission string) gin.HandlerFunc {
	return func(c *gin.Context) {
		if !utils.IsAuthenticated(c) {
			utils.RespondUnauthorized(c, "Authentication required")
			c.Abort()
			return
		}

		userRole := utils.GetRoleFromContext(c)
		if userRole == role.RoleAdmin {
			c.Next()
			return
		}

		userID, err := utils.GetUserIDFromContext(c)
		if err != nil || userID == uuid.Nil {
			utils.RespondForbidden(c, "Unable to determine user")
			c.Abort()
			return
		}

		hasOverrides, err := rbacRepo.HasUserPermissionOverrides(userID)
		if err != nil {
			utils.RespondInternalServerError(c, "Failed to check permissions")
			c.Abort()
			return
		}

		var perms []string
		if hasOverrides {
			perms, err = rbacRepo.ListUserPermissions(userID)
		} else {
			perms, err = rbacRepo.ListRolePermissions(userRole)
		}
		if err != nil {
			utils.RespondInternalServerError(c, "Failed to check permissions")
			c.Abort()
			return
		}

		if slices.Contains(perms, permission) {
			c.Next()
			return
		}

		utils.RespondForbidden(c, "Insufficient permissions")
		c.Abort()
	}
}
