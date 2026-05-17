import 'package:flutter/material.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tickets')),
      body: const EmptyState(
        title: 'No tickets yet',
        subtitle: 'Your purchased tickets will appear here.',
        icon: Icons.confirmation_number_outlined,
      ),
    );
  }
}
