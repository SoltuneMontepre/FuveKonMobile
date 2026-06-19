import 'package:fuvekonmobile/core/api/notification_api.dart';
import 'package:fuvekonmobile/core/errors/failures.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/notification/data/models/notification_dto.dart';
import 'package:fuvekonmobile/features/notification/domain/entities/notification_item.dart';
import 'package:fuvekonmobile/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({required NotificationApi api}) : _api = api;

  final NotificationApi _api;

  @override
  Future<Result<List<NotificationItem>>> list() async {
    final response = await _api.list();
    if (!response.isSuccess) {
      return Error(ServerFailure(response.message));
    }

    final raw = response.data ?? const [];
    final items = raw
        .whereType<Map<String, dynamic>>()
        .map(NotificationDto.fromJson)
        .map((dto) => dto.toDomain())
        .toList();

    return Success(items);
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
