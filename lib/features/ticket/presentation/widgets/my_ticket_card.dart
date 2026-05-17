import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/utils/ticket_price.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/ticket_status_label.dart';
import 'package:intl/intl.dart';

class MyTicketCard extends StatelessWidget {
  const MyTicketCard({
    super.key,
    required this.ticket,
    this.onPay,
  });

  final UserTicket ticket;
  final VoidCallback? onPay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final tier = ticket.tier;
    final dateFormat = DateFormat.yMMMd(locale.toString());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Your ticket',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TicketStatusLabel(status: ticket.status),
              ],
            ),
            const SizedBox(height: 20),
            _InfoRow(
              label: 'Ticket type',
              value: tier?.ticketName ?? '—',
            ),
            _InfoRow(
              label: 'Reference code',
              value: ticket.referenceCode,
              mono: true,
            ),
            if (tier != null)
              _InfoRow(
                label: 'Price',
                value: formatTierPrice(tier, locale: locale),
              ),
            _InfoRow(
              label: 'Purchase date',
              value: dateFormat.format(ticket.createdAt.toLocal()),
            ),
            if (ticket.ticketNumber > 0)
              _InfoRow(
                label: 'Ticket number',
                value: '#${ticket.ticketNumber}',
              ),
            const SizedBox(height: 16),
            switch (ticket.status) {
              TicketStatus.pending => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Please complete payment to confirm your ticket.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (onPay != null) ...[
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: onPay,
                        icon: const Icon(Icons.payment_outlined),
                        label: const Text('Pay now'),
                      ),
                    ],
                  ],
                ),
              TicketStatus.selfConfirmed => Text(
                  'We have received your payment confirmation. '
                  'Verification takes 3–5 business days.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              TicketStatus.denied => Text(
                  ticket.denialReason?.isNotEmpty == true
                      ? 'Denied: ${ticket.denialReason}'
                      : 'Your ticket was denied.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              TicketStatus.approved => Text(
                  'Your ticket is confirmed. See you at the convention!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              TicketStatus.adminGranted => Text(
                  'This ticket was granted by an admin.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            },
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontFamily: mono ? 'monospace' : null,
              fontWeight: mono ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
