import 'package:fuvekonmobile/core/api/notification_api.dart';
import 'package:fuvekonmobile/core/errors/failures.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/models/pagination_meta.dart';
import 'package:fuvekonmobile/features/notification/data/models/notification_dto.dart';
import 'package:fuvekonmobile/features/notification/domain/entities/notification_item.dart';
import 'package:fuvekonmobile/features/notification/domain/entities/notification_page_result.dart';
import 'package:fuvekonmobile/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({required NotificationApi api}) : _api = api;

  final NotificationApi _api;

  @override
  Future<Result<NotificationPageResult>> list({
    int page = 1,
    int pageSize = 20,
    String? kind,
    bool unreadOnly = false,
  }) async {
    final response = await _api.list(
      page: page,
      pageSize: pageSize,
      kind: kind,
      unreadOnly: unreadOnly,
    );
    if (!response.isSuccess) {
      return Error(ServerFailure(response.message));
    }

    final raw = response.data ?? const [];
    final items = raw
        .whereType<Map<String, dynamic>>()
        .map(NotificationDto.fromJson)
        .map((dto) => dto.toDomain())
        .toList();

    final meta = response.meta is Map<String, dynamic>
        ? PaginationMeta.fromJson(response.meta as Map<String, dynamic>)
        : PaginationMeta(
            currentPage: page,
            pageSize: pageSize,
            totalPages: items.isEmpty ? page : page + 1,
            totalItems: items.length,
          );

    return Success(NotificationPageResult(items: items, meta: meta));
  }

  @override
  Future<Result<int>> unreadCount() async {
    final response = await _api.unreadCount();
    if (!response.isSuccess || response.data == null) {
      return Error(ServerFailure(response.message));
    }
    final count = (response.data!['count'] as num?)?.toInt() ?? 0;
    return Success(count);
  }

  @override
  Future<Result<int>> markAllRead() async {
    final response = await _api.markAllRead();
    if (!response.isSuccess || response.data == null) {
      return Error(ServerFailure(response.message));
    }
    final updated = (response.data!['updated'] as num?)?.toInt() ?? 0;
    return Success(updated);
  }

  @override
  Future<Result<NotificationItem>> getById(String id) async {
    final response = await _api.getById(id);
    if (!response.isSuccess || response.data == null) {
      return Error(ServerFailure(response.message));
    }

    return Success(NotificationDto.fromJson(response.data!).toDomain());
  }

  @override
  Future<Result<NotificationItem>> markAsRead(String id) async {
    final response = await _api.markAsRead(id);
    if (!response.isSuccess || response.data == null) {
      return Error(ServerFailure(response.message));
    }

    return Success(NotificationDto.fromJson(response.data!).toDomain());
  }
}
