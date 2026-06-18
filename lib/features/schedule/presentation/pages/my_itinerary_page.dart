import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/schedule_route_context.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/itinerary_item.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/itinerary_cubit.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/itinerary_state.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MyItineraryPage extends StatelessWidget {
  const MyItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ItineraryCubit>()..load(),
      child: const _MyItineraryView(),
    );
  }
}

class _MyItineraryView extends StatelessWidget {
  const _MyItineraryView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scheduleMyItinerary)),
      body: BlocBuilder<ItineraryCubit, ItineraryState>(
        builder: (context, state) {
          return switch (state) {
            ItineraryInitial() || ItineraryLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ItineraryFailure(:final message) => Center(child: Text(message)),
            ItineraryEmpty() => EmptyState(
                title: l10n.scheduleEmptyItinerary,
                subtitle: l10n.scheduleEmptyItineraryHint,
                icon: Icons.bookmark_border,
              ),
            ItineraryLoaded(:final items) => RefreshIndicator(
                onRefresh: () => context.read<ItineraryCubit>().refresh(),
                child: ListView(
                  padding: const EdgeInsets.all(FuvekonSpacing.page),
                  children: items
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ItineraryCard(item: item),
                        ),
                      )
                      .toList(),
                ),
              ),
          };
        },
      ),
    );
  }
}

class _ItineraryCard extends StatelessWidget {
  const _ItineraryCard({required this.item});

  final ItineraryItem item;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final timeFormat = DateFormat('EEE d/M, HH:mm', locale);

    return FuveMintCard(
      onTap: () => context.push(
        ScheduleRouteContext.activity(context, item.activityId),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.activity.title,
                  style: TextStyle(
                    color: context.fuvekonTheme.contentOnCard,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  timeFormat.format(item.activity.startAt),
                  style: const TextStyle(
                    color: FuvekonColors.premiumOnMintCardMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.activity.venueName} · ${item.activity.locationName}',
                  style: const TextStyle(
                    color: FuvekonColors.premiumOnMintCardMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: context.l10n.scheduleRemoveBookmark,
            icon: const Icon(Icons.close),
            color: FuvekonColors.premiumOnMintCardMuted,
            onPressed: () =>
                context.read<ItineraryCubit>().remove(item.activityId),
          ),
        ],
      ),
    );
  }
}
