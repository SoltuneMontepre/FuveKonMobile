import 'package:fuvekonmobile/features/notification/domain/entities/notification_item.dart';

sealed class NotificationListState {
  const NotificationListState();
}

final class NotificationListInitial extends NotificationListState {
  const NotificationListInitial();
}

final class NotificationListLoading extends NotificationListState {
  const NotificationListLoading();
}

final class NotificationListLoaded extends NotificationListState {
  const NotificationListLoaded({
    required this.items,
    required this.hasMore,
    this.isLoadingMore = false,
    this.unreadOnly = false,
  });

  final List<NotificationItem> items;
  final bool hasMore;
  final bool isLoadingMore;
  final bool unreadOnly;
}

final class NotificationListEmpty extends NotificationListState {
  const NotificationListEmpty({this.unreadOnly = false});

  final bool unreadOnly;
}

final class NotificationListFailure extends NotificationListState {
  const NotificationListFailure(this.message);

  final String message;
}
