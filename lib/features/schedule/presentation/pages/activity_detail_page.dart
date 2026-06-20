import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/schedule_route_context.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/activity_detail_cubit.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/activity_detail_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({super.key, required this.activityId});

  final String activityId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ActivityDetailCubit>()..load(activityId),
      child: _ActivityDetailView(activityId: activityId),
    );
  }
}

class _ActivityDetailView extends StatefulWidget {
  const _ActivityDetailView({required this.activityId});

  final String activityId;

  @override
  State<_ActivityDetailView> createState() => _ActivityDetailViewState();
}

class _ActivityDetailViewState extends State<_ActivityDetailView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ActivityDetailCubit, ActivityDetailState>(
      listenWhen: (prev, next) {
        if (next is ActivityDetailLoaded && next.bookmarkError != null) {
          return prev is! ActivityDetailLoaded ||
              prev.bookmarkError != next.bookmarkError;
        }
        if (next is ActivityDetailLoaded && next.conflictWith != null) {
          return prev is! ActivityDetailLoaded ||
              prev.conflictWith != next.conflictWith;
        }
        return false;
      },
      listener: (context, state) {
        if (state is ActivityDetailLoaded && state.bookmarkError != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.bookmarkError!)));
          context.read<ActivityDetailCubit>().clearBookmarkError();
          return;
        }
        if (state is! ActivityDetailLoaded || state.conflictWith == null) {
          return;
        }
        final l10n = context.l10n;
        final cubit = context.read<ActivityDetailCubit>();
        final conflict = state.conflictWith!;

        showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.scheduleConflictTitle),
            content: Text(l10n.scheduleConflictMessage(conflict.title)),
            actions: [
              TextButton(
                onPressed: () {
                  cubit.clearConflict();
                  Navigator.of(dialogContext).pop();
                },
                child: Text(l10n.scheduleConflictCancel),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  cubit.confirmReplaceConflict();
                },
                child: Text(l10n.scheduleConflictReplace),
              ),
            ],
          ),
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.scheduleActivityDetail)),
          body: switch (state) {
            ActivityDetailInitial() || ActivityDetailLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ActivityDetailFailure(:final message) => Center(
              child: Text(message),
            ),
            ActivityDetailLoaded(:final activity, :final isBookmarked) =>
              ListView(
                padding: const EdgeInsets.all(FuvekonSpacing.page),
                children: [
                  FuveMintCard(
                    showGoldAccent: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                activity.title,
                                style: TextStyle(
                                  color: context.fuvekonTheme.contentOnCard,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            FuveStatusBadge(
                              label: _kindLabel(activity.kind, l10n),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          icon: Icons.schedule,
                          label: l10n.scheduleTime,
                          value: _formatTimeRange(context, activity),
                        ),
                        const SizedBox(height: 10),
                        _DetailRow(
                          icon: Icons.place_outlined,
                          label: l10n.scheduleLocation,
                          value:
                              '${activity.venueName} · ${activity.locationName}',
                          onTap: () => context.push(
                            ScheduleRouteContext.venue(
                              context,
                              activity.venueId,
                            ),
                          ),
                        ),
                        if (activity.speakers.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _DetailRow(
                            icon: Icons.mic_outlined,
                            label: l10n.scheduleSpeakers,
                            value: activity.speakers.join(', '),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Text(
                          l10n.scheduleDescription,
                          style: TextStyle(
                            color: context.fuvekonTheme.contentOnCard,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          activity.description,
                          style: TextStyle(
                            color: context.fuvekonTheme.contentOnCardMuted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: FuvekonSpacing.section),
                  FuvePillButton(
                    label: isBookmarked
                        ? l10n.scheduleBookmarked
                        : l10n.scheduleBookmark,
                    icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    onPressed: state.isBookmarking
                        ? null
                        : () async {
                            await context
                                .read<ActivityDetailCubit>()
                                .toggleBookmark();
                            if (!context.mounted) return;
                            final current = context
                                .read<ActivityDetailCubit>()
                                .state;
                            if (current is ActivityDetailLoaded &&
                                current.isBookmarked &&
                                current.conflictWith == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.scheduleAddedToItinerary),
                                ),
                              );
                            }
                          },
                    variant: isBookmarked
                        ? FuvePillButtonVariant.secondary
                        : FuvePillButtonVariant.primary,
                  ),
                ],
              ),
          },
        );
      },
    );
  }

  String _formatTimeRange(BuildContext context, ScheduleActivity activity) {
    final locale = Localizations.localeOf(context).toString();
    final format = DateFormat('EEE d/M, HH:mm', locale);
    return '${format.format(activity.startAt)} – ${DateFormat('HH:mm', locale).format(activity.endAt)}';
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: FuvekonColors.premiumOnMintCardMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: FuvekonColors.premiumOnMintCardMuted,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: context.fuvekonTheme.contentOnCard,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          Icon(
            Icons.chevron_right,
            color: FuvekonColors.premiumOnMintCardMuted,
          ),
      ],
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: content,
      ),
    );
  }
}
