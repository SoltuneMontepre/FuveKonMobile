import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// Public schedule endpoints.
class ScheduleApi extends BaseApi {
  ScheduleApi(super.client);

  Future<ApiResponse<List<dynamic>>> listSchedules() {
    return get(
      ApiConstants.schedules,
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getSchedule(String id) {
    return get(
      ApiConstants.schedule(id),
      mapData: mapJsonObject,
    );
  }
}

/// Admin schedule CRUD and timeline management.
class AdminScheduleApi extends BaseApi {
  AdminScheduleApi(super.client);

  Future<ApiResponse<Map<String, dynamic>>> createSchedule(
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.adminSchedules,
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateSchedule(
    String id,
    Map<String, dynamic> payload,
  ) {
    return put(
      ApiConstants.adminSchedule(id),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<void>> deleteSchedule(String id) {
    return delete(
      ApiConstants.adminSchedule(id),
      throwOnFailure: true,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> createTimelineItem(
    String scheduleId,
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.adminScheduleTimeline(scheduleId),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateTimelineItem(
    String scheduleId,
    String itemId,
    Map<String, dynamic> payload,
  ) {
    return put(
      ApiConstants.adminScheduleTimelineItem(scheduleId, itemId),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<void>> deleteTimelineItem(
    String scheduleId,
    String itemId,
  ) {
    return delete(
      ApiConstants.adminScheduleTimelineItem(scheduleId, itemId),
      throwOnFailure: true,
    );
  }
}

/// Global venue/location endpoints.
class AdminVenueApi extends BaseApi {
  AdminVenueApi(super.client);

  Future<ApiResponse<List<dynamic>>> listVenues() {
    return get(
      ApiConstants.adminVenues,
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getVenue(String venueId) {
    return get(
      ApiConstants.adminVenue(venueId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<List<dynamic>>> listLocations(String venueId) {
    return get(
      ApiConstants.adminVenueLocations(venueId),
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> createVenue(
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.adminVenues,
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> createLocation(
    String venueId,
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.adminVenueLocations(venueId),
      data: payload,
      mapData: mapJsonObject,
    );
  }
}
