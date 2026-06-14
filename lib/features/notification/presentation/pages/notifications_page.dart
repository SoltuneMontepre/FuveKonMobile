import 'package:flutter/material.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Notifications',
      showBackButton: false,
      body: const EmptyState(
        title: 'No notifications',
        subtitle: 'You are all caught up.',
        icon: Icons.notifications_outlined,
      ),
    );
  }
}
