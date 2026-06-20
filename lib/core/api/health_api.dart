import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

class HealthApi extends BaseApi {
  HealthApi(super.client);

  Future<ApiResponse<Map<String, dynamic>>> getSystemHealth() {
    return get(ApiConstants.adminHealth, mapData: mapJsonObject);
  }
}
