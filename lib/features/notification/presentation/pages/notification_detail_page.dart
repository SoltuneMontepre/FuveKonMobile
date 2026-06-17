import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_detail_cubit.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_detail_state.dart';
import 'package:fuvekonmobile/features/notification/presentation/widgets/notification_list_card.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:intl/intl.dart';

/// Màn 32 — notification detail at `/account/notifications/:id`.
class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({
    super.key,
    required this.notificationId,
  });

  final String notificationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<NotificationDetailCubit>()..load(notificationId),
      child: _NotificationDetailView(notificationId: notificationId),
    );
  }
}

class _NotificationDetailView extends StatelessWidget {
  const _NotificationDetailView({required this.notificationId});

  final String notificationId;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Chi tiết thông báo',
      padding: const EdgeInsets.all(FuvekonSpacing.page),
      body: BlocBuilder<NotificationDetailCubit, NotificationDetailState>(
        builder: (context, state) {
          return switch (state) {
            NotificationDetailInitial() || NotificationDetailLoading() =>
              const Center(child: CircularProgressIndicator()),
            NotificationDetailLoaded(:final item) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FuveMintCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              NotificationKindBadge(kind: item.kind),
                              const Spacer(),
                              Text(
                                DateFormat('HH:mm dd/MM/yyyy')
                                    .format(item.createdAt),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: context
                                          .fuvekonTheme.contentOnCardMuted,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: FuvekonSpacing.stackGapMd),
                          Text(
                            item.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color:
                                      context.fuvekonTheme.contentOnCard,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: FuvekonSpacing.stackGapMd),
                          Text(
                            item.body,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: context
                                      .fuvekonTheme.contentOnCardMuted,
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            NotificationDetailFailure(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: FuvekonSpacing.field),
                    FilledButton(
                      onPressed: () => context
                          .read<NotificationDetailCubit>()
                          .load(notificationId),
                      child: const Text('Thử lại'),
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
