import 'package:fuvekonmobile/core/api/lost_found_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';

class LostFoundPageMeta {
  const LostFoundPageMeta({
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.total,
  });

  factory LostFoundPageMeta.fromJson(Map<String, dynamic> json) {
    return LostFoundPageMeta(
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
      totalPages: json['total_pages'] as int? ?? 1,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  final int page;
  final int pageSize;
  final int totalPages;
  final int total;

  bool get hasMore => page < totalPages;
}

class LostFoundPageResult {
  const LostFoundPageResult({required this.items, required this.meta});

  final List<AdminLostFoundItem> items;
  final LostFoundPageMeta meta;
}

class CreateLostFoundInput {
  const CreateLostFoundInput({
    required this.itemType,
    required this.title,
    this.description = '',
    this.location = '',
    this.imageUrl = '',
    this.contactInfo = '',
    this.staffNotes = '',
  });

  final String itemType;
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final String contactInfo;
  final String staffNotes;

  Map<String, dynamic> toJson() => {
    'item_type': itemType,
    'title': title,
    if (description.isNotEmpty) 'description': description,
    if (location.isNotEmpty) 'location': location,
    if (imageUrl.isNotEmpty) 'image_url': imageUrl,
    if (contactInfo.isNotEmpty) 'contact_info': contactInfo,
    if (staffNotes.isNotEmpty) 'staff_notes': staffNotes,
  };
}

class UpdateLostFoundInput {
  const UpdateLostFoundInput({
    this.itemType,
    this.title,
    this.description,
    this.location,
    this.imageUrl,
    this.contactInfo,
    this.staffNotes,
  });

  final String? itemType;
  final String? title;
  final String? description;
  final String? location;
  final String? imageUrl;
  final String? contactInfo;
  final String? staffNotes;

  Map<String, dynamic> toJson() => {
    if (itemType != null) 'item_type': itemType,
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (location != null) 'location': location,
    if (imageUrl != null) 'image_url': imageUrl,
    if (contactInfo != null) 'contact_info': contactInfo,
    if (staffNotes != null) 'staff_notes': staffNotes,
  };
}

class ConfirmLostFoundReturnInput {
  const ConfirmLostFoundReturnInput({
    required this.verifiedDescription,
    required this.verifiedOwnership,
    required this.verifiedIdentity,
  });

  final bool verifiedDescription;
  final bool verifiedOwnership;
  final bool verifiedIdentity;

  Map<String, dynamic> toJson() => {
    'verified_description': verifiedDescription,
    'verified_ownership': verifiedOwnership,
    'verified_identity': verifiedIdentity,
  };
}

class AdminLostFoundService {
  AdminLostFoundService({required AdminLostFoundApi api}) : _api = api;

  final AdminLostFoundApi _api;

  Future<LostFoundPageResult> list({
    String? itemType,
    String? status,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _api.list(
        AdminLostFoundFilter(
          itemType: itemType,
          status: status,
          search: search,
          page: page,
          pageSize: pageSize,
        ),
      );
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }

      final data = response.data!;
      final rawItems = data['items'];
      final items = rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(AdminLostFoundItem.fromJson)
                .toList()
          : <AdminLostFoundItem>[];

      final meta = LostFoundPageMeta.fromJson(data);
      return LostFoundPageResult(items: items, meta: meta);
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Không thể tải danh sách thất lạc.');
    }
  }

  Future<AdminLostFoundItem> getById(String id) async {
    final response = await _api.getById(id);
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminLostFoundItem.fromJson(response.data!);
  }

  Future<AdminLostFoundItem> create(CreateLostFoundInput input) async {
    final response = await _api.create(input.toJson());
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminLostFoundItem.fromJson(response.data!);
  }

  Future<AdminLostFoundItem> update(
    String id,
    UpdateLostFoundInput input,
  ) async {
    final response = await _api.update(id, input.toJson());
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminLostFoundItem.fromJson(response.data!);
  }

  Future<AdminLostFoundItem> updateStatus(String id, String status) async {
    final response = await _api.updateStatus(id, status);
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminLostFoundItem.fromJson(response.data!);
  }

  Future<void> delete(String id) async {
    final response = await _api.deleteItem(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<AdminLostFoundItem> confirmReturn(
    String id,
    ConfirmLostFoundReturnInput input,
  ) async {
    final response = await _api.confirmReturn(id, input.toJson());
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminLostFoundItem.fromJson(response.data!);
  }
}
