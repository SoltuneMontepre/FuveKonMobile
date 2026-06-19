import 'package:fuvekonmobile/features/notification/domain/entities/notification_item.dart';

sealed class NotificationDetailState {
  const NotificationDetailState();
}

final class NotificationDetailInitial extends NotificationDetailState {
  const NotificationDetailInitial();
}

final class NotificationDetailLoading extends NotificationDetailState {
  const NotificationDetailLoading();
}

final class NotificationDetailLoaded extends NotificationDetailState {
  const NotificationDetailLoaded(this.item);

  final NotificationItem item;
}

final class NotificationDetailFailure extends NotificationDetailState {
  const NotificationDetailFailure(this.message);

  final String message;
}
