import 'package:flutter/material.dart';
import 'package:fuvekonmobile/shared/widgets/placeholder_page.dart';

class TicketInfoPage extends StatelessWidget {
  const TicketInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Tickets',
      subtitle: 'Ticket tiers, pricing, and event access info.',
      icon: Icons.confirmation_number_outlined,
    );
  }
}
