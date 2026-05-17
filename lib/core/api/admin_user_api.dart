import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

class AdminUserFilter {
  const AdminUserFilter({this.page, this.pageSize, this.search});

  final int? page;
  final int? pageSize;
  final String? search;

  Map<String, dynamic> toQuery() => buildQuery({
        if (page != null) 'page': page,
        if (pageSize != null) 'page_size': pageSize,
        if (search != null) 'search': search,
      });
}

/// Admin user endpoints from `useAdminUser.ts`.
class AdminUserApi extends BaseApi {
  AdminUserApi(super.client);

  Future<ApiResponse<List<dynamic>>> getUsers([
    AdminUserFilter filter = const AdminUserFilter(),
  ]) {
    return get(
      ApiConstants.adminUsers,
      queryParameters: filter.toQuery(),
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getUserById(String userId) {
    return get(
      ApiConstants.adminUser(userId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateUser(
    String userId,
    Map<String, dynamic> payload,
  ) {
    return put(
      ApiConstants.adminUser(userId),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getCountByCountry() {
    return get(
      ApiConstants.adminUsersCountByCountry,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getCountByAgeRange() {
    return get(
      ApiConstants.adminUsersCountByAgeRange,
      mapData: mapJsonObject,
    );
  }
}
