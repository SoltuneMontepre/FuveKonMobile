import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// User ticket endpoints from `useTicket.ts`.
class TicketApi extends BaseApi {
  TicketApi(super.client);

  Future<ApiResponse<List<dynamic>>> getTiers() {
    return get(
      ApiConstants.ticketTiers,
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getTierById(String tierId) {
    return get(
      ApiConstants.ticketTier(tierId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>?>> getMyTicket() {
    return get(
      ApiConstants.ticketMe,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> purchaseTicket({
    required String tierId,
  }) {
    return post(
      ApiConstants.ticketPurchase,
      data: {'tier_id': tierId},
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> confirmPayment() {
    return patch(
      ApiConstants.ticketMeConfirm,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateBadgeDetails(
    Map<String, dynamic> payload,
  ) {
    return patch(
      ApiConstants.ticketMeBadge,
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateTshirtSize({
    required String tshirtSize,
  }) {
    return patch(
      ApiConstants.ticketMeTshirtSize,
      data: {'tshirt_size': tshirtSize},
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> upgradeTicket({
    required String newTierId,
  }) {
    return patch(
      ApiConstants.ticketMeUpgrade,
      data: {'new_tier_id': newTierId},
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> cancelTicket() {
    return delete(
      ApiConstants.ticketMeCancel,
      mapData: mapJsonObject,
    );
  }
}
