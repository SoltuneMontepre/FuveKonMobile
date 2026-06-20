import 'package:dio/dio.dart';
import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// Dealer endpoints from `useDealer.ts`.
class DealerApi extends BaseApi {
  DealerApi(super.client);

  Future<ApiResponse<Map<String, dynamic>>> registerDealer(
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.dealerRegister,
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> joinDealer({
    required String boothCode,
  }) {
    return post(
      ApiConstants.dealerJoin,
      data: {'booth_code': boothCode},
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> removeStaff(
    Map<String, dynamic> payload,
  ) {
    return delete(
      ApiConstants.dealerStaffRemove,
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> leaveDealer() {
    return delete(ApiConstants.dealerLeave, mapData: mapJsonObject);
  }

  Future<ApiResponse<Map<String, dynamic>>> getMyDealer() {
    return get(
      ApiConstants.dealerMe,
      mapData: mapJsonObject,
      throwOnFailure: false,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> editDealer(
    String id,
    Map<String, dynamic> payload,
  ) {
    return patch(
      ApiConstants.dealer(id),
      data: payload,
      mapData: mapJsonObject,
    );
  }
}

class AdminDealerFilter {
  const AdminDealerFilter({this.page, this.pageSize, this.isVerified});

  final int? page;
  final int? pageSize;
  final bool? isVerified;

  Map<String, dynamic> toQuery() => buildQuery({
    if (page != null) 'page': page,
    if (pageSize != null) 'page_size': pageSize,
    if (isVerified != null) 'is_verified': isVerified,
  });
}

/// Admin dealer endpoints from `useAdminDealer.ts`.
class AdminDealerApi extends BaseApi {
  AdminDealerApi(super.client);

  Future<ApiResponse<List<dynamic>>> getDealers([
    AdminDealerFilter filter = const AdminDealerFilter(),
  ]) {
    return get(
      ApiConstants.adminDealers,
      queryParameters: filter.toQuery(),
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getDealerById(String dealerId) {
    return get(ApiConstants.adminDealer(dealerId), mapData: mapJsonObject);
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyDealer(String dealerId) {
    return patch(
      ApiConstants.adminDealerVerify(dealerId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> denyDealer(String dealerId) {
    return patch(
      ApiConstants.adminDealerDeny(dealerId),
      mapData: mapJsonObject,
    );
  }
}
