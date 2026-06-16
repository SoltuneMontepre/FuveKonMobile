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

/// Admin schedule CRUD and nested venue/event management.
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

  Future<ApiResponse<Map<String, dynamic>>> createVenue(
    String scheduleId,
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.adminScheduleVenues(scheduleId),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> createLocation(
    String scheduleId,
    String venueId,
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.adminScheduleVenueLocations(scheduleId, venueId),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> attachLocation(
    String scheduleId,
    String venueId,
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.adminScheduleAttachLocation(scheduleId, venueId),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateVenue(
    String scheduleId,
    String venueId,
    Map<String, dynamic> payload,
  ) {
    return put(
      ApiConstants.adminScheduleVenue(scheduleId, venueId),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<void>> deleteVenue(String scheduleId, String venueId) {
    return delete(
      ApiConstants.adminScheduleVenue(scheduleId, venueId),
      throwOnFailure: true,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> createEvent(
    String scheduleId,
    String venueId,
    String locationId,
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.adminScheduleEvent(scheduleId, venueId, locationId),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateEvent(
    String scheduleId,
    String venueId,
    String eventId,
    Map<String, dynamic> payload,
  ) {
    return put(
      ApiConstants.adminScheduleEventById(scheduleId, venueId, eventId),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<void>> deleteEvent(
    String scheduleId,
    String venueId,
    String eventId,
  ) {
    return delete(
      ApiConstants.adminScheduleEventById(scheduleId, venueId, eventId),
      throwOnFailure: true,
    );
  }
}

/// Global venue/location endpoints for schedule assembly.
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
