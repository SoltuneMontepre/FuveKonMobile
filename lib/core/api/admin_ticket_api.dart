import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// Admin ticket filters matching `AdminTicketFilter` in `useAdminTicket.ts`.
class AdminTicketFilter {
  const AdminTicketFilter({
    this.status,
    this.tierId,
    this.search,
    this.pendingOver24,
    this.page,
    this.pageSize,
  });

  final String? status;
  final String? tierId;
  final String? search;
  final bool? pendingOver24;
  final int? page;
  final int? pageSize;

  Map<String, dynamic> toQuery() => buildQuery({
        if (status != null) 'status': status,
        if (tierId != null) 'tier_id': tierId,
        if (search != null) 'search': search,
        if (pendingOver24 == true) 'pending_over_24': 'true',
        if (page != null) 'page': page,
        if (pageSize != null) 'page_size': pageSize,
      });
}

/// Admin ticket endpoints from `useAdminTicket.ts`.
class AdminTicketApi extends BaseApi {
  AdminTicketApi(super.client);

  Future<ApiResponse<List<dynamic>>> getTickets([
    AdminTicketFilter filter = const AdminTicketFilter(),
  ]) {
    return get(
      ApiConstants.adminTickets,
      queryParameters: filter.toQuery(),
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getStatistics() {
    return get(
      ApiConstants.adminTicketStatistics,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<List<dynamic>>> getSalesTimeline({int days = 90}) {
    return get(
      ApiConstants.adminTicketSalesTimeline,
      queryParameters: buildQuery({'days': days}),
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getRevenue({int days = 0}) {
    return get(
      ApiConstants.adminTicketRevenue,
      queryParameters: days > 0 ? buildQuery({'days': days}) : null,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getTicketById(String ticketId) {
    return get(
      ApiConstants.adminTicket(ticketId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> approveTicket(String ticketId) {
    return patch(
      ApiConstants.adminTicketApprove(ticketId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> denyTicket(
    String ticketId, {
    String? reason,
  }) {
    return patch(
      ApiConstants.adminTicketDeny(ticketId),
      data: {'reason': reason ?? ''},
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<void>> resendQrEmail(String ticketId) {
    return post<void>(ApiConstants.adminTicketResendQr(ticketId));
  }

  Future<ApiResponse<Map<String, dynamic>>> confirmCheckIn(
    String ticketIdOrRef,
  ) {
    return patch(
      ApiConstants.adminTicketCheckIn(ticketIdOrRef),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> createTicket({
    required String userId,
    required String tierId,
  }) {
    return post(
      ApiConstants.adminTickets,
      data: {'user_id': userId, 'tier_id': tierId},
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<List<dynamic>>> getAdminTiers() {
    return get(
      ApiConstants.adminTicketTiers,
      mapData: mapJsonList,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> createTier(
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.adminTicketTiers,
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateTier(
    String tierId,
    Map<String, dynamic> payload,
  ) {
    return patch(
      ApiConstants.adminTicketTier(tierId),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<void>> deleteTier(String tierId) {
    return delete<void>(ApiConstants.adminTicketTier(tierId));
  }

  Future<ApiResponse<Map<String, dynamic>>> activateTier(String tierId) {
    return patch(
      ApiConstants.adminTicketTierActivate(tierId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> deactivateTier(String tierId) {
    return patch(
      ApiConstants.adminTicketTierDeactivate(tierId),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> setTierVisibility(
    String tierId, {
    required bool visible,
  }) {
    return patch(
      ApiConstants.adminTicketTierVisibility(tierId, visible),
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> updateTicket(
    String ticketId,
    Map<String, dynamic> payload,
  ) {
    return patch(
      ApiConstants.adminTicket(ticketId),
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> deleteTicket(String ticketId) {
    return delete(
      ApiConstants.adminTicket(ticketId),
      mapData: mapJsonObject,
    );
  }
}
