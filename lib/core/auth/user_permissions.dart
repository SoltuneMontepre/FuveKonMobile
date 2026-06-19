import 'package:fuvekonmobile/core/router/routes.dart';

/// Permission codes aligned with backend `permissions.go`.
abstract final class UserPermissions {
  static const manageTickets = 'manage_tickets';
  static const scanTickets = 'scan_tickets';
  static const approveProfiles = 'approve_profiles';
  static const sendNotifications = 'send_notifications';
  static const viewDashboard = 'view_dashboard';
  static const manageUsers = 'manage_users';

  /// Shell branches (index matches [AdminRoutes] StatefulShellRoute).
  static const adminShellBranches = <AdminShellBranch>[
    AdminShellBranch(branchIndex: 0, route: Routes.admin),
    AdminShellBranch(
      branchIndex: 1,
      route: Routes.adminDashboard,
      requiredPermission: viewDashboard,
    ),
    AdminShellBranch(
      branchIndex: 2,
      route: Routes.adminScanTicket,
      requiredPermission: scanTickets,
    ),
    AdminShellBranch(
      branchIndex: 3,
      route: Routes.adminHistory,
      requiredPermission: scanTickets,
      showInBottomNav: false,
    ),
    AdminShellBranch(
      branchIndex: 4,
      route: Routes.adminLostFound,
      requiredPermission: approveProfiles,
      showInBottomNav: false,
    ),
    AdminShellBranch(
      branchIndex: 5,
      route: Routes.adminSystem,
    ),
  ];

  static AdminShellBranch? branchForIndex(int branchIndex) {
    for (final branch in adminShellBranches) {
      if (branch.branchIndex == branchIndex) return branch;
    }
    return null;
  }

  static String routeForBranch(int branchIndex) =>
      branchForIndex(branchIndex)?.route ?? Routes.admin;

  static bool canAccessBranch(
    int branchIndex, {
    required bool isAdmin,
    required bool Function(String permission) hasPermission,
  }) {
    if (isAdmin) return true;
    final branch = branchForIndex(branchIndex);
    if (branch == null) return false;
    final required = branch.requiredPermission;
    if (required == null) return true;
    return hasPermission(required);
  }

  static int firstAccessibleBranch({
    required bool isAdmin,
    required bool Function(String permission) hasPermission,
  }) {
    for (final branch in adminShellBranches) {
      if (canAccessBranch(
        branch.branchIndex,
        isAdmin: isAdmin,
        hasPermission: hasPermission,
      )) {
        return branch.branchIndex;
      }
    }
    return 0;
  }

  /// Required permission for an admin route, or `null` if privileged role is enough.
  static String? requiredForRoute(String location) {
    if (location == Routes.admin) return null;

    if (location.startsWith(Routes.adminDashboard)) {
      return viewDashboard;
    }
    if (location.startsWith(Routes.adminSystem)) {
      return null;
    }
    if (location == Routes.adminScanTicket || location == Routes.adminHistory) {
      return scanTickets;
    }
    if (location.startsWith(Routes.adminLostFound)) {
      return approveProfiles;
    }
    if (location.startsWith('${Routes.admin}/tickets')) {
      return manageTickets;
    }
    if (location.startsWith('${Routes.admin}/users')) {
      return manageUsers;
    }
    if (location.startsWith('${Routes.admin}/art-submit') ||
        location.startsWith('${Routes.admin}/panels') ||
        location.startsWith('${Routes.admin}/talents') ||
        location.startsWith('${Routes.admin}/dealers') ||
        location.startsWith('${Routes.admin}/schedules')) {
      return approveProfiles;
    }

    return null;
  }
}

class AdminShellBranch {
  const AdminShellBranch({
    required this.branchIndex,
    required this.route,
    this.requiredPermission,
    this.showInBottomNav = true,
  });

  final int branchIndex;
  final String route;
  final String? requiredPermission;
  final bool showInBottomNav;
}
