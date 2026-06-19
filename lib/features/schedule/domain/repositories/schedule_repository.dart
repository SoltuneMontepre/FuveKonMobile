import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/itinerary_item.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_event.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/venue.dart';

abstract interface class ScheduleRepository {
  Future<Result<List<ScheduleEvent>>> listScheduleEvents();

  Future<Result<ScheduleEvent>> getScheduleEvent(String id);

  Future<Result<List<ScheduleActivity>>> listActivities({
    DateTime? day,
    String? venueId,
  });

  Future<Result<ScheduleActivity>> getActivity(String id);

  Future<Result<List<Venue>>> listVenues();

  Future<Result<Venue>> getVenue(String id);

  Future<Result<List<ItineraryItem>>> getItinerary();

  Future<Result<ScheduleActivity?>> findItineraryConflict(String activityId);

  Future<Result<ItineraryItem>> addToItinerary(
    String activityId, {
    bool replaceConflict = false,
  });

  Future<Result<void>> removeFromItinerary(String activityId);

  Future<Result<bool>> isInItinerary(String activityId);
}
