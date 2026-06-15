package services

import (
	"fmt"
	role "general-service/internal/common/constants"
	rbacreq "general-service/internal/dto/rbac/requests"
	rbacres "general-service/internal/dto/rbac/responses"
	"general-service/internal/models"
	"general-service/internal/repositories"
	"slices"

	"github.com/google/uuid"
)

type RBACService struct {
	repos *repositories.Repositories
}

func NewRBACService(repos *repositories.Repositories) *RBACService {
	return &RBACService{repos: repos}
}

var roleLabels = map[role.UserRole]struct{ En, Vi string }{
	role.RoleUser:   {En: "Attendee", Vi: "Khách tham quan"},
	role.RoleDealer: {En: "Dealer", Vi: "Nhà triển lãm"},
	role.RoleStaff:  {En: "Staff", Vi: "Nhân viên hỗ trợ"},
	role.RoleAdmin:  {En: "Admin", Vi: "Quản trị viên"},
}

func (s *RBACService) GetConfig() (*rbacres.RBACConfigResponse, error) {
	permissions, err := s.repos.RBAC.ListPermissions()
	if err != nil {
		return nil, err
	}

	permResponses := make([]rbacres.PermissionResponse, len(permissions))
	for i, p := range permissions {
		permResponses[i] = rbacres.PermissionResponse{
			Code:    p.Code,
			LabelEn: p.LabelEn,
			LabelVi: p.LabelVi,
		}
	}

	roles := []role.UserRole{role.RoleUser, role.RoleDealer, role.RoleStaff, role.RoleAdmin}
	roleResponses := make([]rbacres.RolePermissionsResponse, 0, len(roles))
	for _, r := range roles {
		codes, err := s.repos.RBAC.ListRolePermissions(r)
		if err != nil {
			return nil, err
		}
		labels := roleLabels[r]
		roleResponses = append(roleResponses, rbacres.RolePermissionsResponse{
			Role:        r.String(),
			LabelEn:     labels.En,
			LabelVi:     labels.Vi,
			Permissions: codes,
		})
	}

	return &rbacres.RBACConfigResponse{
		Roles:       roleResponses,
		Permissions: permResponses,
	}, nil
}

func (s *RBACService) UpdateRolePermissions(userRole role.UserRole, req *rbacreq.UpdateRolePermissionsRequest) (*rbacres.RolePermissionsResponse, error) {
	if !userRole.IsValid() {
		return nil, fmt.Errorf("invalid role")
	}
	if err := validatePermissionCodes(req.Permissions); err != nil {
		return nil, err
	}
	if err := s.repos.RBAC.ReplaceRolePermissions(userRole, req.Permissions); err != nil {
		return nil, err
	}
	labels := roleLabels[userRole]
	return &rbacres.RolePermissionsResponse{
		Role:        userRole.String(),
		LabelEn:     labels.En,
		LabelVi:     labels.Vi,
		Permissions: req.Permissions,
	}, nil
}

func (s *RBACService) GetEffectivePermissions(userID uuid.UUID, userRole role.UserRole) ([]string, error) {
	hasOverrides, err := s.repos.RBAC.HasUserPermissionOverrides(userID)
	if err != nil {
		return nil, err
	}
	if hasOverrides {
		return s.repos.RBAC.ListUserPermissions(userID)
	}
	return s.repos.RBAC.ListRolePermissions(userRole)
}

func (s *RBACService) SetUserPermissions(userID uuid.UUID, codes []string) error {
	if err := validatePermissionCodes(codes); err != nil {
		return err
	}
	return s.repos.RBAC.ReplaceUserPermissions(userID, codes)
}

func (s *RBACService) ClearUserPermissions(userID uuid.UUID) error {
	return s.repos.RBAC.ClearUserPermissions(userID)
}

func (s *RBACService) UserHasPermission(userID uuid.UUID, userRole role.UserRole, code string) (bool, error) {
	if userRole == role.RoleAdmin {
		return true, nil
	}
	perms, err := s.GetEffectivePermissions(userID, userRole)
	if err != nil {
		return false, err
	}
	return slices.Contains(perms, code), nil
}

func validatePermissionCodes(codes []string) error {
	for _, code := range codes {
		if !role.IsValidPermission(code) {
			return fmt.Errorf("invalid permission: %s", code)
		}
	}
	return nil
}

func (s *RBACService) SeedDefaults() error {
	count, err := s.repos.RBAC.CountPermissions()
	if err != nil {
		return err
	}
	if count > 0 {
		return nil
	}

	permissionDefs := []models.Permission{
		{Code: role.PermManageTickets, LabelEn: "Ticket management", LabelVi: "Quản lý vé"},
		{Code: role.PermScanTickets, LabelEn: "Ticket scanning", LabelVi: "Quét vé"},
		{Code: role.PermApproveProfiles, LabelEn: "Profile approval", LabelVi: "Duyệt hồ sơ"},
		{Code: role.PermSendNotifications, LabelEn: "Send notifications", LabelVi: "Gửi thông báo"},
		{Code: role.PermViewDashboard, LabelEn: "View dashboard", LabelVi: "Xem dashboard"},
		{Code: role.PermManageUsers, LabelEn: "User management", LabelVi: "Quản lý người dùng"},
	}
	for _, p := range permissionDefs {
		if err := s.repos.RBAC.UpsertPermission(&p); err != nil {
			return err
		}
	}

	for _, r := range []role.UserRole{role.RoleUser, role.RoleDealer, role.RoleStaff, role.RoleAdmin} {
		codes := role.DefaultPermissionsForRole(r)
		if err := s.repos.RBAC.ReplaceRolePermissions(r, codes); err != nil {
			return err
		}
	}
	return nil
}
