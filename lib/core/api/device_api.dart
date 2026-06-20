import 'package:dio/dio.dart';
import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// Device token endpoints for FCM push notifications.
class DeviceApi extends BaseApi {
  DeviceApi(super.client);

  Future<ApiResponse<Map<String, dynamic>>> registerFcmToken({
    required String token,
    required String platform,
    String? deviceId,
  }) {
    return post(
      ApiConstants.devicesFcmToken,
      data: {
        'token': token,
        'platform': platform,
        if (deviceId != null && deviceId.isNotEmpty) 'device_id': deviceId,
      },
      mapData: mapJsonObject,
    );
  }

  /// Best-effort unregister during logout (401 is OK if session already expired).
  Future<void> unregisterFcmToken({required String token}) async {
    await delete<void>(
      ApiConstants.devicesFcmToken,
      data: {'token': token},
      throwOnFailure: false,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }
}
