import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:intl/intl.dart';

enum AdminTierFilter { all, selling, paused, soldOut }

extension AdminTierFilterX on AdminTierFilter {
  String label(AppLocalizations l10n) => switch (this) {
        AdminTierFilter.all => l10n.adminTierFilterAll,
        AdminTierFilter.selling => l10n.adminTierFilterSelling,
        AdminTierFilter.paused => l10n.adminTierFilterPaused,
        AdminTierFilter.soldOut => l10n.adminTierFilterSoldOut,
      };

  bool matches(AdminTicketTierItem tier) => switch (this) {
        AdminTierFilter.all => true,
        AdminTierFilter.selling => tier.isActive && !tier.isSoldOut,
        AdminTierFilter.paused => !tier.isActive && !tier.isSoldOut,
        AdminTierFilter.soldOut => tier.isSoldOut,
      };
}

class AdminTierStockStat {
  const AdminTierStockStat({
    required this.tierId,
    required this.sold,
    required this.totalStock,
    required this.available,
  });

  factory AdminTierStockStat.fromJson(Map<String, dynamic> json) {
    return AdminTierStockStat(
      tierId: json['tier_id']?.toString() ?? '',
      sold: (json['sold'] as num?)?.toInt() ?? 0,
      totalStock: (json['total_stock'] as num?)?.toInt() ?? 0,
      available: (json['available'] as num?)?.toInt() ?? 0,
    );
  }

  final String tierId;
  final int sold;
  final int totalStock;
  final int available;

  double get soldPercent =>
      totalStock > 0 ? (sold / totalStock).clamp(0.0, 1.0) : 0;
}

class AdminTicketOverviewStats {
  const AdminTicketOverviewStats({
    required this.totalCapacity,
    required this.sold,
    required this.remaining,
    required this.approvedCount,
    required this.tierStats,
  });

  factory AdminTicketOverviewStats.fromJson(Map<String, dynamic> json) {
    final tierList = json['tier_stats'] as List<dynamic>? ?? const [];
    final tierStats = tierList
        .whereType<Map<String, dynamic>>()
        .map(AdminTierStockStat.fromJson)
        .toList();

    var sold = 0;
    var remaining = 0;
    for (final stat in tierStats) {
      sold += stat.sold;
      remaining += stat.available;
    }

    return AdminTicketOverviewStats(
      totalCapacity: sold + remaining,
      sold: sold,
      remaining: remaining,
      approvedCount: (json['approved_count'] as num?)?.toInt() ?? 0,
      tierStats: tierStats,
    );
  }

  static const empty = AdminTicketOverviewStats(
    totalCapacity: 0,
    sold: 0,
    remaining: 0,
    approvedCount: 0,
    tierStats: [],
  );

  final int totalCapacity;
  final int sold;
  final int remaining;
  final int approvedCount;
  final List<AdminTierStockStat> tierStats;

  AdminTierStockStat? statFor(String tierId) {
    for (final stat in tierStats) {
      if (stat.tierId == tierId) return stat;
    }
    return null;
  }
}

class AdminTierStatGrid extends StatelessWidget {
  const AdminTierStatGrid({super.key, required this.stats});

