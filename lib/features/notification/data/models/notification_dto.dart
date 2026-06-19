import 'package:fuvekonmobile/features/notification/domain/entities/notification_item.dart';

class NotificationDto {
  const NotificationDto({
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

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      kind: json['kind']?.toString() ?? '',
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      readAt: _parseDate(json['read_at']),
    );
  }

  NotificationItem toDomain() {
    return NotificationItem(
      id: id,
      title: title,
      body: body,
      kind: kind,
      createdAt: createdAt,
      readAt: readAt,
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
