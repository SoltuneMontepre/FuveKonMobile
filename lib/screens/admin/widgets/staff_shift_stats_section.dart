import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/services/scan_session_store.dart';
import 'package:intl/intl.dart';

class StaffShiftStatsSection extends StatelessWidget {
  const StaffShiftStatsSection({
    super.key,
    required this.stats,
  });

  final ScanShiftStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final updatedLabel = stats.lastUpdated == null
        ? 'Chưa có dữ liệu'
        : 'Cập nhật lúc ${DateFormat('HH:mm').format(stats.lastUpdated!)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Thống kê ca trực',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: FuvekonColors.darkText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              updatedLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: FuvekonColors.darkTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _TotalCard(total: stats.total),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _StatTile(
                label: 'Hợp lệ',
                value: stats.valid,
                icon: Icons.check_circle_outline,
                valueColor: FuvekonColors.available,
                tall: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _StatTile(
                    label: 'Từ chối',
                    value: stats.rejected,
                    icon: Icons.cancel_outlined,
                    valueColor: const Color(0xFFF0A0A8),
                  ),
                  const SizedBox(height: 12),
                  _StatTile(
                    label: 'Dùng lại',
                    value: stats.reused,
                    icon: Icons.history_rounded,
                    valueColor: const Color(0xFFFBBF24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = NumberFormat.decimalPattern('vi').format(total);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.confirmation_number_outlined,
                  color: FuvekonColors.darkTextSecondary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Vé đã quét hôm nay',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: FuvekonColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              formatted,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: FuvekonColors.darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.valueColor,
    this.tall = false,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color valueColor;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = NumberFormat.decimalPattern('vi').format(value);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: tall
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(icon: icon, label: label, theme: theme),
                  const SizedBox(height: 20),
                  Text(
                    formatted,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: valueColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _Header(icon: icon, label: label, theme: theme)),
                  Text(
                    formatted,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: valueColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.icon,
    required this.label,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: FuvekonColors.darkTextSecondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: FuvekonColors.darkTextSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
