import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/utils/ticket_price.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';

enum ExploreTierStyle { standard, popular, premium }

ExploreTierStyle exploreTierStyleFor(int index, int total) {
  if (index == total - 1 && total > 1) return ExploreTierStyle.premium;
  if (index == 1 && total >= 2) return ExploreTierStyle.popular;
  return ExploreTierStyle.standard;
}

class ExploreTicketTierCard extends StatelessWidget {
  const ExploreTicketTierCard({
    super.key,
    required this.tier,
    required this.style,
    this.onTap,
  });

  final TicketTier tier;
  final ExploreTierStyle style;
  final VoidCallback? onTap;

  static const _gold = Color(0xFFC9A030);
  static const _goldLight = Color(0xFFF5D060);
  static const _popularBadge = Color(0xFF4A7C59);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context);
    final price = formatTierPrice(tier, locale: locale);
    final isPremium = style == ExploreTierStyle.premium;
    final isPopular = style == ExploreTierStyle.popular;

    final bgColor = isPremium
        ? const Color(0xFF1A1F1C)
        : FuvekonColors.darkCard;
    final titleColor = isPremium ? _goldLight : FuvekonColors.darkCardText;
    final priceColor = isPremium ? Colors.white : FuvekonColors.darkCardText;
    final benefitColor =
        isPremium ? FuvekonColors.darkTextSecondary : FuvekonColors.textSecondary;
    final checkColor = isPremium ? _gold : const Color(0xFF4A7C59);

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: tier.isSoldOut ? 0.72 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(FuvekonRadii.card),
            border: isPremium
                ? Border.all(color: _gold.withValues(alpha: 0.65), width: 1.5)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tier.ticketName,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          price,
                          style: TextStyle(
                            color: priceColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isPopular)
                    _PopularBadge(label: l10n.exploreTicketsPopularBadge)
                  else if (isPremium)
                    Icon(Icons.diamond_outlined, color: _gold, size: 22)
                  else if (tier.isSoldOut)
                    _SoldOutBadge(label: l10n.exploreTicketsSoldOut),
                ],
              ),
              if (tier.description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  tier.description,
                  style: TextStyle(
                    color: benefitColor,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
              if (tier.benefits.isNotEmpty) ...[
                const SizedBox(height: 14),
                for (final benefit in tier.benefits)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_rounded, size: 18, color: checkColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            benefit,
                            style: TextStyle(
                              color: benefitColor,
                              fontSize: 14,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PopularBadge extends StatelessWidget {
  const _PopularBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ExploreTicketTierCard._popularBadge,
        borderRadius: BorderRadius.circular(FuvekonRadii.button),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SoldOutBadge extends StatelessWidget {
  const _SoldOutBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(FuvekonRadii.button),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: FuvekonColors.textSecondary.withValues(alpha: 0.9),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
