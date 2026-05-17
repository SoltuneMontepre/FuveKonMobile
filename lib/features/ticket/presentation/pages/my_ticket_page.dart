import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_state.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/my_ticket_card.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/name_card_section.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';

class MyTicketPage extends StatelessWidget {
  const MyTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MyTicketBloc>()..add(const MyTicketEvent.started()),
      child: const _MyTicketView(),
    );
  }
}

class _MyTicketView extends StatelessWidget {
  const _MyTicketView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My ticket')),
      body: BlocConsumer<MyTicketBloc, MyTicketState>(
        listener: (context, state) {
          final bloc = context.read<MyTicketBloc>();
          if (bloc.lastActionError != null) {
            final message = bloc.lastActionError!;
            bloc.lastActionError = null;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            return;
          }
          if (bloc.saveSucceeded) {
            bloc.saveSucceeded = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Name card saved')),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            MyTicketInitial() || MyTicketLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            MyTicketLoaded() => RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<MyTicketBloc>()
                      .add(const MyTicketEvent.refreshRequested());
                  await context.read<MyTicketBloc>().stream.firstWhere(
                        (s) =>
                            s is MyTicketLoaded ||
                            s is MyTicketEmpty ||
                            s is MyTicketFailure,
                      );
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    MyTicketCard(
                      ticket: state.ticket,
                      onPay: state.ticket.needsPayment
                          ? () => _openPayment(context, state.ticket.tier?.id)
                          : null,
                    ),
                    if (state.canViewNameCard) ...[
                      const SizedBox(height: 16),
                      NameCardSection(state: state),
                    ],
                  ],
                ),
              ),
            MyTicketEmpty() => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const EmptyState(
                        title: "You don't have a ticket",
                        subtitle: 'Buy a ticket to attend the convention.',
                        icon: Icons.confirmation_number_outlined,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => context.go(Routes.tickets),
                        child: const Text('Browse tickets'),
                      ),
                    ],
                  ),
                ),
              ),
            MyTicketFailure(:final message) => _MyTicketError(
                message: message,
                onRetry: () => context.read<MyTicketBloc>().add(
                      const MyTicketEvent.refreshRequested(),
                    ),
              ),
          };
        },
      ),
    );
  }

  Future<void> _openPayment(BuildContext context, String? tierId) async {
    if (tierId == null) return;
    final confirmed = await context.push<bool>(Routes.ticketPurchase(tierId));
    if (confirmed == true && context.mounted) {
      context.read<MyTicketBloc>().add(const MyTicketEvent.refreshRequested());
    }
  }
}

class _MyTicketError extends StatelessWidget {
  const _MyTicketError({required this.message, required this.onRetry});

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
