import 'package:fuvekonmobile/core/api/dealer_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';

enum AdminDealerTab { pending, verified }

class AdminDealerService {
  AdminDealerService({required AdminDealerApi adminDealerApi})
      : _api = adminDealerApi;

  final AdminDealerApi _api;

  Future<List<AdminDealerItem>> getDealers(AdminDealerTab tab) async {
    final filter = AdminDealerFilter(
      isVerified: switch (tab) {
        AdminDealerTab.pending => false,
        AdminDealerTab.verified => true,
      },
      pageSize: 50,
    );

    try {
      final response = await _api.getDealers(filter);
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }
      return response.data!
          .whereType<Map<String, dynamic>>()
          .map(AdminDealerItem.fromJson)
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Không thể tải danh sách dealer.');
    }
  }

  Future<String> verifyDealer(String id) async {
    final response = await _api.verifyDealer(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.message;
  }

  Future<String> denyDealer(String id) async {
    final response = await _api.denyDealer(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.message;
  }
}
