import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_dashboard_service.dart';
import 'package:intl/intl.dart';

enum DashboardChartPeriod {
  days7(7),
  days30(30),
  days90(90);

  const DashboardChartPeriod(this.days);

  final int days;

  String label(AppLocalizations l10n) => switch (this) {
    DashboardChartPeriod.days7 => l10n.adminChartPeriod7Days,
    DashboardChartPeriod.days30 => l10n.adminChartPeriod30Days,
    DashboardChartPeriod.days90 => l10n.adminChartPeriod90Days,
  };
}

/// Bar chart for ticket sales over a selectable date range.
class SalesTimelineChart extends StatefulWidget {
  const SalesTimelineChart({
    super.key,
    required this.points,
    this.initialPeriod = DashboardChartPeriod.days7,
    this.title,
    this.barCount = 7,
  });

  final List<SalesTimelinePoint> points;
  final DashboardChartPeriod initialPeriod;
  final String? title;
  final int barCount;

  @override
  State<SalesTimelineChart> createState() => _SalesTimelineChartState();
}

class _SalesTimelineChartState extends State<SalesTimelineChart> {
  late DashboardChartPeriod _period = widget.initialPeriod;

  @override
  Widget build(BuildContext context) {
    final data = _chartData(widget.points, _period, barCount: widget.barCount);
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final chartTitle = widget.title ?? context.l10n.adminSalesTimelineDefault;
    final maxCount = data.map((point) => point.count).reduce(math.max);
    final peakIndex = _peakIndex(data, maxCount);

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
              chartTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                color: FuvekonColors.darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final period in DashboardChartPeriod.values)
                  _PeriodChip(
                    label: period.label(context.l10n),
                    selected: period == _period,
                    onTap: () {
                      if (period == _period) return;
                      setState(() => _period = period);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 132,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var index = 0; index < data.length; index++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _BarColumn(
                          key: ValueKey('${_period.name}-$index'),
                          count: data[index].count,
                          maxCount: maxCount,
                          isPeak: index == peakIndex,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (var index = 0; index < data.length; index++)
                  Expanded(
                    child: _AxisLabel(
                      label: _shouldShowLabel(index, data.length)
                          ? _formatAxisDate(data[index].date)
                          : null,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static List<SalesTimelinePoint> _chartData(
    List<SalesTimelinePoint> points,
    DashboardChartPeriod period, {
    required int barCount,
  }) {
    final periodDays = period.days;
    final today = DateTime.now().toLocal();
    final todayDay = DateTime(today.year, today.month, today.day);
    final startDay = todayDay.subtract(Duration(days: periodDays - 1));

    final countsByDay = <DateTime, int>{};
    for (final point in points) {
      final parsed = DateTime.tryParse(point.date)?.toLocal();
      if (parsed == null) continue;
      final day = DateTime(parsed.year, parsed.month, parsed.day);
      if (day.isBefore(startDay) || day.isAfter(todayDay)) continue;
      countsByDay[day] = (countsByDay[day] ?? 0) + point.count;
    }

    if (periodDays <= barCount) {
      return List.generate(periodDays, (index) {
        final day = startDay.add(Duration(days: index));
        return SalesTimelinePoint(
          date: _dayKey(day),
          count: countsByDay[day] ?? 0,
        );
      });
    }

    final daysPerBar = periodDays / barCount;
    return List.generate(barCount, (index) {
      final offsetStart = (index * daysPerBar).floor();
      final offsetEnd = index == barCount - 1
          ? periodDays - 1
          : ((index + 1) * daysPerBar).floor() - 1;

      var sum = 0;
      for (var offset = offsetStart; offset <= offsetEnd; offset++) {
        final day = startDay.add(Duration(days: offset));
        sum += countsByDay[day] ?? 0;
      }

      return SalesTimelinePoint(
        date: _dayKey(startDay.add(Duration(days: offsetStart))),
        count: sum,
      );
    });
  }

  static String _dayKey(DateTime day) {
    return DateFormat('yyyy-MM-dd').format(day);
  }

  static int _peakIndex(List<SalesTimelinePoint> data, int maxCount) {
    if (maxCount <= 0) return -1;
    for (var index = data.length - 1; index >= 0; index--) {
      if (data[index].count == maxCount) {
        return index;
      }
    }
    return -1;
  }

  static bool _shouldShowLabel(int index, int length) {
    if (length <= 4) return true;
    return index.isEven || index == length - 1;
  }

  static String _formatAxisDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return raw.length > 5 ? raw.substring(5) : raw;
    }
    return DateFormat('dd/MM').format(parsed.toLocal());
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FuvekonRadii.input),
        child: Ink(
          decoration: BoxDecoration(
            color: selected
                ? FuvekonColors.available.withValues(alpha: 0.18)
                : FuvekonColors.darkSurface,
            borderRadius: BorderRadius.circular(FuvekonRadii.input),
            border: Border.all(
              color: selected
                  ? FuvekonColors.available
                  : FuvekonColors.darkBorder,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: selected
                    ? FuvekonColors.available
                    : FuvekonColors.darkTextSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  const _BarColumn({
    super.key,
    required this.count,
    required this.maxCount,
    required this.isPeak,
  });

  final int count;
  final int maxCount;
  final bool isPeak;

  @override
  Widget build(BuildContext context) {
    final ratio = maxCount > 0 ? count / maxCount : 0.0;
    final barHeight = count == 0 ? 0.0 : math.max(6.0, 104 * ratio);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          height: barHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _barColor(count, maxCount, isPeak),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ),
      ],
    );
  }

  Color _barColor(int count, int maxCount, bool isPeak) {
    if (isPeak && maxCount > 0) {
      return FuvekonColors.available;
    }
    if (count == 0) {
      return const Color(0xFF2E3A34);
    }
    final ratio = maxCount > 0 ? count / maxCount : 0.0;
    return Color.lerp(const Color(0xFF3A5240), const Color(0xFF5C7A62), ratio)!;
  }
}

class _AxisLabel extends StatelessWidget {
  const _AxisLabel({required this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      label ?? '',
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.labelSmall?.copyWith(
        color: FuvekonColors.darkTextSecondary,
        fontSize: 11,
      ),
    );
  }
}
