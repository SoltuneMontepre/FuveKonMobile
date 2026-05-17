import 'package:flutter/material.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';

class TicketStatusLabel extends StatelessWidget {
  const TicketStatusLabel({super.key, required this.status});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color, bg) = switch (status) {
      TicketStatus.pending => (
          'Pending payment',
          Colors.amber.shade800,
          Colors.amber.shade100,
        ),
      TicketStatus.selfConfirmed => (
          'Verifying',
          Colors.blue.shade800,
          Colors.blue.shade100,
        ),
      TicketStatus.approved => (
          'Confirmed',
          Colors.green.shade800,
          Colors.green.shade100,
        ),
      TicketStatus.denied => (
          'Denied',
          Colors.red.shade800,
          Colors.red.shade100,
        ),
      TicketStatus.adminGranted => (
          'Admin granted',
          Colors.purple.shade800,
          Colors.purple.shade100,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
