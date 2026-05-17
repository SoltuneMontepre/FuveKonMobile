import 'package:flutter/material.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const EmptyState(
        title: 'No notifications',
        subtitle: 'You are all caught up.',
        icon: Icons.notifications_outlined,
      ),
    );
  }
}
