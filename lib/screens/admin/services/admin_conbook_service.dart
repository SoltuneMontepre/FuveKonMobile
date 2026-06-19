import 'package:fuvekonmobile/core/api/conbook_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_panel_service.dart';

class AdminConbookService {
  AdminConbookService({required ConbookApi conbookApi}) : _api = conbookApi;

  final ConbookApi _api;

  Future<List<AdminConbookItem>> getConbooks(AdminApprovalTab tab) async {
    final status = switch (tab) {
      AdminApprovalTab.pending => 'pending',
      AdminApprovalTab.approved => 'approved',
      AdminApprovalTab.requireChanges => 'require-changes',
      AdminApprovalTab.denied => 'denied',
    };

    try {
      final response = await _api.getAdminSubmissions(
        AdminConbookFilter(status: status, pageSize: 50),
      );
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }
      return response.data!
          .whereType<Map<String, dynamic>>()
          .map(AdminConbookItem.fromJson)
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Không thể tải danh sách conbook.');
    }
  }

  Future<String> approve(String id) async {
    final response = await _api.approveByAdmin(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.message;
  }

  Future<String> requireChanges(String id) async {
    final response = await _api.requireChangesByAdmin(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.message;
  }

  Future<String> deny(String id) async {
    final response = await _api.denyByAdmin(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.message;
  }

  Future<String> markPending(String id) async {
    final response = await _api.setPendingByAdmin(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.message;
  }
}
