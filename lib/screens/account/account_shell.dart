import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_unread_cubit.dart';
import 'package:fuvekonmobile/screens/account/widgets/user_bottom_nav_bar.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';
import 'package:go_router/go_router.dart';

/// Navigation shell for authenticated users (home, schedule, tickets, etc.).
class AccountShell extends StatefulWidget {
  const AccountShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AccountShell> createState() => _AccountShellState();
}

class _AccountShellState extends State<AccountShell> {
  @override
  void initState() {
    super.initState();
    sl<NotificationUnreadCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      drawer: const FuvekonGuestDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SafeArea(bottom: false, child: FuvekonTopNavBar()),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: BlocBuilder<NotificationUnreadCubit, int>(
        bloc: sl<NotificationUnreadCubit>(),
        builder: (context, unreadCount) {
          return UserBottomNavBar(
            currentBranchIndex: widget.navigationShell.currentIndex,
            notificationUnreadCount: unreadCount,
            onTap: widget.navigationShell.goBranch,
          );
        },
      ),
    );
  }
}
