import 'package:flutter/material.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: const EmptyState(
        title: 'No events yet',
        subtitle: 'Connect the event API to load events here.',
      ),
    );
  }
}
