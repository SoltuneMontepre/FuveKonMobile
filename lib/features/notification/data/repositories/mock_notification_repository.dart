import 'package:fuvekonmobile/core/errors/failures.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/notification/domain/entities/notification_item.dart';
import 'package:fuvekonmobile/features/notification/domain/repositories/notification_repository.dart';

/// Mock notifications until the mobile client wires `GET /notifications`.
class MockNotificationRepository implements NotificationRepository {
  MockNotificationRepository() {
    final now = DateTime.now();
    _items = [
      NotificationItem(
        id: 'n1',
        title: 'Vé của bạn đã được duyệt',
        body:
            'Vé FUVEKON Premium của bạn đã được xác nhận. Bạn có thể xem mã QR '
            'trong mục Vé của tôi trước ngày diễn ra sự kiện.',
        kind: 'ticket',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationItem(
        id: 'n2',
        title: 'Cập nhật lịch trình ngày 1',
        body:
            'Panel "Furry Art Live" đã đổi phòng sang Hall B, 14:00–15:30. '
            'Vui lòng kiểm tra lịch trình cá nhân để cập nhật nhắc nhở.',
        kind: 'schedule',
        createdAt: now.subtract(const Duration(hours: 5)),
        readAt: now.subtract(const Duration(hours: 4)),
      ),
      NotificationItem(
        id: 'n3',
        title: 'Nhắc nhở check-in',
        body:
            'Sự kiện FUVEKON bắt đầu sau 24 giờ. Hãy chuẩn bị vé và giấy tờ tùy thân '
            'để check-in nhanh tại cổng chính.',
        kind: 'reminder',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationItem(
        id: 'n4',
        title: 'Thông báo hệ thống',
        body:
            'Ứng dụng FUVEKON đã được cập nhật với giao diện mới. '
            'Nếu gặp sự cố, vui lòng liên hệ ban tổ chức qua mục FAQ.',
        kind: 'system',
        createdAt: now.subtract(const Duration(days: 3)),
        readAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }

  late List<NotificationItem> _items;

  @override
  Future<Result<List<NotificationItem>>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final sorted = [..._items]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Success(sorted);
  }

  @override
  Future<Result<NotificationItem>> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    try {
      return Success(_items.firstWhere((n) => n.id == id));
    } on StateError {
      return const Error(UnknownFailure('Notification not found'));
    }
  }

  @override
  Future<Result<NotificationItem>> markAsRead(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _items.indexWhere((n) => n.id == id);
    if (index < 0) {
      return const Error(UnknownFailure('Notification not found'));
    }
    final updated = _items[index].copyWith(readAt: DateTime.now());
    _items[index] = updated;
    return Success(updated);
  }
}
