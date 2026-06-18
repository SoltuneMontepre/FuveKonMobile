import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_list_cubit.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_list_state.dart';
import 'package:fuvekonmobile/features/notification/presentation/widgets/notification_list_card.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';

/// Màn 31 — notification list (mint cards on dark canvas).
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationListCubit>()..load(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppPageScaffold(
      title: l10n.navNotifications,
      showBackButton: false,
      padding: EdgeInsets.zero,
      body: BlocBuilder<NotificationListCubit, NotificationListState>(
        builder: (context, state) {
          return switch (state) {
            NotificationListInitial() || NotificationListLoading() =>
              const Center(child: CircularProgressIndicator()),
            NotificationListEmpty() => Padding(
              padding: const EdgeInsets.all(FuvekonSpacing.page),
              child: EmptyState(
                title: l10n.navNotifications,
                subtitle: l10n.authHomeNotificationsEmpty,
                icon: Icons.notifications_outlined,
              ),
            ),
            NotificationListLoaded(:final items) => RefreshIndicator(
              onRefresh: () => context.read<NotificationListCubit>().refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(FuvekonSpacing.page),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: FuvekonSpacing.stackGapMd),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return NotificationListCard(
                    item: item,
                    onTap: () =>
                        context.push(Routes.accountNotificationDetail(item.id)),
                  );
                },
              ),
            ),
            NotificationListFailure(:final message) => _NotificationsError(
              message: message,
              onRetry: () => context.read<NotificationListCubit>().load(),
            ),
          };
        },
      ),
    );
  }
}

class _NotificationsError extends StatelessWidget {
  const _NotificationsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FuvekonSpacing.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: FuvekonSpacing.field),
            FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}
