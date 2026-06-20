import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

class AdminConbookFilter {
  const AdminConbookFilter({
    this.page,
    this.pageSize,
    this.search,
    this.status = 'pending',
  });

  final int? page;
  final int? pageSize;
  final String? search;
  final String status;

  Map<String, dynamic> toQuery() => buildQuery({
    if (page != null) 'page': page,
    if (pageSize != null) 'page_size': pageSize,
    if (search != null) 'search': search,
  });
}

/// Conbook / art submission endpoints from `useUploadFile.ts`.
class ConbookApi extends BaseApi {
  ConbookApi(super.client);

  Future<Map<String, dynamic>> upload(Map<String, dynamic> payload) {
    return postRaw(
      ApiConstants.conbooksUpload,
      data: payload,
      map: (json) => json,
    );
  }

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> payload) {
    return putRaw(ApiConstants.conbook(id), data: payload, map: (json) => json);
  }

  Future<ApiResponse<List<dynamic>>> getMySubmissions() {
    return get(ApiConstants.conbooks, mapData: mapJsonList);
  }

  Future<ApiResponse<Map<String, dynamic>>> getById(String id) {
    return get(ApiConstants.conbook(id), mapData: mapJsonObject);
  }

  Future<ApiResponse<List<dynamic>>> getAdminSubmissions([
    AdminConbookFilter filter = const AdminConbookFilter(),
  ]) {
    return get(
      ApiConstants.adminConbooks(filter.status),
      queryParameters: filter.toQuery(),
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> approveByAdmin(String id) {
    return patch(ApiConstants.adminConbookApprove(id), mapData: mapJsonObject);
  }

  Future<ApiResponse<Map<String, dynamic>>> requireChangesByAdmin(String id) {
    return patch(
      ApiConstants.adminConbookRequireChanges(id),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> denyByAdmin(String id) {
    return patch(ApiConstants.adminConbookDeny(id), mapData: mapJsonObject);
  }

  Future<ApiResponse<Map<String, dynamic>>> setPendingByAdmin(String id) {
    return patch(ApiConstants.adminConbookPending(id), mapData: mapJsonObject);
  }

  Future<Map<String, dynamic>> deleteSubmission(String id) {
    return deleteRaw(ApiConstants.conbook(id), map: (json) => json);
  }
}
