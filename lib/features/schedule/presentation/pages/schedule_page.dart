import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/schedule_route_context.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/schedule_list_cubit.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/schedule_list_state.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ScheduleListCubit>()..load(),
      child: const _ScheduleView(),
    );
  }
}

class _ScheduleView extends StatelessWidget {
  const _ScheduleView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: l10n.scheduleViewMap,
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.push(ScheduleRouteContext.map(context)),
          ),
          IconButton(
            tooltip: l10n.scheduleMyItinerary,
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () => context.push(ScheduleRouteContext.my(context)),
          ),
        ],
      ),
      body: BlocConsumer<ScheduleListCubit, ScheduleListState>(
        listenWhen: (prev, next) =>
            next is ScheduleListLoaded &&
            next.bookmarkError != null &&
            (prev is! ScheduleListLoaded ||
                prev.bookmarkError != next.bookmarkError),
        listener: (context, state) {
          final message = (state as ScheduleListLoaded).bookmarkError!;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          context.read<ScheduleListCubit>().clearBookmarkError();
        },
        builder: (context, state) {
          return switch (state) {
            ScheduleListInitial() || ScheduleListLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ScheduleListFailure(:final message) => Center(child: Text(message)),
            ScheduleListLoaded() => RefreshIndicator(
              onRefresh: () => context.read<ScheduleListCubit>().load(),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      FuvekonSpacing.page,
                      4,
                      FuvekonSpacing.page,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        l10n.navSchedule,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      FuvekonSpacing.page,
                      20,
                      FuvekonSpacing.page,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(child: _DayTabs(state: state)),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      FuvekonSpacing.page,
                      16,
                      FuvekonSpacing.page,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _KindFilterRow(state: state, l10n: l10n),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      FuvekonSpacing.page,
                      20,
                      FuvekonSpacing.page,
                      32,
                    ),
                    sliver: state.filteredActivities.isEmpty
                        ? SliverToBoxAdapter(
                            child: EmptyState(
                              title: l10n.scheduleNoActivities,
                              icon: Icons.event_busy_outlined,
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final activities = state.filteredActivities;
                              return _ActivityTimelineTile(
                                activity: activities[index],
                                isBookmarked: state.isBookmarked(
                                  activities[index].id,
                                ),
                                isLast: index == activities.length - 1,
                              );
                            }, childCount: state.filteredActivities.length),
                          ),
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}

class _DayTabs extends StatelessWidget {
  const _DayTabs({required this.state});

  final ScheduleListLoaded state;

  List<DateTime> _days() {
    final start = DateTime(
      state.event.startAt.year,
      state.event.startAt.month,
      state.event.startAt.day,
    );
    final end = DateTime(
      state.event.endAt.year,
      state.event.endAt.month,
      state.event.endAt.day,
    );
    final days = <DateTime>[];
    var cursor = start;
    while (!cursor.isAfter(end)) {
      days.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final days = _days();

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 1,
            color: FuvekonColors.outlineVariantToken.withValues(alpha: 0.4),
          ),
        ),
        Row(
          children: [
            for (var i = 0; i < days.length; i++)
              Expanded(
                child: _DayTab(
                  label: l10n.scheduleDayLabel(i + 1),
                  selected: _isSameDay(days[i], state.selectedDay),
                  onTap: () =>
                      context.read<ScheduleListCubit>().selectDay(days[i]),
                ),
              ),
          ],
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayTab extends StatelessWidget {
  const _DayTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected
                    ? FuvekonColors.premiumPrimary
                    : FuvekonColors.premiumOnSurfaceVariant,
                fontSize: 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Container(
            height: 2,
            width: double.infinity,
            color: selected ? FuvekonColors.premiumPrimary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _KindFilterRow extends StatelessWidget {
  const _KindFilterRow({required this.state, required this.l10n});

  final ScheduleListLoaded state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final availableKinds = <ScheduleActivityKind>[];
    for (final activity in state.activities) {
      if (!availableKinds.contains(activity.kind)) {
        availableKinds.add(activity.kind);
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _KindFilterPill(
            label: l10n.scheduleFilterAll,
            selected: state.selectedKind == null,
            onTap: () => context.read<ScheduleListCubit>().selectKind(null),
          ),
          for (final kind in availableKinds) ...[
            const SizedBox(width: 8),
            _KindFilterPill(
              label: _kindLabel(kind, l10n),
              selected: state.selectedKind == kind,
              onTap: () => context.read<ScheduleListCubit>().selectKind(kind),
            ),
          ],
        ],
      ),
    );
  }
}

class _KindFilterPill extends StatelessWidget {
  const _KindFilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? FuvekonColors.premiumPrimary
              : FuvekonColors.surfaceContainer,
          borderRadius: BorderRadius.circular(999),
          border: selected
              ? null
              : Border.all(
                  color: FuvekonColors.outlineVariantToken.withValues(
                    alpha: 0.6,
                  ),
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? FuvekonColors.premiumOnPrimary
                : FuvekonColors.premiumOnSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

(Color bg, Color fg) _kindAccentColors(ScheduleActivityKind kind) {
  return switch (kind) {
    ScheduleActivityKind.panel => (
      FuvekonColors.dustyRose,
      FuvekonColors.onDustyRose,
    ),
    ScheduleActivityKind.workshop => (
      FuvekonColors.lightGold,
      FuvekonColors.onLightGold,
    ),
    ScheduleActivityKind.talent => (
      FuvekonColors.sageGreen,
      FuvekonColors.onSageGreen,
    ),
    ScheduleActivityKind.ceremony => (
      FuvekonColors.sageGreenContainer,
      FuvekonColors.onSageGreenContainer,
    ),
    ScheduleActivityKind.other => (
      FuvekonColors.premiumSurfaceContainerHigh,
      FuvekonColors.premiumOnSurface,
    ),
  };
}

String _kindLabel(ScheduleActivityKind kind, AppLocalizations l10n) {
  return switch (kind) {
    ScheduleActivityKind.panel => l10n.scheduleKindPanel,
    ScheduleActivityKind.talent => l10n.scheduleKindTalent,
    ScheduleActivityKind.workshop => l10n.scheduleKindWorkshop,
    ScheduleActivityKind.ceremony => l10n.scheduleKindCeremony,
    ScheduleActivityKind.other => l10n.scheduleKindOther,
  };
}

class _ActivityTimelineTile extends StatelessWidget {
  const _ActivityTimelineTile({
    required this.activity,
    required this.isBookmarked,
    required this.isLast,
  });

  final ScheduleActivity activity;
  final bool isBookmarked;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final (accent, _) = _kindAccentColors(activity.kind);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TimelineRail(color: accent, showLine: !isLast),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: _ActivityCard(
                activity: activity,
                isBookmarked: isBookmarked,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineRail extends StatelessWidget {
  const _TimelineRail({required this.color, required this.showLine});

  final Color color;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        if (showLine)
          Expanded(
            child: Container(
              width: 2,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: FuvekonColors.outlineVariantToken.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity, required this.isBookmarked});

  final ScheduleActivity activity;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final timeFormat = DateFormat('HH:mm', locale);
    final (accentBg, accentFg) = _kindAccentColors(activity.kind);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () =>
            context.push(ScheduleRouteContext.activity(context, activity.id)),
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accentBg),
              Expanded(
                child: Container(
                  color: FuvekonColors.surfaceContainer,
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${timeFormat.format(activity.startAt)} - '
                            '${timeFormat.format(activity.endAt)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: accentBg,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              _kindLabel(activity.kind, l10n),
                              style: TextStyle(
                                color: accentFg,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activity.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: FuvekonColors.premiumOnSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              activity.venueName,
                              style: TextStyle(
                                color: FuvekonColors.premiumOnSurfaceVariant,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _BookmarkButton(
                            isBookmarked: isBookmarked,
                            onTap: () => context
                                .read<ScheduleListCubit>()
                                .toggleBookmark(activity),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  const _BookmarkButton({required this.isBookmarked, required this.onTap});

  final bool isBookmarked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_add_outlined,
          size: 18,
          color: isBookmarked
              ? FuvekonColors.premiumPrimary
              : FuvekonColors.premiumOnSurfaceVariant,
        ),
      ),
    );
  }
}
