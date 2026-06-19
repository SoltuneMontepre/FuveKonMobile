import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/notification/domain/entities/notification_item.dart';

/// Domain contract for the notification feature.
abstract interface class NotificationRepository {
  Future<Result<List<NotificationItem>>> list();

  Future<Result<NotificationItem>> getById(String id);

  Future<Result<NotificationItem>> markAsRead(String id);
}
