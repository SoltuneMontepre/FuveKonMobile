import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

class EventApi extends BaseApi {
  EventApi(super.client);

  Future<ApiResponse<Map<String, dynamic>>> getAdminSettings() {
    return get(ApiConstants.adminEventSettings, mapData: mapJsonObject);
  }

  Future<ApiResponse<Map<String, dynamic>>> setTicketSalesOpen(bool open) {
    return post(
      open
          ? ApiConstants.adminEventTicketSalesOpen
          : ApiConstants.adminEventTicketSalesClose,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> setPanelRegistrationOpen(
    bool open,
  ) {
    return post(
      open
          ? ApiConstants.adminEventPanelRegistrationOpen
          : ApiConstants.adminEventPanelRegistrationClose,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> setTalentRegistrationOpen(
    bool open,
  ) {
    return post(
      open
          ? ApiConstants.adminEventTalentRegistrationOpen
          : ApiConstants.adminEventTalentRegistrationClose,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> setDealerRegistrationOpen(
    bool open,
  ) {
    return post(
      open
          ? ApiConstants.adminEventDealerRegistrationOpen
          : ApiConstants.adminEventDealerRegistrationClose,
      mapData: mapJsonObject,
    );
  }
}
