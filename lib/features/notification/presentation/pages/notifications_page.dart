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

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<NotificationListCubit>().loadMore();
    }
  }

  Future<void> _markAllRead() async {
    final l10n = context.l10n;
    final ok = await context.read<NotificationListCubit>().markAllRead();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? l10n.notificationsMarkAllReadSuccess
              : l10n.notificationsMarkAllReadFailed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppPageScaffold(
      title: l10n.navNotifications,
      showBackButton: false,
      padding: EdgeInsets.zero,
      actions: [
        BlocBuilder<NotificationListCubit, NotificationListState>(
          builder: (context, state) {
            final unreadOnly = switch (state) {
              NotificationListLoaded(:final unreadOnly) => unreadOnly,
              NotificationListEmpty(:final unreadOnly) => unreadOnly,
              _ => false,
            };
            return IconButton(
              tooltip: l10n.notificationsUnreadOnly,
              onPressed: () => context
                  .read<NotificationListCubit>()
                  .setUnreadOnly(!unreadOnly),
              icon: Icon(
                unreadOnly
                    ? Icons.mark_email_unread
                    : Icons.mark_email_unread_outlined,
                color: unreadOnly ? FuvekonColors.sageGreen : null,
              ),
            );
          },
        ),
        IconButton(
          tooltip: l10n.notificationsMarkAllRead,
          onPressed: _markAllRead,
          icon: const Icon(Icons.done_all),
        ),
      ],
      body: BlocBuilder<NotificationListCubit, NotificationListState>(
        builder: (context, state) {
          return switch (state) {
            NotificationListInitial() || NotificationListLoading() =>
              const Center(child: CircularProgressIndicator()),
            NotificationListEmpty(:final unreadOnly) => Padding(
              padding: const EdgeInsets.all(FuvekonSpacing.page),
              child: EmptyState(
                title: l10n.navNotifications,
                subtitle: unreadOnly
                    ? l10n.notificationsEmptyUnread
                    : l10n.authHomeNotificationsEmpty,
                icon: Icons.notifications_outlined,
              ),
            ),
            NotificationListLoaded(:final items, :final isLoadingMore) =>
              RefreshIndicator(
                onRefresh: () =>
                    context.read<NotificationListCubit>().refresh(),
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(FuvekonSpacing.page),
                  itemCount: items.length + (isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, index) {
                    if (index >= items.length - 1) {
                      return const SizedBox.shrink();
                    }
                    return const SizedBox(height: FuvekonSpacing.stackGapMd);
                  },
                  itemBuilder: (context, index) {
                    if (index >= items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }
                    final item = items[index];
                    return NotificationListCard(
                      item: item,
                      onTap: () async {
                        await context.push(
                          Routes.accountNotificationDetail(item.id),
                        );
                        if (context.mounted) {
                          await context.read<NotificationListCubit>().refresh();
                        }
                      },
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
