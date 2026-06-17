import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_state.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/my_ticket_card.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/name_card_section.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:go_router/go_router.dart';

/// Màn 26–27 — my ticket with E-ticket QR on mint cards.
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

  bool _canUpgrade(MyTicketLoaded state) {
    final status = state.ticket.status;
    return status == TicketStatus.approved ||
        status == TicketStatus.adminGranted;
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Vé của tôi',
      showBackButton: false,
      padding: EdgeInsets.zero,
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
              const SnackBar(content: Text('Đã lưu name card')),
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
                  padding: const EdgeInsets.all(FuvekonSpacing.page),
                  children: [
                    MyTicketCard(
                      ticket: state.ticket,
                      onPay: state.ticket.needsPayment
                          ? () => _openPayment(context, state.ticket.tier?.id)
                          : null,
                      onUpgrade: _canUpgrade(state)
                          ? () => context.push(Routes.accountTicketUpgrade)
                          : null,
                    ),
                    if (state.canViewNameCard) ...[
                      const SizedBox(height: FuvekonSpacing.stackGapMd),
                      NameCardSection(state: state),
                    ],
                  ],
                ),
              ),
            MyTicketEmpty() => Center(
                child: Padding(
                  padding: const EdgeInsets.all(FuvekonSpacing.page),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const EmptyState(
                        title: 'Bạn chưa có vé',
                        subtitle: 'Mua vé để tham dự sự kiện.',
                        icon: Icons.confirmation_number_outlined,
                      ),
                      const SizedBox(height: FuvekonSpacing.stackGapLg),
                      FuvePillButton(
                        label: 'Xem loại vé',
                        icon: Icons.confirmation_number_outlined,
                        onPressed: () => context.go(Routes.ticketPurchase),
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
    final confirmed = await context.push<bool>(Routes.ticketPurchaseStep(tierId));
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
        padding: const EdgeInsets.all(FuvekonSpacing.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: FuvekonSpacing.field),
            FuvePillButton(
              label: 'Thử lại',
              expanded: false,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
