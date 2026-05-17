import 'package:fuvekonmobile/core/api/ticket_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/purchase_ticket_result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/update_badge_details_input.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';

abstract interface class TicketRemoteDataSource {
  Future<List<TicketTier>> getTiers();

  Future<UserTicket?> getMyTicket();

  Future<PurchaseTicketResult> purchaseTicket(String tierId);

  Future<UserTicket> confirmPayment();

  Future<UserTicket> updateBadgeDetails(UpdateBadgeDetailsInput input);
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  TicketRemoteDataSourceImpl({required TicketApi ticketApi})
      : _ticketApi = ticketApi;

  final TicketApi _ticketApi;

  @override
  Future<List<TicketTier>> getTiers() async {
    final response = await _ticketApi.getTiers();
    final list = response.data ?? [];
    return list
        .whereType<Map>()
        .map((e) => _mapTier(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<UserTicket?> getMyTicket() async {
    final response = await _ticketApi.getMyTicket();
    final data = response.data;
    if (data == null) return null;
    return _mapUserTicket(data);
  }

  @override
  Future<PurchaseTicketResult> purchaseTicket(String tierId) async {
    final response = await _ticketApi.purchaseTicket(tierId: tierId);
    final data = response.data;
    return PurchaseTicketResult(
      ticket: data != null ? _mapUserTicket(data) : null,
      queued: response.statusCode == 202,
      statusCode: response.statusCode,
    );
  }

  @override
  Future<UserTicket> confirmPayment() async {
    final response = await _ticketApi.confirmPayment();
    final data = response.data;
    if (data == null) {
      throw const ServerException('Failed to confirm payment.');
    }
    return _mapUserTicket(data);
  }

  @override
  Future<UserTicket> updateBadgeDetails(UpdateBadgeDetailsInput input) async {
    final response = await _ticketApi.updateBadgeDetails(input.toPayload());
    final data = response.data;
    if (data == null) {
      throw const ServerException('Failed to update name card.');
    }
    return _mapUserTicket(data);
  }

  TicketTier _mapTier(Map<String, dynamic> json) {
    final benefitsRaw = json['benefits'];
    final benefits = benefitsRaw is List
        ? benefitsRaw.map((e) => e.toString()).toList()
        : <String>[];

    return TicketTier(
      id: json['id']?.toString() ?? '',
      tierCode: json['tier_code'] as String? ?? '',
      ticketName: json['ticket_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      benefits: benefits,
      price: _parseDecimal(json['price']),
      priceUsd: _parseOptionalDecimal(json['price_usd']),
      isSoldOut: json['is_sold_out'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? false,
    );
  }

  UserTicket _mapUserTicket(Map<String, dynamic> json) {
    final tierJson = json['tier'];
    final status = TicketStatus.fromApi(json['status'] as String?) ??
        TicketStatus.pending;

    return UserTicket(
      id: json['id']?.toString() ?? '',
      referenceCode: json['reference_code'] as String? ?? '',
      status: status,
      ticketNumber: json['ticket_number'] as int? ?? 0,
      conBadgeName: json['con_badge_name'] as String?,
      badgeImage: json['badge_image'] as String?,
      namecardUrl: json['namecard_url'] as String?,
      isFursuiter: json['is_fursuiter'] as bool? ?? false,
      isFursuitStaff: json['is_fursuit_staff'] as bool? ?? false,
      isCheckedIn: json['is_checked_in'] as bool? ?? false,
      tshirtSize: json['tshirt_size'] as String?,
      denialReason: json['denial_reason'] as String?,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      previousReferenceCode: json['previous_reference_code'] as String?,
      tier: tierJson is Map
          ? _mapTier(Map<String, dynamic>.from(tierJson))
          : null,
    );
  }

  double _parseDecimal(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  double? _parseOptionalDecimal(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    final parsed = double.tryParse(value.toString());
    return parsed;
  }
}
