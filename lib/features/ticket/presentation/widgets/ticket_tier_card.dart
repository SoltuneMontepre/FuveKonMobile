import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/utils/ticket_price.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';

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
    check: FuvekonColors.lightGold,
    button: FuvekonColors.tier1,
    buttonText: Color(0xFFE5FFED),
  ),
  TierCardColors(
    banner: FuvekonColors.tier2,
    title: Colors.white,
    price: Colors.white,
    check: FuvekonColors.sageGreen,
    button: FuvekonColors.dustyRoseContainer,
    buttonText: Color(0xFFFCDAE5),
  ),
  TierCardColors(
    banner: FuvekonColors.tier3,
    title: Colors.white,
    price: Colors.white,
    check: FuvekonColors.lightGold,
    button: FuvekonColors.goldContainer,
    buttonText: FuvekonColors.onLightGold,
  ),
  TierCardColors(
    banner: FuvekonColors.tier4,
    title: Color(0xFFFFE088),
    price: Color(0xFFFFE088),
    check: FuvekonColors.lightGold,
    button: FuvekonColors.surfaceContainerHighest,
    buttonText: FuvekonColors.onSurface,
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
  });

  final TicketTier tier;
  final int rank;
  final VoidCallback? onPurchase;
  final bool disabled;
  final bool isPurchasing;
  final bool soldOut;
  final bool closed;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final colors = _tierPalettes[rank.clamp(0, _tierPalettes.length - 1)];
    final isTop = rank == _tierPalettes.length - 1;

    String buttonLabel;
    if (isPurchasing) {
      buttonLabel = 'Processing…';
    } else if (soldOut) {
      buttonLabel = 'Sold out';
    } else if (closed) {
      buttonLabel = 'Closed';
    } else if (disabled) {
      buttonLabel = 'Unavailable';
    } else {
      buttonLabel = isTop ? 'Buy now' : 'Buy now';
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          FuvekonColors.lightGold,
                          Color(0xFFFFE088),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'FINEST',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: FuvekonColors.surfaceContainerHighest,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
                Text(
                  tier.ticketName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colors.title,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatTierPrice(tier, locale: locale),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.price,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (tier.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      tier.description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
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
                        Expanded(child: Text(benefit)),
                      ],
                    ),
                  ),
                ),
                if (soldOut)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Sold out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: disabled || isPurchasing ? null : onPurchase,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.button,
                    foregroundColor: colors.buttonText,
                  ),
                  child: Text(buttonLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

int tierPriceRank(TicketTier tier, List<TicketTier> allTiers) {
  final sorted = [...allTiers]..sort((a, b) => a.price.compareTo(b.price));
  return sorted.indexWhere((t) => t.id == tier.id).clamp(0, sorted.length - 1);
}
