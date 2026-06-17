import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/core/utils/ticket_price.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_my_ticket_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_ticket_tiers_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/upgrade_ticket_usecase.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/ticket_tier_card.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:go_router/go_router.dart';

/// Màn 28 — upgrade ticket to a higher tier.
class TicketUpgradePage extends StatefulWidget {
  const TicketUpgradePage({super.key});

  @override
  State<TicketUpgradePage> createState() => _TicketUpgradePageState();
}

class _TicketUpgradePageState extends State<TicketUpgradePage> {
  bool _loading = true;
  bool _upgrading = false;
  String? _error;
  UserTicket? _ticket;
  List<TicketTier> _tiers = const [];
  List<TicketTier> _upgradeOptions = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final ticketResult = await sl<GetMyTicketUseCase>()();
    final tiersResult = await sl<GetTicketTiersUseCase>()();

    if (!mounted) return;

    if (ticketResult case Error(:final failure)) {
      setState(() {
        _loading = false;
        _error = failure.message;
      });
      return;
    }

    if (tiersResult case Error(:final failure)) {
      setState(() {
        _loading = false;
        _error = failure.message;
      });
      return;
    }

    final ticket = (ticketResult as Success<UserTicket?>).data;
    final tiers = (tiersResult as Success<List<TicketTier>>).data;

    if (ticket == null) {
      setState(() {
        _loading = false;
        _error = 'Bạn chưa có vé để nâng cấp.';
      });
      return;
    }

    final status = ticket.status;
    if (status != TicketStatus.approved &&
        status != TicketStatus.adminGranted) {
      setState(() {
        _loading = false;
        _ticket = ticket;
        _tiers = tiers;
        _upgradeOptions = const [];
      });
      return;
    }

    final currentPrice = ticket.tier?.price ?? 0;
    final options = tiers
        .where(
          (tier) =>
              tier.isActive &&
              !tier.isSoldOut &&
              tier.price > currentPrice &&
              tier.id != ticket.tier?.id,
        )
        .toList()
      ..sort((a, b) => a.price.compareTo(b.price));

    setState(() {
      _loading = false;
      _ticket = ticket;
      _tiers = tiers;
      _upgradeOptions = options;
    });
  }

  Future<void> _upgrade(TicketTier tier) async {
    if (_upgrading) return;

    setState(() => _upgrading = true);

    final result = await sl<UpgradeTicketUseCase>()(tier.id);
    if (!mounted) return;

    setState(() => _upgrading = false);

    switch (result) {
      case Success(:final data):
        final tierId = data.tier?.id ?? tier.id;
        final confirmed = await context.push<bool>(
          Routes.ticketPurchaseStep(tierId),
        );
        if (!mounted) return;
        if (confirmed == true) {
          context.go(Routes.accountTicket);
        } else {
          await _load();
        }
      case Error(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Nâng cấp vé',
      padding: EdgeInsets.zero,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _UpgradeError(message: _error!, onRetry: _load);
    }

    final ticket = _ticket!;
    final ext = context.fuvekonTheme;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);

    if (_upgradeOptions.isEmpty) {
      final subtitle = ticket.status != TicketStatus.approved &&
              ticket.status != TicketStatus.adminGranted
          ? 'Chỉ vé đã được duyệt mới có thể nâng cấp.'
          : 'Không có hạng vé cao hơn để nâng cấp.';

      return Padding(
        padding: const EdgeInsets.all(FuvekonSpacing.page),
        child: Column(
          children: [
            FuveMintCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vé hiện tại',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: ext.contentOnCard,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ticket.tier?.ticketName ?? '—',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: ext.contentOnCard,
                    ),
                  ),
                  if (ticket.tier != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      formatTierPrice(ticket.tier!, locale: locale),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: ext.contentOnCardMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: FuvekonSpacing.stackGapLg),
            EmptyState(
              title: 'Không thể nâng cấp',
              subtitle: subtitle,
              icon: Icons.upgrade_outlined,
            ),
            const SizedBox(height: FuvekonSpacing.stackGapLg),
            FuvePillButton(
              label: 'Quay lại vé của tôi',
              variant: FuvePillButtonVariant.outline,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.all(FuvekonSpacing.page),
            children: [
              FuveMintCard(
                showGoldAccent: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vé hiện tại',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: ext.contentOnCard,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ticket.tier?.ticketName ?? '—',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: ext.contentOnCard,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (ticket.tier != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        formatTierPrice(ticket.tier!, locale: locale),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ext.contentOnCardMuted,
                        ),
                      ),
                    ],
                    const SizedBox(height: FuvekonSpacing.stackGapMd),
                    Text(
                      'Chọn hạng vé cao hơn. Bạn sẽ thanh toán phần chênh lệch '
                      'và chờ xác minh như khi mua vé mới.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ext.contentOnCardMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: FuvekonSpacing.stackGapLg),
              Text(
                'Hạng nâng cấp',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: FuvekonColors.premiumPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: FuvekonSpacing.stackGapMd),
              ..._upgradeOptions.map((tier) {
                final rank = tierPriceRank(tier, _tiers);
                return Padding(
                  padding: const EdgeInsets.only(bottom: FuvekonSpacing.stackGapMd),
                  child: TicketTierCard(
                    tier: tier,
                    rank: rank,
                    soldOut: tier.isSoldOut,
                    closed: !tier.isActive,
                    disabled: _upgrading,
                    isPurchasing: _upgrading,
                    actionLabel: 'Nâng cấp',
                    onPurchase: _upgrading ? null : () => _upgrade(tier),
                  ),
                );
              }),
            ],
          ),
        ),
        if (_upgrading)
          const ColoredBox(
            color: Color(0x44000000),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _UpgradeError extends StatelessWidget {
  const _UpgradeError({required this.message, required this.onRetry});

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
