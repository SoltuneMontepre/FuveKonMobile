import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/utils/country_helpers.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_dashboard_service.dart';
import 'package:intl/intl.dart';

/// Horizontal bar breakdown of users grouped by country.
class UsersByCountryChart extends StatelessWidget {
  const UsersByCountryChart({
    super.key,
    required this.items,
    this.title,
    this.maxVisible,
  });

  final List<CountryUserCount> items;
  final String? title;
  final int? maxVisible;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final theme = Theme.of(context);
    final countFormat = NumberFormat.decimalPattern('vi');
    final sorted = List<CountryUserCount>.from(items)
      ..sort((a, b) => b.count.compareTo(a.count));
    final visible = maxVisible == null
        ? sorted
        : sorted.take(maxVisible!).toList(growable: false);
    final total = sorted.fold<int>(0, (sum, item) => sum + item.count);
    final maxCount = visible.first.count;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? l10n.adminDashboardUsersByCountry,
              style: theme.textTheme.titleSmall?.copyWith(
                color: FuvekonColors.darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            for (var index = 0; index < visible.length; index++) ...[
              if (index > 0) const SizedBox(height: 12),
              _CountryRow(
                label: _countryLabel(
                  context,
                  visible[index].country,
                  l10n.adminDashboardUnknownCountry,
                ),
                count: visible[index].count,
                maxCount: maxCount,
                total: total,
                countFormat: countFormat,
              ),
            ],
            if (maxVisible != null && sorted.length > maxVisible!) ...[
              const SizedBox(height: 12),
              Text(
                l10n.adminDashboardUsersByCountryMore(
                  sorted.length - maxVisible!,
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _countryLabel(
    BuildContext context,
    String country,
    String unknownLabel,
  ) {
    if (country.trim().isEmpty) return unknownLabel;
    final label = countryDisplayLabel(country, context: context);
    return label.isEmpty ? unknownLabel : label;
  }
}

class _CountryRow extends StatelessWidget {
  const _CountryRow({
    required this.label,
    required this.count,
    required this.maxCount,
    required this.total,
    required this.countFormat,
  });

  final String label;
  final int count;
  final int maxCount;
  final int total;
  final NumberFormat countFormat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = maxCount > 0 ? count / maxCount : 0.0;
    final percent = total > 0 ? (count / total) * 100 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: FuvekonColors.darkText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              countFormat.format(count),
              style: theme.textTheme.labelMedium?.copyWith(
                color: FuvekonColors.darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${percent.toStringAsFixed(1)}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: FuvekonColors.darkTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: const Color(0xFF2E3A34),
            color: FuvekonColors.available,
          ),
        ),
      ],
    );
  }
}
