import 'package:fuvekonmobile/core/api/schedule_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_schedule_models.dart';

class AdminScheduleService {
  AdminScheduleService({
    required ScheduleApi scheduleApi,
    required AdminScheduleApi adminScheduleApi,
  })  : _scheduleApi = scheduleApi,
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
    final response =
        await _adminScheduleApi.updateSchedule(id, input.toJson());
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

  Future<AdminScheduleVenue> createVenue({
    required String scheduleId,
    required CreateScheduleVenueInput input,
  }) async {
    final response =
        await _adminScheduleApi.createVenue(scheduleId, input.toJson());
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminScheduleVenue.fromJson(response.data!);
  }

  Future<AdminScheduleLocation> createLocation({
    required String scheduleId,
    required String venueId,
    required CreateScheduleLocationInput input,
  }) async {
    final response = await _adminScheduleApi.createLocation(
      scheduleId,
      venueId,
      input.toJson(),
    );
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminScheduleLocation.fromJson(response.data!);
  }

  /// Ensures a default venue and location exist so events can be added directly.
  Future<({AdminScheduleVenue venue, AdminScheduleLocation location})>
      ensureDefaultVenueAndLocation(String scheduleId) async {
    final venue = await createVenue(
      scheduleId: scheduleId,
      input: const CreateScheduleVenueInput(name: 'Sự kiện'),
    );
    final location = await createLocation(
      scheduleId: scheduleId,
      venueId: venue.id,
      input: const CreateScheduleLocationInput(name: 'Chung'),
    );
    return (venue: venue, location: location);
  }

  Future<AdminScheduleEvent> createEvent({
    required String scheduleId,
    required String venueId,
    required String locationId,
    required EventInput input,
  }) async {
    final response = await _adminScheduleApi.createEvent(
      scheduleId,
      venueId,
      locationId,
      input.toJson(),
    );
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminScheduleEvent.fromJson(response.data!);
  }

  Future<AdminScheduleEvent> updateEvent({
    required String scheduleId,
    required String venueId,
    required String eventId,
    required EventInput input,
  }) async {
    final response = await _adminScheduleApi.updateEvent(
      scheduleId,
      venueId,
      eventId,
      input.toJson(),
    );
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminScheduleEvent.fromJson(response.data!);
  }

  Future<void> deleteEvent({
    required String scheduleId,
    required String venueId,
    required String eventId,
  }) async {
    final response = await _adminScheduleApi.deleteEvent(
      scheduleId,
      venueId,
      eventId,
    );
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<void> deleteVenue({
    required String scheduleId,
    required String venueId,
  }) async {
    final response =
        await _adminScheduleApi.deleteVenue(scheduleId, venueId);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }
}