  final AdminTicketOverviewStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final count = NumberFormat.decimalPattern('vi');

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: l10n.adminTierStatTotal,
                value: count.format(stats.totalCapacity),
                highlighted: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                label: l10n.adminTierStatSold,
                value: count.format(stats.sold),
                highlighted: true,
                trailing: Icon(
                  Icons.trending_up_rounded,
                  size: 18,
                  color: FuvekonColors.darkCardText.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: l10n.adminTierStatRemaining,
                value: count.format(stats.remaining),
                highlighted: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                label: l10n.adminTierStatApproved,
                value: count.format(stats.approvedCount),
                highlighted: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.highlighted,
    this.trailing,
  });

  final String label;
  final String value;
  final bool highlighted;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = highlighted ? FuvekonColors.darkCard : FuvekonColors.darkSurfaceElevated;
    final labelColor =
        highlighted ? FuvekonColors.textSecondary : FuvekonColors.darkTextSecondary;
    final valueColor = highlighted ? FuvekonColors.darkCardText : FuvekonColors.darkText;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: highlighted
            ? null
            : Border.all(color: FuvekonColors.darkBorder.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                trailing ?? const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminTierFilterChips extends StatelessWidget {
  const AdminTierFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final AdminTierFilter selected;
  final ValueChanged<AdminTierFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in AdminTierFilter.values) ...[
            if (filter != AdminTierFilter.all) const SizedBox(width: 8),
            _FilterChip(
              label: filter.label(l10n),
              selected: selected == filter,
              onTap: () => onSelected(filter),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? FuvekonColors.darkCard : Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? FuvekonColors.darkCard
                  : FuvekonColors.darkBorder,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected
                        ? FuvekonColors.darkCardText
                        : FuvekonColors.darkText,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _TierCardVariant { active, muted }

class AdminTierCard extends StatelessWidget {
  const AdminTierCard({
    super.key,
    required this.tier,
    required this.stockStat,
    required this.onTap,
    this.variantIndex = 0,
  });

  final AdminTicketTierItem tier;
  final AdminTierStockStat? stockStat;
  final VoidCallback onTap;
  final int variantIndex;

  _TierCardVariant get _variant {
    if (tier.isSoldOut || !tier.isActive) return _TierCardVariant.muted;
    return _TierCardVariant.active;
  }

  String _statusLabel(AppLocalizations l10n) {
    if (tier.isSoldOut) return l10n.adminTierBadgeSoldOut;
    if (!tier.isActive) return l10n.adminTierBadgePaused;
    return l10n.adminTierBadgeSelling;
  }

  Color get _accentColor {
    if (_variant == _TierCardVariant.muted) {
      return FuvekonColors.darkTextSecondary;
    }
    return switch (variantIndex % 3) {
      0 => FuvekonColors.darkCardText,
      1 => const Color(0xFF2D3C3F),
      _ => FuvekonColors.textPrimary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    final sold = stockStat?.sold ?? 0;
    final total = stockStat?.totalStock ?? tier.stock ?? 0;
    final percent = stockStat?.soldPercent ??
        (total > 0 ? (sold / total).clamp(0.0, 1.0) : 0.0);
    final pct = percent * 100;
    final percentLabel = pct == pct.roundToDouble()
        ? '${pct.toInt()}%'
        : '${pct.toStringAsFixed(1)}%';

    final isActiveCard = _variant == _TierCardVariant.active;
    final bg = isActiveCard ? FuvekonColors.darkCard : FuvekonColors.darkSurfaceElevated;
    final titleColor = isActiveCard ? _accentColor : FuvekonColors.darkText;
    final priceColor = isActiveCard ? _accentColor : FuvekonColors.darkText;
    final subtleColor = isActiveCard
        ? FuvekonColors.textSecondary
        : FuvekonColors.darkTextSecondary;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      tier.ticketName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(
                    label: _statusLabel(l10n),
                    muted: !isActiveCard,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                currency.format(tier.price),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: priceColor,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.adminTierSoldCount(sold, total),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: subtleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    percentLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: subtleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 8,
                  backgroundColor: isActiveCard
                      ? FuvekonColors.button.withValues(alpha: 0.45)
                      : FuvekonColors.darkBorder,
                  color: isActiveCard ? _accentColor : FuvekonColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _DetailsButton(
                filled: variantIndex % 3 == 0 && isActiveCard,
                muted: !isActiveCard,
                onPressed: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.muted});

  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: muted
            ? FuvekonColors.darkBorder.withValues(alpha: 0.5)
            : FuvekonColors.button.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: muted
                    ? FuvekonColors.darkTextSecondary
                    : FuvekonColors.darkCardText,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
        ),
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({
    required this.filled,
    required this.muted,
    required this.onPressed,
  });

  final bool filled;
  final bool muted;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = l10n.adminTierViewDetails;
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        );

    if (filled) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: FuvekonColors.darkCardText,
          foregroundColor: FuvekonColors.darkCard,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label, style: style?.copyWith(color: FuvekonColors.darkCard)),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor:
            muted ? FuvekonColors.darkTextSecondary : FuvekonColors.darkCardText,
        side: BorderSide(
          color: muted ? FuvekonColors.darkBorder : FuvekonColors.darkCardText,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(label, style: style),
    );
  }
}

/// Live preview for the tier create/edit form.
class AdminTierFormPreview extends StatelessWidget {
  const AdminTierFormPreview({
    super.key,
    required this.ticketName,
    required this.price,
    required this.description,
    required this.benefits,
    required this.stock,
    required this.isActive,
  });

  final String ticketName;
  final double price;
  final String description;
  final List<String> benefits;
  final int stock;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final visibleBenefits = benefits.where((b) => b.trim().isNotEmpty).toList();
    final showLowStock = isActive && stock > 0 && stock <= 15;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    ticketName.isNotEmpty ? ticketName : l10n.adminTierPreviewNamePlaceholder,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: FuvekonColors.darkCardText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (showLowStock) ...[
                  const SizedBox(width: 8),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        l10n.adminTierLowStock,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFFB45309),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              price > 0 ? currency.format(price) : '0 ₫',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: FuvekonColors.darkCardText,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (description.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                description.trim(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            if (visibleBenefits.isNotEmpty) ...[
              const SizedBox(height: 14),
              for (final benefit in visibleBenefits.take(4))
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: FuvekonColors.outline,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          benefit,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: FuvekonColors.darkCardText,
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
    );
  }
}

class AdminTierFormField extends StatelessWidget {
  const AdminTierFormField({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: FuvekonColors.darkTextSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class AdminTierSystemWarning extends StatelessWidget {
  const AdminTierSystemWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    const accent = Color(0xFFDC2626);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: accent, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.adminTierSystemWarningTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: FuvekonColors.darkText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.adminTierSystemWarningBody,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
