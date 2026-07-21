import 'package:fuvekonmobile/core/api/talent_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_panel_service.dart'
    show AdminApprovalTab;

class AdminTalentService {
  AdminTalentService({required AdminTalentApi adminTalentApi})
    : _api = adminTalentApi;

  final AdminTalentApi _api;

  AdminTalentListFilter _filter(AdminApprovalTab tab) => switch (tab) {
    AdminApprovalTab.pending => AdminTalentListFilter.pending,
    AdminApprovalTab.approved => AdminTalentListFilter.approved,
    AdminApprovalTab.requireChanges => AdminTalentListFilter.requireChanges,
    AdminApprovalTab.denied => AdminTalentListFilter.denied,
  };

  Future<List<AdminTalentItem>> getTalents(AdminApprovalTab tab) async {
    try {
      final response = await _api.getList(_filter(tab));
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }
      return response.data!
          .whereType<Map<String, dynamic>>()
          .map(AdminTalentItem.fromJson)
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Không thể tải danh sách talent.');
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
