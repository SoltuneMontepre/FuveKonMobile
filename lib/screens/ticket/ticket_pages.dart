import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_ticket_tiers_usecase.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/ticket_tier_card.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:go_router/go_router.dart';

/// Màn 21 — public ticket info with tier overview.
class TicketInfoPage extends StatefulWidget {
  const TicketInfoPage({super.key});

  @override
  State<TicketInfoPage> createState() => _TicketInfoPageState();
}

class _TicketInfoPageState extends State<TicketInfoPage> {
  bool _loading = true;
  String? _error;
  List<TicketTier> _tiers = const [];

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

    final result = await sl<GetTicketTiersUseCase>()();
    if (!mounted) return;

    switch (result) {
      case Success(:final data):
        setState(() {
          _loading = false;
          _tiers = data;
        });
      case Error(:final failure):
        setState(() {
          _loading = false;
          _error = failure.message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppPageScaffold(
      title: 'Thông tin vé',
      padding: EdgeInsets.zero,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _TicketInfoError(message: _error!, onRetry: _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(FuvekonSpacing.page),
                    children: [
                      Text(
                        'Các hạng vé',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: FuvekonColors.premiumPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Xem quyền lợi từng hạng vé trước khi mua',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: FuvekonSpacing.stackGapLg),
                      if (_tiers.isEmpty)
                        const EmptyState(
                          title: 'Chưa có loại vé',
                          subtitle: 'Vui lòng quay lại sau.',
                          icon: Icons.confirmation_number_outlined,
                        )
                      else
                        ..._tiers.map((tier) {
                          final rank = tierPriceRank(tier, _tiers);
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: FuvekonSpacing.stackGapMd,
                            ),
                            child: TicketTierCard(
                              tier: tier,
                              rank: rank,
                              soldOut: tier.isSoldOut,
                              closed: !tier.isActive,
                              disabled: false,
                              isPurchasing: false,
                              showAction: false,
                              onPurchase: null,
                            ),
                          );
                        }),
                      const SizedBox(height: FuvekonSpacing.stackGapMd),
                      FuvePillButton(
                        label: 'Mua vé ngay',
                        icon: Icons.shopping_bag_outlined,
                        onPressed: () => context.go(Routes.ticketPurchase),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _TicketInfoError extends StatelessWidget {
  const _TicketInfoError({required this.message, required this.onRetry});

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
