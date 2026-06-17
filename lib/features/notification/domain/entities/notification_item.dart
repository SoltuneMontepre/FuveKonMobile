import 'package:equatable/equatable.dart';

/// In-app notification for the authenticated user.
class NotificationItem extends Equatable {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.kind,
    required this.createdAt,
    this.readAt,
  });

  final String id;
  final String title;
  final String body;
  final String kind;
  final DateTime createdAt;
  final DateTime? readAt;

  bool get isRead => readAt != null;

  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    String? kind,
    DateTime? createdAt,
    DateTime? readAt,
    bool clearReadAt = false,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      kind: kind ?? this.kind,
      createdAt: createdAt ?? this.createdAt,
      readAt: clearReadAt ? null : (readAt ?? this.readAt),
    );
  }

  @override
  List<Object?> get props => [id, title, body, kind, createdAt, readAt];
}
