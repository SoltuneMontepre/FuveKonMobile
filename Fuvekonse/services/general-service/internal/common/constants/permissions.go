package constants

// Permission codes used across RBAC APIs and authorization checks.
const (
	PermManageTickets      = "manage_tickets"
	PermScanTickets        = "scan_tickets"
	PermApproveProfiles    = "approve_profiles"
	PermSendNotifications  = "send_notifications"
	PermViewDashboard      = "view_dashboard"
	PermManageUsers        = "manage_users"
)

// AllPermissions returns every known permission code in display order.
func AllPermissions() []string {
	return []string{
		PermManageTickets,
		PermScanTickets,
		PermApproveProfiles,
		PermSendNotifications,
		PermViewDashboard,
		PermManageUsers,
	}
}

// DefaultPermissionsForRole returns the default permission set for a role.
func DefaultPermissionsForRole(role UserRole) []string {
	switch role {
	case RoleAdmin:
		return AllPermissions()
	case RoleStaff:
		return []string{PermScanTickets, PermViewDashboard}
	case RoleDealer, RoleUser:
		return nil
	default:
		return nil
	}
}

// IsValidPermission reports whether code is a known permission.
func IsValidPermission(code string) bool {
	for _, p := range AllPermissions() {
		if p == code {
			return true
		}
	}
	return false
}
