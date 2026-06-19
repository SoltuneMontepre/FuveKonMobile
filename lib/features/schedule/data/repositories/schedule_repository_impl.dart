import 'package:fuvekonmobile/core/api/schedule_api.dart';
import 'package:fuvekonmobile/core/errors/failures.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/schedule/data/mappers/schedule_mapper.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/itinerary_item.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_event.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/venue.dart';
import 'package:fuvekonmobile/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_schedule_models.dart';

/// Hybrid schedule repository: public schedule from API, venues from mock
/// delegate, itinerary stored locally against API-cached activities.
class ScheduleRepositoryImpl implements ScheduleRepository {
  ScheduleRepositoryImpl({
    required ScheduleApi scheduleApi,
    required ScheduleRepository venueDelegate,
  })  : _scheduleApi = scheduleApi,
        _venueDelegate = venueDelegate;

  final ScheduleApi _scheduleApi;
  final ScheduleRepository _venueDelegate;

  final Map<String, _ScheduleCache> _cacheByScheduleId = {};
  final List<ItineraryItem> _itinerary = [];
  String? _primaryScheduleId;

  @override
  Future<Result<List<ScheduleEvent>>> listScheduleEvents() async {
    final response = await _scheduleApi.listSchedules();
    if (!response.isSuccess) {
      return Error(ServerFailure(response.message));
    }

    final raw = response.data ?? const [];
    final events = <ScheduleEvent>[];
    for (final entry in raw.whereType<Map<String, dynamic>>()) {
      final adminItem = adminScheduleItemFromListEntry(entry);
      if (adminItem.id.isEmpty) continue;
      events.add(scheduleEventFromAdminItem(adminItem));
      _primaryScheduleId ??= adminItem.id;
    }

    if (events.isEmpty) {
      return const Error(ServerFailure('No schedule available'));
    }

    return Success(events);
  }

  @override
  Future<Result<ScheduleEvent>> getScheduleEvent(String id) async {
    final cached = _cacheByScheduleId[id];
    if (cached != null) {
      return Success(cached.event);
    }

    final response = await _scheduleApi.getSchedule(id);
    if (!response.isSuccess || response.data == null) {
      return Error(ServerFailure(response.message));
    }

    final adminItem = adminScheduleItemFromJson(response.data!);
    _storeScheduleDetail(adminItem);
    return Success(scheduleEventFromAdminItem(adminItem));
  }

  @override
  Future<Result<List<ScheduleActivity>>> listActivities({
    DateTime? day,
    String? venueId,
  }) async {
    final warmResult = await _ensurePrimaryScheduleCached();
    if (warmResult case Error(:final failure)) {
      return Error(failure);
    }

    final cache = _cacheForPrimary();
    if (cache == null) {
      return const Error(ServerFailure('No schedule available'));
    }

    var filtered = cache.activities;
    if (day != null) {
      filtered = filtered
          .where(
            (a) =>
                a.startAt.year == day.year &&
                a.startAt.month == day.month &&
                a.startAt.day == day.day,
          )
          .toList();
    }
    if (venueId != null && venueId.isNotEmpty) {
      filtered = filtered.where((a) => a.venueId == venueId).toList();
    }
    filtered.sort((a, b) => a.startAt.compareTo(b.startAt));
    return Success(filtered);
  }

  @override
  Future<Result<ScheduleActivity>> getActivity(String id) async {
    final warmResult = await _ensurePrimaryScheduleCached();
    if (warmResult case Error(:final failure)) {
      return Error(failure);
    }

    final activity = _cacheForPrimary()?.activitiesById[id];
    if (activity == null) {
      return const Error(ValidationFailure('Activity not found'));
    }
    return Success(activity);
  }

  @override
  Future<Result<List<Venue>>> listVenues() => _venueDelegate.listVenues();

  @override
  Future<Result<Venue>> getVenue(String id) => _venueDelegate.getVenue(id);

