package handlers

import (
	role "general-service/internal/common/constants"
	"general-service/internal/common/utils"
	rbacreq "general-service/internal/dto/rbac/requests"
	"general-service/internal/services"

	"github.com/gin-gonic/gin"
)

type RBACHandler struct {
	services *services.Services
}

func NewRBACHandler(services *services.Services) *RBACHandler {
	return &RBACHandler{services: services}
}

// GetConfig godoc
//
//	@Summary		Get RBAC configuration
//	@Description	Returns all roles with default permissions and the permission catalog
//	@Tags			admin-rbac
//	@Produce		json
//	@Success		200	{object}	map[string]interface{}
//	@Router			/admin/rbac [get]
func (h *RBACHandler) GetConfig(c *gin.Context) {
	config, err := h.services.RBAC.GetConfig()
	if err != nil {
		utils.RespondInternalServerError(c, err.Error())
		return
	}
	utils.RespondSuccess(c, config, "RBAC configuration retrieved")
}

// UpdateRolePermissions godoc
//
//	@Summary		Update default permissions for a role
//	@Description	Sets the default permission group for Attendee, Dealer, Staff, or Admin
//	@Tags			admin-rbac
//	@Accept			json
//	@Produce		json
//	@Param			role	path	string	true	"Role name (User, Dealer, Staff, Admin)"
//	@Param			body	body	rbacreq.UpdateRolePermissionsRequest	true	"Permission codes"
//	@Success		200	{object}	map[string]interface{}
//	@Router			/admin/rbac/roles/{role}/permissions [put]
func (h *RBACHandler) UpdateRolePermissions(c *gin.Context) {
	roleName := c.Param("role")
	userRole, err := role.ParseUserRole(roleName)
	if err != nil {
		utils.RespondBadRequest(c, err.Error())
		return
	}

	var req rbacreq.UpdateRolePermissionsRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.RespondBadRequest(c, err.Error())
		return
	}

	updated, err := h.services.RBAC.UpdateRolePermissions(userRole, &req)
	if err != nil {
		utils.RespondBadRequest(c, err.Error())
		return
	}
	utils.RespondSuccess(c, updated, "Role permissions updated")
}

// GetMyPermissions godoc
//
//	@Summary		Get current user effective permissions
//	@Description	Returns permission codes for the authenticated user
//	@Tags			rbac
//	@Produce		json
//	@Success		200	{object}	map[string]interface{}
//	@Router			/users/me/permissions [get]
func (h *RBACHandler) GetMyPermissions(c *gin.Context) {
	userID, err := utils.GetUserIDFromContext(c)
	if err != nil {
		utils.RespondUnauthorized(c, "Authentication required")
		return
	}
	userRole := utils.GetRoleFromContext(c)
	perms, err := h.services.RBAC.GetEffectivePermissions(userID, userRole)
	if err != nil {
		utils.RespondInternalServerError(c, err.Error())
		return
	}
	type permissionsPayload struct {
		Permissions []string `json:"permissions"`
	}
	payload := permissionsPayload{Permissions: perms}
	utils.RespondSuccess(c, &payload, "Permissions retrieved")
}
