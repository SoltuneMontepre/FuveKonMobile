import 'package:fuvekonmobile/core/api/schedule_api.dart';
import 'package:fuvekonmobile/core/errors/failures.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/itinerary_item.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_event.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/venue.dart';
import 'package:fuvekonmobile/features/schedule/domain/repositories/schedule_repository.dart';

/// Stub implementation wrapping [ScheduleApi] until customer endpoints are ready.
class ScheduleRepositoryImpl implements ScheduleRepository {
  ScheduleRepositoryImpl({required ScheduleApi scheduleApi})
      : _scheduleApi = scheduleApi;

  final ScheduleApi _scheduleApi;

  static const _notWired = ServerFailure(
    'Schedule customer API is not wired yet. Use mock repository.',
  );

  @override
  Future<Result<List<ScheduleEvent>>> listScheduleEvents() async {
    final response = await _scheduleApi.listSchedules();
    if (!response.isSuccess) {
      return Error(ServerFailure(response.message));
    }
    // TODO: map JSON to ScheduleEvent when API contract is finalized.
    return const Error(_notWired);
  }

  @override
  Future<Result<ScheduleEvent>> getScheduleEvent(String id) async {
    final response = await _scheduleApi.getSchedule(id);
    if (!response.isSuccess) {
      return Error(ServerFailure(response.message));
    }
    return const Error(_notWired);
  }

  @override
  Future<Result<List<ScheduleActivity>>> listActivities({
    DateTime? day,
    String? venueId,
  }) async {
    return const Error(_notWired);
  }

  @override
  Future<Result<ScheduleActivity>> getActivity(String id) async {
    return const Error(_notWired);
  }

  @override
  Future<Result<List<Venue>>> listVenues() async {
    return const Error(_notWired);
  }

  @override
  Future<Result<Venue>> getVenue(String id) async {
    return const Error(_notWired);
  }

  @override
  Future<Result<List<ItineraryItem>>> getItinerary() async {
    return const Error(_notWired);
  }

  @override
  Future<Result<ScheduleActivity?>> findItineraryConflict(String activityId) async {
    return const Error(_notWired);
  }

  @override
  Future<Result<ItineraryItem>> addToItinerary(
    String activityId, {
    bool replaceConflict = false,
  }) async {
    return const Error(_notWired);
  }

  @override
  Future<Result<void>> removeFromItinerary(String activityId) async {
    return const Error(_notWired);
  }

  @override
  Future<Result<bool>> isInItinerary(String activityId) async {
    return const Error(_notWired);
  }
}
