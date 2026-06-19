import 'package:fuvekonmobile/core/api/panel_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';

enum AdminApprovalTab { pending, approved, requireChanges, denied }

class AdminPanelService {
  AdminPanelService({required AdminPanelApi adminPanelApi}) : _api = adminPanelApi;

  final AdminPanelApi _api;

  AdminPanelListFilter _filter(AdminApprovalTab tab) => switch (tab) {
        AdminApprovalTab.pending => AdminPanelListFilter.pending,
        AdminApprovalTab.approved => AdminPanelListFilter.approved,
        AdminApprovalTab.requireChanges => AdminPanelListFilter.requireChanges,
        AdminApprovalTab.denied => AdminPanelListFilter.denied,
      };

  Future<List<AdminPanelItem>> getPanels(AdminApprovalTab tab) async {
    try {
      final response = await _api.getList(_filter(tab));
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }
      return response.data!
          .whereType<Map<String, dynamic>>()
          .map(AdminPanelItem.fromJson)
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Không thể tải danh sách panel.');
    }
  }

  Future<String> approve(String id) async {
    final response = await _api.approve(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.message;
  }

  Future<String> requireChanges(String id) async {
    final response = await _api.requireChanges(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.message;
  }

  Future<String> deny(String id) async {
    final response = await _api.deny(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.message;
  }

  Future<String> markPending(String id) async {
    final response = await _api.markPending(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.message;
  }
}
