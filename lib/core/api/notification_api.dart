import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// User notification endpoints.
class NotificationApi extends BaseApi {
  NotificationApi(super.client);

  Future<ApiResponse<List<dynamic>>> list() {
    return get(
      ApiConstants.notifications,
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getById(String id) {
    return get(
      ApiConstants.notification(id),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> markAsRead(String id) {
    return put(
      ApiConstants.notification(id),
      data: const {'mark_read': true},
      mapData: mapJsonObject,
    );
  }
}
