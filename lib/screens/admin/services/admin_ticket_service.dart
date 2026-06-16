import 'package:fuvekonmobile/core/api/admin_ticket_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_user_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_tier_management_widgets.dart';

enum AdminTicketTab { all, pendingReview, approved, denied }

extension AdminTicketTabX on AdminTicketTab {
  String? get statusFilter => switch (this) {
        AdminTicketTab.all => null,
        AdminTicketTab.pendingReview => TicketStatus.selfConfirmed.apiValue,
        AdminTicketTab.approved => TicketStatus.approved.apiValue,
        AdminTicketTab.denied => TicketStatus.denied.apiValue,
      };
}

class AdminTicketPageResult {
  const AdminTicketPageResult({required this.items, required this.meta});

  final List<AdminTicketItem> items;
  final PaginationMeta meta;
}

class AdminTicketUpdateInput {
  const AdminTicketUpdateInput({
    this.status,
    this.tierId,
    this.conBadgeName,
    this.badgeImage,
    this.namecardUrl,
    this.isFursuiter,
    this.isFursuitStaff,
    this.isCheckedIn,
    this.tshirtSize,
    this.denialReason,
  });

  final String? status;
  final String? tierId;
  final String? conBadgeName;
  final String? badgeImage;
  final String? namecardUrl;
  final bool? isFursuiter;
  final bool? isFursuitStaff;
  final bool? isCheckedIn;
  final String? tshirtSize;
  final String? denialReason;

  Map<String, dynamic> toJson() => {
        if (status != null) 'status': status,
        if (tierId != null) 'tier_id': tierId,
        if (conBadgeName != null) 'con_badge_name': conBadgeName,
        if (badgeImage != null) 'badge_image': badgeImage,
        if (namecardUrl != null) 'namecard_url': namecardUrl,
        if (isFursuiter != null) 'is_fursuiter': isFursuiter,
        if (isFursuitStaff != null) 'is_fursuit_staff': isFursuitStaff,
        if (isCheckedIn != null) 'is_checked_in': isCheckedIn,
        if (tshirtSize != null) 'tshirt_size': tshirtSize,
        if (denialReason != null) 'denial_reason': denialReason,
      };
}

class AdminTicketTierInput {
  const AdminTicketTierInput({
    required this.ticketName,
    this.description = '',
    this.benefits = const [],
    required this.price,
    this.priceUsd,
    required this.stock,
    this.isActive = true,
  });

  final String ticketName;
  final String description;
  final List<String> benefits;
  final double price;
  final double? priceUsd;
  final int stock;
  final bool isActive;

  Map<String, dynamic> toCreateJson() => {
        'ticket_name': ticketName,
        'description': description,
        'benefits': benefits,
        'price': price,
        if (priceUsd != null) 'price_usd': priceUsd,
        'stock': stock,
        'is_active': isActive,
      };

  Map<String, dynamic> toUpdateJson() => {
        'ticket_name': ticketName,
        'description': description,
        'benefits': benefits,
        'price': price,
        if (priceUsd != null) 'price_usd': priceUsd,
        'stock': stock,
        'is_active': isActive,
      };
}

class AdminTicketService {
  AdminTicketService({required AdminTicketApi adminTicketApi})
      : _api = adminTicketApi;

  final AdminTicketApi _api;

  Future<AdminTicketPageResult> getTickets({
    required AdminTicketTab tab,
    int page = 1,
    int pageSize = 20,
    String? search,
    bool pendingOver24 = false,
    String? tierId,
  }) async {
    try {
      final response = await _api.getTickets(
        AdminTicketFilter(
          status: tab.statusFilter,
          search: search?.isNotEmpty == true ? search : null,
          pendingOver24: pendingOver24 ? true : null,
          tierId: tierId,
          page: page,
          pageSize: pageSize,
        ),
      );
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }

      final items = response.data!
          .whereType<Map<String, dynamic>>()
          .map(AdminTicketItem.fromJson)
          .toList();

      final meta = response.meta is Map<String, dynamic>
          ? PaginationMeta.fromJson(response.meta as Map<String, dynamic>)
          : const PaginationMeta(
              currentPage: 1,
              pageSize: 20,
              totalPages: 1,
              totalItems: 0,
            );

      return AdminTicketPageResult(items: items, meta: meta);
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Không thể tải danh sách vé.');
    }
  }

  Future<List<AdminTicketTierItem>> getTiers() async {
    try {
      final response = await _api.getAdminTiers();
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }
      return response.data!
          .whereType<Map<String, dynamic>>()
          .map(AdminTicketTierItem.fromJson)
          .toList();
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Không thể tải danh sách hạng vé.');
    }
  }

  Future<void> approveTicket(String id) async {
    final response = await _api.approveTicket(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<void> denyTicket(String id, {String? reason}) async {
    final response = await _api.denyTicket(id, reason: reason);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<void> resendQrEmail(String id) async {
    final response = await _api.resendQrEmail(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<AdminTicketItem?> findActiveUserTicket({
    required String userId,
    required String email,
  }) async {
    final result = await getTickets(
      tab: AdminTicketTab.all,
      search: email,
      pageSize: 20,
    );
    for (final item in result.items) {
      if (item.userId == userId && item.status != TicketStatus.denied) {
        return item;
      }
    }
    return null;
  }

  Future<AdminTicketItem> getTicketById(String id) async {
    try {
      final response = await _api.getTicketById(id);
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }
      return AdminTicketItem.fromJson(response.data!);
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Không thể tải thông tin vé.');
    }
  }

  Future<AdminTicketItem> createTicketForUser({
    required String userId,
    required String tierId,
  }) async {
    final response = await _api.createTicket(
      userId: userId,
      tierId: tierId,
    );
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminTicketItem.fromJson(response.data!);
  }

  Future<AdminTicketItem> updateTicket(
    String id,
    AdminTicketUpdateInput input,
  ) async {
    final response = await _api.updateTicket(id, input.toJson());
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminTicketItem.fromJson(response.data!);
  }

  Future<void> deleteTicket(String id) async {
    final response = await _api.deleteTicket(id);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<void> activateTier(String tierId) async {
    final response = await _api.activateTier(tierId);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<void> deactivateTier(String tierId) async {
    final response = await _api.deactivateTier(tierId);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<void> setTierVisibility(String tierId, {required bool visible}) async {
    final response = await _api.setTierVisibility(tierId, visible: visible);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<AdminTicketTierItem> createTier(AdminTicketTierInput input) async {
    final response = await _api.createTier(input.toCreateJson());
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminTicketTierItem.fromJson(response.data!);
  }

  Future<AdminTicketTierItem> updateTier(
    String tierId,
    AdminTicketTierInput input,
  ) async {
    final response = await _api.updateTier(tierId, input.toUpdateJson());
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return AdminTicketTierItem.fromJson(response.data!);
  }

  Future<void> deleteTier(String tierId) async {
    final response = await _api.deleteTier(tierId);
    if (!response.isSuccess) {
      throw ServerException(response.errorMessage ?? response.message);
    }
  }

  Future<AdminTicketOverviewStats> getStatistics() async {
    try {
      final response = await _api.getStatistics();
      if (!response.isSuccess || response.data == null) {
        throw ServerException(response.errorMessage ?? response.message);
      }
      return AdminTicketOverviewStats.fromJson(response.data!);
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Không thể tải thống kê vé.');
    }
  }
}
