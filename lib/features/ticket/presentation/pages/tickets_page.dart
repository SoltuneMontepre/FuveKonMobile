import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/tickets_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/tickets_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/tickets_state.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/ticket_tier_card.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:go_router/go_router.dart';

/// Màn 22 — purchase ticket tiers on mint cards.
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
    return AppPageScaffold(
      title: 'Mua vé',
      padding: EdgeInsets.zero,
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
    final theme = Theme.of(context);

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
            padding: const EdgeInsets.all(FuvekonSpacing.page),
            children: [
              Text(
                'Chọn loại vé',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: FuvekonColors.premiumPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Mỗi tài khoản chỉ mua được một vé',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FuvekonSpacing.stackGapLg),
              if (_hasActiveTicket) ...[
                FuveMintCard(
                  onTap: () => context.go(Routes.accountTicket),
                  child: Row(
                    children: [
                      Icon(
                        Icons.confirmation_number,
                        color: FuvekonColors.premiumOnMintCardMuted,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bạn đã có vé',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: context.fuvekonTheme.contentOnCard,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Xem vé của tôi',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: context.fuvekonTheme.contentOnCardMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: context.fuvekonTheme.contentOnCardMuted,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: FuvekonSpacing.stackGapMd),
              ],
              if (state.account?.isBlacklisted == true &&
                  state.account?.role?.toLowerCase() != 'admin')
                Padding(
                  padding: const EdgeInsets.only(bottom: FuvekonSpacing.stackGapMd),
                  child: FuveMintCard(
                    child: Text(
                      'Tài khoản của bạn bị hạn chế mua vé.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ),
              if (_hasActiveTicket && _purchaseBlocked)
                const SizedBox.shrink()
              else if (state.tiers.isEmpty)
                const EmptyState(
                  title: 'Chưa có loại vé',
                  subtitle: 'Vui lòng quay lại sau.',
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
                    padding: const EdgeInsets.only(bottom: FuvekonSpacing.stackGapMd),
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
                const SizedBox(height: FuvekonSpacing.stackGapSm),
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
    'Mỗi tài khoản chỉ mua được 1 vé.',
    'Sau khi chọn vé, bạn sẽ được chuyển đến trang thanh toán.',
    'Vui lòng chuyển khoản đúng số tiền và mã tham chiếu.',
    'Sau khi chuyển khoản, nhấn "Tôi đã thanh toán" để xác minh.',
    'Thời gian xác minh: 3–5 ngày làm việc.',
    'Không hoàn tiền sau khi mua thành công.',
  ];

  @override
  Widget build(BuildContext context) {
    return AppInfoSection(
      title: 'Lưu ý khi mua vé',
      items: _notices,
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
