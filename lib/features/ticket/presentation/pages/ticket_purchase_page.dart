import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/utils/ticket_price.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_purchase_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_purchase_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_purchase_state.dart';

class TicketPurchasePage extends StatelessWidget {
  const TicketPurchasePage({
    super.key,
    required this.tierId,
    this.queued = false,
  });

  final String tierId;
  final bool queued;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TicketPurchaseBloc>()
        ..add(
          TicketPurchaseEvent.started(tierId: tierId, queued: queued),
        ),
      child: _TicketPurchaseView(tierId: tierId, queued: queued),
    );
  }
}

class _TicketPurchaseView extends StatefulWidget {
  const _TicketPurchaseView({required this.tierId, required this.queued});

  final String tierId;
  final bool queued;

  @override
  State<_TicketPurchaseView> createState() => _TicketPurchaseViewState();
}

class _TicketPurchaseViewState extends State<_TicketPurchaseView> {
  final _idCardController = TextEditingController();
  String? _copiedField;

  @override
  void dispose() {
    _idCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TicketPurchaseBloc, TicketPurchaseState>(
      listener: (context, state) {
        final bloc = context.read<TicketPurchaseBloc>();
        final actionError = bloc.lastActionError;
        if (actionError != null) {
          bloc.lastActionError = null;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(actionError)),
          );
        }

        if (state is TicketPurchaseConfirmed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment confirmation submitted.'),
            ),
          );
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Payment')),
          body: switch (state) {
            TicketPurchaseInitial() || TicketPurchaseLoading() =>
              const Center(child: CircularProgressIndicator()),
            TicketPurchaseNotFound(:final queued) => _NotFoundBody(
                queued: queued,
                onRetry: () => context.read<TicketPurchaseBloc>().add(
                      TicketPurchaseEvent.started(
                        tierId: widget.tierId,
                        queued: queued,
                      ),
                    ),
                onBack: () => Navigator.of(context).pop(),
              ),
            TicketPurchaseDenied(:final ticket, :final denialReason) =>
              _DeniedBody(
                denialReason: denialReason.isNotEmpty
                    ? denialReason
                    : ticket.denialReason,
                onBack: () => Navigator.of(context).pop(),
              ),
            TicketPurchaseLoaded() => _PaymentBody(
                state: state,
                idCardController: _idCardController,
                copiedField: _copiedField,
                onCopy: (text, field) async {
                  await Clipboard.setData(ClipboardData(text: text));
                  setState(() => _copiedField = field);
                },
                onSaveIdCard: () {
                  context.read<TicketPurchaseBloc>().add(
                        TicketPurchaseEvent.idCardSaved(
                          _idCardController.text,
                        ),
                      );
                },
                onConfirm: () {
                  context.read<TicketPurchaseBloc>().add(
                        const TicketPurchaseEvent.confirmPaymentRequested(),
                      );
                },
              ),
            TicketPurchaseFailure(:final message) => _ErrorBody(
                message: message,
                onRetry: () => context.read<TicketPurchaseBloc>().add(
                      TicketPurchaseEvent.started(
                        tierId: widget.tierId,
                        queued: widget.queued,
                      ),
                    ),
              ),
            TicketPurchaseConfirmed() =>
              const Center(child: CircularProgressIndicator()),
          },
        );
      },
    );
  }
}

class _PaymentBody extends StatelessWidget {
  const _PaymentBody({
    required this.state,
    required this.idCardController,
    required this.copiedField,
    required this.onCopy,
    required this.onSaveIdCard,
    required this.onConfirm,
  });

  final TicketPurchaseLoaded state;
  final TextEditingController idCardController;
  final String? copiedField;
  final void Function(String text, String field) onCopy;
  final VoidCallback onSaveIdCard;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final ticket = state.ticket;
    final tier = ticket.tier;
    final locale = Localizations.localeOf(context);
    final amount = tier != null ? formatTierPrice(tier, locale: locale) : '—';
    final needsIdCard = (state.account.idCard?.trim().isEmpty ?? true);

    if (needsIdCard && idCardController.text.isEmpty) {
      idCardController.text = state.account.idCard ?? '';
    }

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Transfer details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _PaymentField(label: 'Ticket type', value: tier?.ticketName ?? '—'),
            _PaymentField(label: 'Amount', value: amount),
            _CopyableField(
              label: 'Reference code',
              value: ticket.referenceCode,
              field: 'reference',
              copiedField: copiedField,
              onCopy: onCopy,
              mono: true,
            ),
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Transfer the exact amount using your bank app. '
                  'Include the reference code in the transfer description.',
                ),
              ),
            ),
            const SizedBox(height: 12),
            _CopyableField(
              label: 'PayPal',
              value: 'paypal.me/alaskyyy',
              field: 'paypal',
              copiedField: copiedField,
              onCopy: onCopy,
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Transfer the exact ticket amount.'),
                    Text('2. Amount: $amount'),
                    Text(
                      '3. Transfer description: ${ticket.referenceCode}',
                    ),
                    const Text(
                      '4. After transferring, tap "I have paid" below.',
                    ),
                    const Text(
                      '5. Verification takes 3–5 business days.',
                    ),
                  ],
                ),
              ),
            ),
            if (needsIdCard) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Passport / ID card required',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.red.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: idCardController,
                        decoration: const InputDecoration(
                          labelText: 'Passport or ID number',
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed:
                            state.isSavingIdCard ? null : onSaveIdCard,
                        child: Text(
                          state.isSavingIdCard ? 'Saving…' : 'Save ID',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: state.isConfirming || needsIdCard ? null : onConfirm,
              child: Text(
                state.isConfirming ? 'Processing…' : 'I have paid',
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
        if (state.isConfirming)
          const ColoredBox(
            color: Color(0x44000000),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _PaymentField extends StatelessWidget {
  const _PaymentField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _CopyableField extends StatelessWidget {
  const _CopyableField({
    required this.label,
    required this.value,
    required this.field,
    required this.copiedField,
    required this.onCopy,
    this.mono = false,
  });

  final String label;
  final String value;
  final String field;
  final String? copiedField;
  final void Function(String text, String field) onCopy;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: mono ? 'monospace' : null,
                        fontWeight: mono ? FontWeight.bold : null,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => onCopy(value, field),
            icon: Icon(
              copiedField == field ? Icons.check : Icons.copy,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFoundBody extends StatelessWidget {
  const _NotFoundBody({
    required this.queued,
    required this.onRetry,
    required this.onBack,
  });

  final bool queued;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(
              queued
                  ? 'Ticket is still processing or no longer available.'
                  : 'Ticket not found.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            if (queued)
              FilledButton(onPressed: onRetry, child: const Text('Retry')),
            TextButton(onPressed: onBack, child: const Text('Back')),
          ],
        ),
      ),
    );
  }
}

class _DeniedBody extends StatelessWidget {
  const _DeniedBody({this.denialReason, required this.onBack});

  final String? denialReason;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel, size: 48, color: Colors.red.shade700),
            const SizedBox(height: 16),
            Text(
              'Your ticket was denied.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (denialReason?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(denialReason!, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: onBack, child: const Text('Back')),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
