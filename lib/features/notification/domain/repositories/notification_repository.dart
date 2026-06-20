import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/notification/domain/entities/notification_item.dart';
import 'package:fuvekonmobile/features/notification/domain/entities/notification_page_result.dart';

/// Domain contract for the notification feature.
abstract interface class NotificationRepository {
  Future<Result<NotificationPageResult>> list({
    int page = 1,
    int pageSize = 20,
    String? kind,
    bool unreadOnly = false,
  });

  Future<Result<int>> unreadCount();

  Future<Result<int>> markAllRead();

  Future<Result<NotificationItem>> getById(String id);

  Future<Result<NotificationItem>> markAsRead(String id);
}
