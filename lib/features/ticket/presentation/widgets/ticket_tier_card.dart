import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/core/utils/ticket_price.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';

class TierCardColors {
  const TierCardColors({
    required this.banner,
    required this.title,
    required this.price,
    required this.check,
    required this.button,
    required this.buttonText,
  });

  final Color banner;
  final Color title;
  final Color price;
  final Color check;
  final Color button;
  final Color buttonText;
}

const _tierPalettes = [
  TierCardColors(
    banner: FuvekonColors.tier1,
    title: Colors.white,
    price: Colors.white,
    check: Color(0xFF8B6E3A),
    button: FuvekonColors.tier1,
    buttonText: Color(0xFFC8E0E4),
  ),
  TierCardColors(
    banner: FuvekonColors.tier2,
    title: Colors.white,
    price: Colors.white,
    check: Color(0xFF2C7A60),
    button: Color(0xFF797673),
    buttonText: Colors.white,
  ),
  TierCardColors(
    banner: FuvekonColors.tier3,
    title: Colors.white,
    price: Colors.white,
    check: Color(0xFFC9A030),
    button: Color(0xFF9E7E3F),
    buttonText: Colors.white,
  ),
  TierCardColors(
    banner: FuvekonColors.tier4,
    title: Color(0xFFF5D060),
    price: Color(0xFFF5D060),
    check: Color(0xFFC9A030),
    button: Color(0xFF7A3D99),
    buttonText: Color(0xFFF5E6FF),
  ),
];

class TicketTierCard extends StatelessWidget {
  const TicketTierCard({
    super.key,
    required this.tier,
    required this.rank,
    required this.onPurchase,
    required this.disabled,
    required this.isPurchasing,
    this.soldOut = false,
    this.closed = false,
    this.actionLabel,
    this.showAction = true,
  });

  final TicketTier tier;
  final int rank;
  final VoidCallback? onPurchase;
  final bool disabled;
  final bool isPurchasing;
  final bool soldOut;
  final bool closed;
  final String? actionLabel;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final ext = context.fuvekonTheme;
    final theme = Theme.of(context);
    final colors = _tierPalettes[rank.clamp(0, _tierPalettes.length - 1)];
    final isTop = rank == _tierPalettes.length - 1;

    String buttonLabel;
    if (isPurchasing) {
      buttonLabel = 'Đang xử lý…';
    } else if (soldOut) {
      buttonLabel = 'Hết vé';
    } else if (closed) {
      buttonLabel = 'Đã đóng';
    } else if (disabled) {
      buttonLabel = 'Không khả dụng';
    } else {
      buttonLabel = actionLabel ?? 'Mua ngay';
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(FuvekonRadii.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(FuvekonRadii.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: colors.banner,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                children: [
                  if (isTop)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC9A030), Color(0xFFF0C840)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'FINEST',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF673095),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  Text(
                    tier.ticketName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colors.title,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatTierPrice(tier, locale: locale),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.price,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ColoredBox(
              color: ext.contentCard,
              child: Padding(
                padding: const EdgeInsets.all(FuvekonSpacing.card),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (tier.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          tier.description,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: ext.contentOnCardMuted,
                          ),
                        ),
                      ),
                    ...tier.benefits.map(
                      (benefit) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check, size: 16, color: colors.check),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                benefit,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: ext.contentOnCard,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (soldOut)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Hết vé',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (showAction) ...[
                      const SizedBox(height: FuvekonSpacing.stackGapMd),
                      FuvePillButton(
                        label: buttonLabel,
                        onPressed:
                            disabled || isPurchasing ? null : onPurchase,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int tierPriceRank(TicketTier tier, List<TicketTier> allTiers) {
  final sorted = [...allTiers]..sort((a, b) => a.price.compareTo(b.price));
  return sorted.indexWhere((t) => t.id == tier.id).clamp(0, sorted.length - 1);
}
