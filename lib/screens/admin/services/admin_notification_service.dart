import 'package:fuvekonmobile/core/api/admin_notification_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';

class AdminCreateNotificationInput {
  const AdminCreateNotificationInput({
    required this.userId,
    required this.title,
    required this.body,
    this.kind,
    this.sendEmail = false,
    this.sendPush = true,
  });

  final String userId;
  final String title;
  final String body;
  final String? kind;
  final bool sendEmail;
  final bool sendPush;
}

class AdminCreateNotificationResult {
  const AdminCreateNotificationResult({
    required this.notificationId,
    required this.emailSent,
    required this.pushSent,
    this.emailError,
    this.pushError,
    this.devicesNotified = 0,
  });

  factory AdminCreateNotificationResult.fromJson(Map<String, dynamic> json) {
    final notification = json['notification'];
    final id = notification is Map<String, dynamic>
        ? notification['id']?.toString() ?? ''
        : '';

    return AdminCreateNotificationResult(
      notificationId: id,
      emailSent: json['email_sent'] as bool? ?? false,
      pushSent: json['push_sent'] as bool? ?? false,
      emailError: json['email_error'] as String?,
      pushError: json['push_error'] as String?,
      devicesNotified: (json['devices_notified'] as num?)?.toInt() ?? 0,
    );
  }

  final String notificationId;
  final bool emailSent;
  final bool pushSent;
  final String? emailError;
  final String? pushError;
  final int devicesNotified;
}

class AdminBroadcastNotificationInput {
  const AdminBroadcastNotificationInput({
    required this.title,
    required this.body,
    this.kind,
    this.role,
    this.sendEmail = false,
    this.sendPush = true,
  });

  final String title;
  final String body;
  final String? kind;
  final String? role;
  final bool sendEmail;
  final bool sendPush;
}

class AdminBroadcastNotificationResult {
  const AdminBroadcastNotificationResult({
    required this.recipients,
    required this.inboxCreated,
    required this.emailsSent,
    required this.pushDevicesSent,
    this.error,
  });

  factory AdminBroadcastNotificationResult.fromJson(Map<String, dynamic> json) {
    return AdminBroadcastNotificationResult(
      recipients: (json['recipients'] as num?)?.toInt() ?? 0,
      inboxCreated: (json['inbox_created'] as num?)?.toInt() ?? 0,
      emailsSent: (json['emails_sent'] as num?)?.toInt() ?? 0,
      pushDevicesSent: (json['push_devices_sent'] as num?)?.toInt() ?? 0,
      error: json['error'] as String?,
    );
  }

  final int recipients;
  final int inboxCreated;
  final int emailsSent;
  final int pushDevicesSent;
  final String? error;
}

class AdminNotificationService {
  AdminNotificationService({required AdminNotificationApi api}) : _api = api;

  final AdminNotificationApi _api;

  Future<AdminCreateNotificationResult> createNotification(
    AdminCreateNotificationInput input,
  ) async {
    final response = await _api.createNotification(
      userId: input.userId,
      title: input.title,
      body: input.body,
      kind: input.kind,
      sendEmail: input.sendEmail,
      sendPush: input.sendPush,
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }

    return AdminCreateNotificationResult.fromJson(response.data!);
  }

  Future<AdminBroadcastNotificationResult> broadcast(
    AdminBroadcastNotificationInput input,
  ) async {
    final response = await _api.broadcast(
      title: input.title,
      body: input.body,
      kind: input.kind,
      role: input.role,
      sendEmail: input.sendEmail,
      sendPush: input.sendPush,
    );

    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }

    return AdminBroadcastNotificationResult.fromJson(response.data!);
  }
}
