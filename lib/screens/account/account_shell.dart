import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/account/widgets/user_bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

/// Navigation shell for authenticated users (home, schedule, tickets, etc.).
class AccountShell extends StatelessWidget {
  const AccountShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: navigationShell,
      bottomNavigationBar: UserBottomNavBar(
        currentBranchIndex: navigationShell.currentIndex,
        onTap: navigationShell.goBranch,
      ),
    );
  }
}
