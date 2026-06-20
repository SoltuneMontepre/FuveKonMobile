import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// Admin notification endpoints (`POST /admin/notifications`).
class AdminNotificationApi extends BaseApi {
  AdminNotificationApi(super.client);

  Future<ApiResponse<Map<String, dynamic>>> createNotification({
    required String userId,
    required String title,
    required String body,
    String? kind,
    bool sendEmail = false,
    bool sendPush = false,
  }) {
    return post(
      ApiConstants.adminNotifications,
      data: {
        'user_id': userId,
        'title': title,
        'body': body,
        if (kind != null && kind.isNotEmpty) 'kind': kind,
        'send_email': sendEmail,
        'send_push': sendPush,
      },
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> broadcast({
    required String title,
    required String body,
    String? kind,
    String? role,
    bool sendEmail = false,
    bool sendPush = false,
  }) {
    return post(
      ApiConstants.adminNotificationsBroadcast,
      data: {
        'title': title,
        'body': body,
        if (kind != null && kind.isNotEmpty) 'kind': kind,
        if (role != null && role.isNotEmpty) 'role': role,
        'send_email': sendEmail,
        'send_push': sendPush,
      },
      mapData: mapJsonObject,
    );
  }
}