  @override
  Future<Result<List<ItineraryItem>>> getItinerary() async {
    final sorted = [..._itinerary]
      ..sort((a, b) => a.activity.startAt.compareTo(b.activity.startAt));
    return Success(sorted);
  }

  @override
  Future<Result<ScheduleActivity?>> findItineraryConflict(
    String activityId,
  ) async {
    final activityResult = await getActivity(activityId);
    final activity = switch (activityResult) {
      Success(:final data) => data,
      Error() => null,
    };
    if (activity == null) {
      return const Error(ValidationFailure('Activity not found'));
    }

    for (final item in _itinerary) {
      if (item.activityId == activityId) continue;
      if (activity.overlaps(item.activity)) {
        return Success(item.activity);
      }
    }
    return const Success(null);
  }

  @override
  Future<Result<ItineraryItem>> addToItinerary(
    String activityId, {
    bool replaceConflict = false,
  }) async {
    final activityResult = await getActivity(activityId);
    switch (activityResult) {
      case Error(:final failure):
        return Error(failure);
      case Success(:final data):
        final activity = data;
        if (_itinerary.any((i) => i.activityId == activityId)) {
          final existing =
              _itinerary.firstWhere((i) => i.activityId == activityId);
          return Success(existing);
        }

        ScheduleActivity? conflict;
        for (final item in _itinerary) {
          if (activity.overlaps(item.activity)) {
            conflict = item.activity;
            break;
          }
        }

        if (conflict != null && !replaceConflict) {
          return Error(ValidationFailure('Conflicts with "${conflict.title}"'));
        }

        if (conflict != null && replaceConflict) {
          _itinerary.removeWhere((i) => i.activityId == conflict!.id);
        }

        final item = ItineraryItem(
          id: 'it-$activityId-${DateTime.now().millisecondsSinceEpoch}',
          activityId: activityId,
          activity: activity,
          addedAt: DateTime.now(),
        );
        _itinerary.add(item);
        return Success(item);
    }
  }

  @override
  Future<Result<void>> removeFromItinerary(String activityId) async {
    _itinerary.removeWhere((i) => i.activityId == activityId);
    return const Success(null);
  }

  @override
  Future<Result<bool>> isInItinerary(String activityId) async {
    return Success(_itinerary.any((i) => i.activityId == activityId));
  }

  Future<Result<void>> _ensurePrimaryScheduleCached() async {
    if (_cacheForPrimary() != null) {
      return const Success(null);
    }

    if (_primaryScheduleId != null) {
      final result = await getScheduleEvent(_primaryScheduleId!);
      return switch (result) {
        Success() => const Success(null),
        Error(:final failure) => Error(failure),
      };
    }

    final listResult = await listScheduleEvents();
    switch (listResult) {
      case Error(:final failure):
        return Error(failure);
      case Success(:final data):
        if (data.isEmpty) {
          return const Error(ServerFailure('No schedule available'));
        }
        _primaryScheduleId ??= data.first.id;
        final detailResult = await getScheduleEvent(data.first.id);
        return switch (detailResult) {
          Success() => const Success(null),
          Error(:final failure) => Error(failure),
        };
    }
  }

  _ScheduleCache? _cacheForPrimary() {
    final id = _primaryScheduleId;
    if (id == null) return null;
    return _cacheByScheduleId[id];
  }

  void _storeScheduleDetail(AdminScheduleItem adminItem) {
    final activities = activitiesFromScheduleDetail(adminItem);
    final activitiesById = {
      for (final activity in activities) activity.id: activity,
    };
    _cacheByScheduleId[adminItem.id] = _ScheduleCache(
      event: scheduleEventFromAdminItem(adminItem),
      activities: activities,
      activitiesById: activitiesById,
    );
    _primaryScheduleId = adminItem.id;
  }
}

class _ScheduleCache {
  const _ScheduleCache({
    required this.event,
    required this.activities,
    required this.activitiesById,
  });

  final ScheduleEvent event;
  final List<ScheduleActivity> activities;
  final Map<String, ScheduleActivity> activitiesById;
}
