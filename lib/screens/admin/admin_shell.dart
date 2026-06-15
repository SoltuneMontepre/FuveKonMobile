import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

/// Navigation shell for admin and staff on-site operations.
class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final auth = sl<AuthSessionNotifier>();

    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: FuvekonColors.darkBg,
          body: navigationShell,
          bottomNavigationBar: AdminBottomNavBar(
            currentBranchIndex: navigationShell.currentIndex,
            isAdmin: auth.isAdmin,
            onTap: navigationShell.goBranch,
          ),
        );
      },
    );
  }
}
