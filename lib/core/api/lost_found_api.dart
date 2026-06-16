import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

class AdminLostFoundFilter {
  const AdminLostFoundFilter({
    this.itemType,
    this.status,
    this.search,
    this.page = 1,
    this.pageSize = 20,
  });

  final String? itemType;
  final String? status;
  final String? search;
  final int page;
  final int pageSize;

  Map<String, dynamic> toQuery() => buildQuery({
        if (itemType != null) 'item_type': itemType,
        if (status != null) 'status': status,
        if (search != null) 'search': search,
        'page': page,
        'page_size': pageSize,
      });
}

/// Admin lost & found endpoints.
class AdminLostFoundApi extends BaseApi {
  AdminLostFoundApi(super.client);

  Future<ApiResponse<Map<String, dynamic>>> list([
    AdminLostFoundFilter filter = const AdminLostFoundFilter(),
  ]) {
    return get(
      ApiConstants.adminLostFound,
      queryParameters: filter.toQuery(),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getById(String id) {
    return get(
      ApiConstants.adminLostFoundItem(id),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> create(
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.adminLostFound,
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> update(
    String id,
    Map<String, dynamic> payload,
  ) {
    return put(
      ApiConstants.adminLostFoundItem(id),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateStatus(
    String id,
    String status,
  ) {
    return patch(
      ApiConstants.adminLostFoundStatus(id),
      data: {'status': status},
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<void>> deleteItem(String id) {
    return delete<void>(ApiConstants.adminLostFoundItem(id));
  }

  Future<ApiResponse<Map<String, dynamic>>> confirmReturn(
    String id,
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.adminLostFoundReturn(id),
      data: payload,
      mapData: mapJsonObject,
    );
  }
}

class LostFoundFilter {
  const LostFoundFilter({
    this.search,
    this.page = 1,
    this.pageSize = 20,
  });

  final String? search;
  final int page;
  final int pageSize;

  Map<String, dynamic> toQuery() => buildQuery({
        if (search != null) 'search': search,
        'page': page,
        'page_size': pageSize,
      });
}

/// User lost & found endpoints (ticket holders).
class LostFoundApi extends BaseApi {
  LostFoundApi(super.client);

  Future<ApiResponse<Map<String, dynamic>>> list([
    LostFoundFilter filter = const LostFoundFilter(),
  ]) {
    return get(
      ApiConstants.lostFound,
      queryParameters: filter.toQuery(),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getById(String id) {
    return get(
      ApiConstants.lostFoundItem(id),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> claim(
    String id, {
    String message = '',
  }) {
    return post(
      ApiConstants.lostFoundClaim(id),
      data: {if (message.isNotEmpty) 'message': message},
      mapData: mapJsonObject,
    );
  }
}
