import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/tickets_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/tickets_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/tickets_state.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/ticket_tier_card.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TicketsBloc>()..add(const TicketsEvent.started()),
      child: const _TicketsView(),
    );
  }
}

class _TicketsView extends StatelessWidget {
  const _TicketsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buy tickets')),
      body: BlocConsumer<TicketsBloc, TicketsState>(
        listener: (context, state) async {
          final bloc = context.read<TicketsBloc>();

          final purchaseError = bloc.lastPurchaseError;
          if (purchaseError != null) {
            bloc.lastPurchaseError = null;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(purchaseError)),
            );
            return;
          }

          final purchase = bloc.lastPurchaseResult;
          if (purchase == null) return;
          bloc.lastPurchaseResult = null;

          final tierId = purchase.ticket?.tier?.id;
          if (tierId == null && !purchase.queued) return;

          final confirmed = await context.push<bool>(
            Routes.ticketPurchaseStep(tierId ?? ''),
            extra: purchase.queued,
          );
          if (!context.mounted) return;
          context.read<TicketsBloc>().add(const TicketsEvent.refreshRequested());
          if (confirmed == true) {
            context.go(Routes.accountTicket);
          }
        },
        builder: (context, state) {
          return switch (state) {
            TicketsInitial() || TicketsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            TicketsLoaded() => _TicketsLoadedBody(state: state),
            TicketsFailure(:final message) => _TicketsError(
                message: message,
                onRetry: () => context.read<TicketsBloc>().add(
                      const TicketsEvent.refreshRequested(),
                    ),
              ),
          };
        },
      ),
    );
  }
}

class _TicketsLoadedBody extends StatelessWidget {
  const _TicketsLoadedBody({required this.state});

  final TicketsLoaded state;

  bool get _hasActiveTicket {
    final ticket = state.myTicket;
    return ticket != null && ticket.status.isActive;
  }

  bool get _purchaseBlocked {
    final account = state.account;
    final isBlacklisted = account?.isBlacklisted == true;
    final isAdmin = account?.role?.toLowerCase() == 'admin';
    return !isAdmin && (isBlacklisted || _hasActiveTicket);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            context.read<TicketsBloc>().add(const TicketsEvent.refreshRequested());
            await context.read<TicketsBloc>().stream.firstWhere(
                  (s) => s is TicketsLoaded || s is TicketsFailure,
                );
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Buy tickets',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Select a ticket type',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_hasActiveTicket) ...[
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.go(Routes.accountTicket),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.confirmation_number,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'You already have a ticket',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'View your ticket',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (state.account?.isBlacklisted == true &&
                  state.account?.role?.toLowerCase() != 'admin')
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    color: Colors.red.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Your account is restricted from purchasing.'),
                    ),
                  ),
                ),
              if (_hasActiveTicket && _purchaseBlocked)
                const SizedBox.shrink()
              else if (state.tiers.isEmpty)
                const EmptyState(
                  title: 'No ticket types available',
                  subtitle: 'Check back later for ticket sales.',
                  icon: Icons.confirmation_number_outlined,
                )
              else
                ...state.tiers.map((tier) {
                  final rank = tierPriceRank(tier, state.tiers);
                  final soldOut = tier.isSoldOut;
                  final closed = !tier.isActive;
                  final unavailable = soldOut || closed;
                  final disabled = _purchaseBlocked || unavailable;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TicketTierCard(
                      tier: tier,
                      rank: rank,
                      soldOut: soldOut,
                      closed: closed,
                      disabled: disabled,
                      isPurchasing: state.isPurchasing,
                      onPurchase: disabled
                          ? null
                          : () => context.read<TicketsBloc>().add(
                                TicketsEvent.purchaseRequested(tier.id),
                              ),
                    ),
                  );
                }),
              if (!_purchaseBlocked || !_hasActiveTicket) ...[
                const SizedBox(height: 8),
                const _PurchaseNotices(),
              ],
            ],
          ),
        ),
        if (state.isPurchasing)
          const ColoredBox(
            color: Color(0x44000000),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _PurchaseNotices extends StatelessWidget {
  const _PurchaseNotices();

  static const _notices = [
    'Each account can only purchase 1 ticket.',
    'After selecting a ticket, you will be redirected to the payment page.',
    'Please transfer the exact amount and reference code as instructed.',
    'After transferring, tap "I have paid" for staff verification.',
    'Verification time: 3–5 business days.',
    'No refunds after successful purchase.',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Purchase notes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...List.generate(_notices.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${i + 1}. ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Expanded(child: Text(_notices[i])),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TicketsError extends StatelessWidget {
  const _TicketsError({required this.message, required this.onRetry});

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
