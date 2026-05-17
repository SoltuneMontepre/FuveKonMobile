import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// Talent endpoints from `useTalent.ts`.
class TalentApi extends BaseApi {
  TalentApi(super.client);

  Future<ApiResponse<Map<String, dynamic>>> createTalent(
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.talents,
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<List<dynamic>>> getMyTalents() {
    return get(
      ApiConstants.talents,
      mapData: mapJsonList,
    );
  }
}

enum AdminTalentListFilter { pending, approved, denied }

/// Admin talent endpoints from `useAdminTalent.ts`.
class AdminTalentApi extends BaseApi {
  AdminTalentApi(super.client);

  static String _listPath(AdminTalentListFilter filter) => switch (filter) {
        AdminTalentListFilter.pending => ApiConstants.adminTalentsPending,
        AdminTalentListFilter.approved => ApiConstants.adminTalentsApproved,
        AdminTalentListFilter.denied => ApiConstants.adminTalentsDenied,
      };

  Future<ApiResponse<List<dynamic>>> getList(AdminTalentListFilter filter) {
    return get(
      _listPath(filter),
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> approve(String talentId) {
    return patch(
      ApiConstants.adminTalentApprove(talentId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> deny(String talentId) {
    return patch(
      ApiConstants.adminTalentDeny(talentId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> markPending(String talentId) {
    return patch(
      ApiConstants.adminTalentPending(talentId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> assignSchedule(
    String talentId,
    Map<String, dynamic> payload,
  ) {
    return patch(
      ApiConstants.adminTalentSchedule(talentId),
      data: payload,
      mapData: mapJsonObject,
    );
  }
}
