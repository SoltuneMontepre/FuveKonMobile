import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/auth/user_permissions.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_bottom_nav_bar.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';
import 'package:go_router/go_router.dart';

/// Navigation shell for admin and staff on-site operations.
class AdminShell extends StatefulWidget {
  const AdminShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final _auth = sl<AuthSessionNotifier>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FuvekonGuestDrawer.adminScaffoldKey = _scaffoldKey;
    _auth.addListener(_guardCurrentBranch);
    WidgetsBinding.instance.addPostFrameCallback((_) => _guardCurrentBranch());
  }

  @override
  void dispose() {
    if (FuvekonGuestDrawer.adminScaffoldKey == _scaffoldKey) {
      FuvekonGuestDrawer.adminScaffoldKey = null;
    }
    _auth.removeListener(_guardCurrentBranch);
    super.dispose();
  }

  void _guardCurrentBranch() {
    if (!mounted) return;

    final branch = widget.navigationShell.currentIndex;
    if (UserPermissions.canAccessBranch(
      branch,
      isAdmin: _auth.isAdmin,
      hasPermission: _auth.hasPermission,
    )) {
      return;
    }

    final fallback = UserPermissions.firstAccessibleBranch(
      isAdmin: _auth.isAdmin,
      hasPermission: _auth.hasPermission,
    );
    if (branch == fallback) return;

    widget.navigationShell.goBranch(fallback);
    final targetRoute = UserPermissions.routeForBranch(fallback);
    final currentLocation = GoRouterState.of(context).matchedLocation;
    if (currentLocation != targetRoute) {
      context.go(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _auth,
      builder: (context, _) {
        final branch = widget.navigationShell.currentIndex;
        final canViewBranch = UserPermissions.canAccessBranch(
          branch,
          isAdmin: _auth.isAdmin,
          hasPermission: _auth.hasPermission,
        );

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: FuvekonColors.darkBg,
          drawer: const FuvekonGuestDrawer(),
          body: canViewBranch
              ? widget.navigationShell
              : const _AdminBranchDenied(),
          bottomNavigationBar: AdminBottomNavBar(
            currentBranchIndex: widget.navigationShell.currentIndex,
            hasPermission: _auth.hasPermission,
            onTap: widget.navigationShell.goBranch,
          ),
        );
      },
    );
  }
}

class _AdminBranchDenied extends StatelessWidget {
  const _AdminBranchDenied();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
