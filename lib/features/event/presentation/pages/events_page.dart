import 'package:flutter/material.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Events',
      showBackButton: false,
      body: const EmptyState(
        title: 'No events yet',
        subtitle: 'Connect the event API to load events here.',
      ),
    );
  }
}
