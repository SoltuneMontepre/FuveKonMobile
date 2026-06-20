import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/schedule_route_context.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/schedule_list_cubit.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/schedule_list_state.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
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
      appBar: AppBar(
        title: Text(l10n.navSchedule),
        automaticallyImplyLeading: false,
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
      body: BlocBuilder<ScheduleListCubit, ScheduleListState>(
        builder: (context, state) {
          return switch (state) {
            ScheduleListInitial() || ScheduleListLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ScheduleListFailure(:final message) => Center(child: Text(message)),
            ScheduleListLoaded() => RefreshIndicator(
              onRefresh: () => context.read<ScheduleListCubit>().load(),
              child: ListView(
                padding: const EdgeInsets.all(FuvekonSpacing.page),
                children: [
                  FuveMintCard(
                    onTap: () => context.push(
                      ScheduleRouteContext.event(context, state.event.id),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.event.name,
                          style: TextStyle(
                            color: context.fuvekonTheme.contentOnCard,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.event.description,
                          style: TextStyle(
                            color: context.fuvekonTheme.contentOnCardMuted,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: FuvekonSpacing.section),
                  FuveSectionHeader(title: l10n.scheduleDayFilter),
                  const SizedBox(height: 12),
                  _DayChips(state: state),
                  const SizedBox(height: FuvekonSpacing.section),
                  FuveSectionHeader(title: l10n.scheduleActivities),
                  const SizedBox(height: 12),
                  if (state.activities.isEmpty)
                    EmptyState(
                      title: l10n.scheduleNoActivities,
                      icon: Icons.event_busy_outlined,
                    )
                  else
                    ...state.activities.map(
                      (activity) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ActivityCard(activity: activity),
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

class _DayChips extends StatelessWidget {
  const _DayChips({required this.state});

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
    final locale = Localizations.localeOf(context).toString();
    final dayFormat = DateFormat('EEE d/M', locale);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _days().map((day) {
          final selected =
              day.year == state.selectedDay.year &&
              day.month == state.selectedDay.month &&
              day.day == state.selectedDay.day;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(dayFormat.format(day)),
              selected: selected,
              onSelected: (_) =>
                  context.read<ScheduleListCubit>().selectDay(day),
              selectedColor: FuvekonColors.premiumPrimary.withValues(
                alpha: 0.35,
              ),
              checkmarkColor: FuvekonColors.premiumOnPrimary,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity});

  final ScheduleActivity activity;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final timeFormat = DateFormat('HH:mm', locale);

    return FuveMintCard(
      onTap: () =>
          context.push(ScheduleRouteContext.activity(context, activity.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  activity.title,
                  style: TextStyle(
                    color: context.fuvekonTheme.contentOnCard,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              FuveStatusBadge(
                label: _kindLabel(activity.kind, l10n),
                variant: FuveStatusBadgeVariant.neutral,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _MetaRow(
            icon: Icons.schedule,
            label:
                '${timeFormat.format(activity.startAt)} – ${timeFormat.format(activity.endAt)}',
          ),
          const SizedBox(height: 6),
          _MetaRow(
            icon: Icons.place_outlined,
            label: '${activity.venueName} · ${activity.locationName}',
          ),
        ],
      ),
    );
  }

  String _kindLabel(ScheduleActivityKind kind, dynamic l10n) {
    return switch (kind) {
      ScheduleActivityKind.panel => l10n.scheduleKindPanel,
      ScheduleActivityKind.talent => l10n.scheduleKindTalent,
      ScheduleActivityKind.workshop => l10n.scheduleKindWorkshop,
      ScheduleActivityKind.ceremony => l10n.scheduleKindCeremony,
      ScheduleActivityKind.other => l10n.scheduleKindOther,
    };
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: FuvekonColors.premiumOnMintCardMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: FuvekonColors.premiumOnMintCardMuted,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
