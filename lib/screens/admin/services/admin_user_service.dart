import 'package:fuvekonmobile/core/api/admin_user_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';

class PaginationMeta {
  const PaginationMeta({
    required this.currentPage,
    required this.pageSize,
    required this.totalPages,
    required this.totalItems,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
    );
  }

  final int currentPage;
  final int pageSize;
  final int totalPages;
  final int totalItems;

  bool get hasMore => currentPage < totalPages;
}

class AdminUserPageResult {
  const AdminUserPageResult({required this.items, required this.meta});

  final List<AdminUserItem> items;
  final PaginationMeta meta;
}

class AdminUpdateUserInput {
  const AdminUpdateUserInput({
    this.fursonaName,
    this.firstName,
    this.lastName,
    this.country,
    this.avatar,
    this.role,
    this.idCard,
    this.isVerified,
  });

  final String? fursonaName;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? avatar;
  final String? role;
  final String? idCard;
  final bool? isVerified;

  Map<String, dynamic> toJson() => {
        if (fursonaName != null) 'fursona_name': fursonaName,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (country != null) 'country': country,
        if (avatar != null) 'avatar': avatar,
        if (role != null) 'role': role,
        if (idCard != null) 'id_card': idCard,
        if (isVerified != null) 'is_verified': isVerified,
      };
}

class AdminUserService {
  AdminUserService({required AdminUserApi adminUserApi}) : _api = adminUserApi;

  final AdminUserApi _api;

  Future<AdminUserPageResult> getUsers({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    try {
      final response = await _api.getUsers(
        AdminUserFilter(page: page, pageSize: pageSize, search: search),
      );
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }

      final items = response.data!
          .whereType<Map<String, dynamic>>()
          .map(AdminUserItem.fromJson)
          .toList();

      final meta = response.meta is Map<String, dynamic>
          ? PaginationMeta.fromJson(response.meta as Map<String, dynamic>)
          : const PaginationMeta(
              currentPage: 1,
              pageSize: 20,
              totalPages: 1,
              totalItems: 0,
            );

      return AdminUserPageResult(items: items, meta: meta);
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Không thể tải danh sách người dùng.');
    }
  }

  Future<AdminUserPageResult> getBlacklistedUsers({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _api.getBlacklistedUsers(
        page: page,
        pageSize: pageSize,
      );
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }

      final items = response.data!
          .whereType<Map<String, dynamic>>()
          .map(AdminUserItem.fromBlacklistedJson)
          .toList();

      final meta = response.meta is Map<String, dynamic>
          ? PaginationMeta.fromJson(response.meta as Map<String, dynamic>)
          : const PaginationMeta(
              currentPage: 1,
              pageSize: 20,
              totalPages: 1,
              totalItems: 0,
            );

      return AdminUserPageResult(items: items, meta: meta);
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Không thể tải danh sách người bị cấm.');
    }
  }

  Future<AdminUserItem> getUserById(String id) async {
    final response = await _api.getUserById(id);
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminUserItem.fromJson(response.data!);
  }

  Future<AdminUserItem> updateUser(String id, AdminUpdateUserInput input) async {
    final response = await _api.updateUser(id, input.toJson());
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminUserItem.fromJson(response.data!);
  }

  Future<void> verifyUser(String id) async {
    final response = await _api.verifyUser(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<void> blacklistUser(String id, {required String reason}) async {
    final response = await _api.blacklistUser(id, reason: reason);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<void> unblacklistUser(String id) async {
    final response = await _api.unblacklistUser(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await _api.deleteUser(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }
}
