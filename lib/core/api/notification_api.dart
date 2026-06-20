import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// User notification endpoints.
class NotificationApi extends BaseApi {
  NotificationApi(super.client);

  Future<ApiResponse<List<dynamic>>> list({
    int page = 1,
    int pageSize = 50,
    String? kind,
    bool unreadOnly = false,
  }) {
    return get(
      ApiConstants.notifications,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (kind != null && kind.isNotEmpty) 'kind': kind,
        if (unreadOnly) 'unread_only': true,
      },
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> unreadCount() {
    return get(ApiConstants.notificationsUnreadCount, mapData: mapJsonObject);
  }

  Future<ApiResponse<Map<String, dynamic>>> markAllRead() {
    return put(ApiConstants.notificationsReadAll, mapData: mapJsonObject);
  }

  Future<ApiResponse<Map<String, dynamic>>> getById(String id) {
    return get(ApiConstants.notification(id), mapData: mapJsonObject);
  }

  Future<ApiResponse<Map<String, dynamic>>> markAsRead(String id) {
    return put(
      ApiConstants.notification(id),
      data: const {'mark_read': true},
      mapData: mapJsonObject,
    );
  }
}
