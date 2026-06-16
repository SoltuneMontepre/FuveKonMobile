import 'package:fuvekonmobile/core/api/lost_found_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/screens/info/lost_found_models.dart';

class LostFoundService {
  LostFoundService({required LostFoundApi api}) : _api = api;

  final LostFoundApi _api;

  Future<LostFoundPageResult> list({
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _api.list(
        LostFoundFilter(search: search, page: page, pageSize: pageSize),
      );
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }

      final data = response.data!;
      final rawItems = data['items'];
      final items = rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(LostFoundPublicItem.fromJson)
              .toList()
          : <LostFoundPublicItem>[];

      return LostFoundPageResult(
        items: items,
        meta: LostFoundPageMeta.fromJson(data),
      );
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Không thể tải danh sách đồ thất lạc.');
    }
  }

  Future<void> claim(String id, {String message = ''}) async {
    final response = await _api.claim(id, message: message);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }
}

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

  final List<LostFoundPublicItem> items;
  final LostFoundPageMeta meta;
}
