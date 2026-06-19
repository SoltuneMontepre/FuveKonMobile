import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// Panel endpoints from `usePanel.ts`.
class PanelApi extends BaseApi {
  PanelApi(super.client);

  Future<ApiResponse<Map<String, dynamic>>> createPanel(
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.panels,
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<List<dynamic>>> getMyPanels() {
    return get(
      ApiConstants.panels,
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getById(String id) {
    return get(
      ApiConstants.panel(id),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updatePanel(
    String id,
    Map<String, dynamic> payload,
  ) {
    return put(
      ApiConstants.panel(id),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> deletePanel(String id) {
    return delete(
      ApiConstants.panel(id),
      mapData: mapJsonObject,
    );
  }
}

enum AdminPanelListFilter { pending, approved, requireChanges, denied }

/// Admin panel endpoints from `useAdminPanel.ts`.
class AdminPanelApi extends BaseApi {
  AdminPanelApi(super.client);

  static String _listPath(AdminPanelListFilter filter) => switch (filter) {
        AdminPanelListFilter.pending => ApiConstants.adminPanelsPending,
        AdminPanelListFilter.approved => ApiConstants.adminPanelsApproved,
        AdminPanelListFilter.requireChanges =>
          ApiConstants.adminPanelsRequireChanges,
        AdminPanelListFilter.denied => ApiConstants.adminPanelsDenied,
      };

  Future<ApiResponse<List<dynamic>>> getList(AdminPanelListFilter filter) {
    return get(
      _listPath(filter),
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> approve(String panelId) {
    return patch(
      ApiConstants.adminPanelApprove(panelId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> requireChanges(String panelId) {
    return patch(
      ApiConstants.adminPanelRequireChanges(panelId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> deny(String panelId) {
    return patch(
      ApiConstants.adminPanelDeny(panelId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> markPending(String panelId) {
    return patch(
      ApiConstants.adminPanelPending(panelId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> assignSchedule(
    String panelId,
    Map<String, dynamic> payload,
  ) {
    return patch(
      ApiConstants.adminPanelSchedule(panelId),
      data: payload,
      mapData: mapJsonObject,
    );
  }
}
