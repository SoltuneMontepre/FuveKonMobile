import 'package:fuvekonmobile/core/models/pagination_meta.dart';
import 'package:fuvekonmobile/features/notification/domain/entities/notification_item.dart';

class NotificationPageResult {
  const NotificationPageResult({required this.items, required this.meta});

  final List<NotificationItem> items;
  final PaginationMeta meta;
}
