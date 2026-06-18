import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_schedule_models.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventManagementSection extends StatelessWidget {
  const EventManagementSection({
    super.key,
    required this.schedules,
    this.loading = false,
    this.onViewAll,
    this.onCreate,
  });

  final List<AdminScheduleItem> schedules;
  final bool loading;
  final VoidCallback? onViewAll;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quản lý lịch trình',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: FuvekonColors.darkAppBarTitle,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lịch trình theo ngày và khung giờ.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onViewAll ?? () => context.push(Routes.adminSchedules),
              child: const Text('Xem tất cả'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (schedules.isEmpty)
          _EmptyEventCard(onCreate: onCreate)
        else
          ...schedules
              .take(3)
              .map(
                (schedule) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _EventScheduleCard(schedule: schedule),
                ),
              ),
        if (!loading && schedules.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: OutlinedButton.icon(
              onPressed: onCreate ?? () => context.push(Routes.adminSchedules),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Tạo lịch trình mới'),
            ),
          ),
      ],
    );
  }
}

class _EmptyEventCard extends StatelessWidget {
  const _EmptyEventCard({this.onCreate});

  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 40,
              color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            Text(
              'Chưa có lịch trình',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: FuvekonColors.darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: onCreate ?? () => context.push(Routes.adminSchedules),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Tạo lịch trình'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventScheduleCard extends StatelessWidget {
  const _EventScheduleCard({required this.schedule});

  final AdminScheduleItem schedule;

  String _formatRange() {
    final fmt = DateFormat('dd/MM/yyyy');
    final start = schedule.startAt;
    final end = schedule.endAt;
    if (start == null && end == null) return 'Chưa đặt thời gian';
    if (start != null && end != null) {
      return '${fmt.format(start)} – ${fmt.format(end)}';
    }
    if (start != null) return 'Từ ${fmt.format(start)}';
    return 'Đến ${fmt.format(end!)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: FuvekonColors.darkSurfaceElevated,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => context.push(Routes.adminScheduleDetail(schedule.id)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: FuvekonColors.darkBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event_outlined,
                  color: FuvekonColors.darkPrimary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: FuvekonColors.darkText,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatRange(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: FuvekonColors.darkTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                    '${schedule.dayCount} ngày · ${schedule.timelineItemCount} mục',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: FuvekonColors.available,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
