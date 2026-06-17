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
  const NotificationListLoaded(this.items);

  final List<NotificationItem> items;
}

final class NotificationListEmpty extends NotificationListState {
  const NotificationListEmpty();
}

final class NotificationListFailure extends NotificationListState {
  const NotificationListFailure(this.message);

  final String message;
}
