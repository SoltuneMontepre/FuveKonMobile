package requests

type UpdateRolePermissionsRequest struct {
	Permissions []string `json:"permissions" binding:"required"`
}
