import 'package:fuvekonmobile/core/api/schedule_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_schedule_models.dart';

class AdminScheduleService {
  AdminScheduleService({
    required ScheduleApi scheduleApi,
    required AdminScheduleApi adminScheduleApi,
  }) : _scheduleApi = scheduleApi,
       _adminScheduleApi = adminScheduleApi;

  final ScheduleApi _scheduleApi;
  final AdminScheduleApi _adminScheduleApi;

  Future<List<AdminScheduleItem>> listSchedules() async {
    try {
      final response = await _scheduleApi.listSchedules();
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }
      return response.data!
          .whereType<Map<String, dynamic>>()
          .map(AdminScheduleItem.fromJson)
          .toList();
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Không thể tải danh sách lịch trình.');
    }
  }

  Future<AdminScheduleItem> getSchedule(String id) async {
    try {
      final response = await _scheduleApi.getSchedule(id);
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }
      return AdminScheduleItem.fromJson(response.data!);
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Không thể tải lịch trình.');
    }
  }

  Future<AdminScheduleItem> createSchedule(CreateScheduleInput input) async {
    final response = await _adminScheduleApi.createSchedule(input.toJson());
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminScheduleItem.fromJson(response.data!);
  }

  Future<AdminScheduleItem> updateSchedule(
    String id,
    UpdateScheduleInput input,
  ) async {
    final response = await _adminScheduleApi.updateSchedule(id, input.toJson());
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminScheduleItem.fromJson(response.data!);
  }

  Future<void> deleteSchedule(String id) async {
    final response = await _adminScheduleApi.deleteSchedule(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<AdminTimelineItem> createTimelineItem({
    required String scheduleId,
    required TimelineItemInput input,
  }) async {
    final response = await _adminScheduleApi.createTimelineItem(
      scheduleId,
      input.toJson(),
    );
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminTimelineItem.fromJson(response.data!);
  }

  Future<AdminTimelineItem> updateTimelineItem({
    required String scheduleId,
    required String itemId,
    required TimelineItemInput input,
  }) async {
    final response = await _adminScheduleApi.updateTimelineItem(
      scheduleId,
      itemId,
      input.toJson(),
    );
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminTimelineItem.fromJson(response.data!);
  }

  Future<void> deleteTimelineItem({
    required String scheduleId,
    required String itemId,
  }) async {
    final response = await _adminScheduleApi.deleteTimelineItem(
      scheduleId,
      itemId,
    );
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }
}
