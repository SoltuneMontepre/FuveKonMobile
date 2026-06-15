import 'package:fuvekonmobile/core/api/admin_ticket_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/shared/services/scan_session_store.dart';

class ScanTicketResult {
  const ScanTicketResult({
    required this.outcome,
    required this.code,
    required this.message,
    this.holderName,
    this.tierName,
    this.referenceCode,
    this.canCheckIn = false,
    this.idCard,
    this.badgeName,
    this.avatarUrl,
    this.badgeImage,
    this.namecardUrl,
    this.tierCode,
    this.isFursuiter = false,
    this.isFursuitStaff = false,
    this.isDealer = false,
  });

  final ScanOutcome outcome;
  final String code;
  final String message;
  final String? holderName;
  final String? tierName;
  final String? referenceCode;

  /// True when the ticket is eligible and staff must confirm check-in.
  final bool canCheckIn;

  final String? idCard;
  final String? badgeName;
  final String? avatarUrl;
  final String? badgeImage;
  final String? namecardUrl;
  final String? tierCode;
  final bool isFursuiter;
  final bool isFursuitStaff;
  final bool isDealer;
}

class ScanTicketService {
  ScanTicketService({
    required AdminTicketApi adminTicketApi,
    required ScanSessionStore sessionStore,
  })  : _adminTicketApi = adminTicketApi,
        _sessionStore = sessionStore;

  final AdminTicketApi _adminTicketApi;
  final ScanSessionStore _sessionStore;

  /// Looks up a ticket by scanned code without performing check-in.
  Future<ScanTicketResult> lookupCode(String rawCode) async {
    final code = _normalizeCode(rawCode);
    if (code.isEmpty) {
      return _recordAndReturn(
        code: rawCode,
        outcome: ScanOutcome.rejected,
        message: 'Mã vé không hợp lệ.',
      );
    }

    Map<String, dynamic>? ticket;
    try {
      final lookup = await _adminTicketApi.getTicketById(code);
      if (!lookup.isSuccess || lookup.data == null) {
        return _recordAndReturn(
          code: code,
          outcome: ScanOutcome.rejected,
          message: lookup.errorMessage ?? lookup.message,
        );
      }
      ticket = lookup.data;
    } on ServerException catch (e) {
      return _recordAndReturn(
        code: code,
        outcome: ScanOutcome.rejected,
        message: e.message,
      );
    }

    final status = TicketStatus.fromApi(ticket!['status'] as String?);
    final details = _parseDetails(ticket, fallbackCode: code);

    if (status == TicketStatus.denied ||
        status == TicketStatus.pending ||
        status == TicketStatus.selfConfirmed) {
      return _recordAndReturn(
        code: details.referenceCode,
        outcome: ScanOutcome.rejected,
        message: 'Vé chưa được duyệt hoặc đã bị từ chối.',
        details: details,
      );
    }

    if (details.isCheckedIn) {
      return _recordAndReturn(
        code: details.referenceCode,
        outcome: ScanOutcome.reused,
        message: 'Vé đã được check-in trước đó.',
        details: details,
      );
    }

    return ScanTicketResult(
      outcome: ScanOutcome.valid,
      code: details.referenceCode,
      referenceCode: details.referenceCode,
      message: 'Xác nhận thông tin vé trước khi check-in.',
      holderName: details.holderName,
      tierName: details.tierName,
      canCheckIn: true,
      idCard: details.idCard,
      badgeName: details.badgeName,
      avatarUrl: details.avatarUrl,
      badgeImage: details.badgeImage,
      namecardUrl: details.namecardUrl,
      tierCode: details.tierCode,
      isFursuiter: details.isFursuiter,
      isFursuitStaff: details.isFursuitStaff,
      isDealer: details.isDealer,
    );
  }

  /// Confirms check-in for a ticket that passed [lookupCode].
  Future<ScanTicketResult> checkInCode(ScanTicketResult preview) async {
    final referenceCode = preview.referenceCode ?? preview.code;

    try {
      final checkIn = await _adminTicketApi.confirmCheckIn(referenceCode);
      if (!checkIn.isSuccess) {
        return _recordAndReturn(
          code: referenceCode,
          outcome: ScanOutcome.rejected,
          message: checkIn.errorMessage ?? checkIn.message,
          details: _detailsFromResult(preview),
        );
      }
    } on ServerException catch (e) {
      return _recordAndReturn(
        code: referenceCode,
        outcome: ScanOutcome.rejected,
        message: e.message,
        details: _detailsFromResult(preview),
      );
    }

    return _recordAndReturn(
      code: referenceCode,
      outcome: ScanOutcome.valid,
      message: 'Check-in thành công.',
      details: _detailsFromResult(preview),
    );
  }

  Future<ScanShiftStats> getTodayStats() => _sessionStore.getTodayStats();

  Future<List<ScanRecord>> getHistory() => _sessionStore.getHistory();

  Future<ScanTicketResult> _recordAndReturn({
    required String code,
    required ScanOutcome outcome,
    required String message,
    _ScannedTicketDetails? details,
  }) async {
    await _sessionStore.recordScan(
      ScanRecord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        code: code,
        outcome: outcome,
        scannedAt: DateTime.now(),
        holderName: details?.holderName,
        tierName: details?.tierName,
        message: message,
      ),
    );

    return ScanTicketResult(
      outcome: outcome,
      code: code,
      message: message,
      holderName: details?.holderName,
      tierName: details?.tierName,
      referenceCode: code,
      idCard: details?.idCard,
      badgeName: details?.badgeName,
      avatarUrl: details?.avatarUrl,
      badgeImage: details?.badgeImage,
      namecardUrl: details?.namecardUrl,
      tierCode: details?.tierCode,
      isFursuiter: details?.isFursuiter ?? false,
      isFursuitStaff: details?.isFursuitStaff ?? false,
      isDealer: details?.isDealer ?? false,
    );
  }

  String _normalizeCode(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';

    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.hasScheme) {
      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (segments.isNotEmpty) return segments.last;
    }

    return trimmed;
  }

  _ScannedTicketDetails _parseDetails(
    Map<String, dynamic> ticket, {
    required String fallbackCode,
  }) {
    final user = ticket['user'];
    final userMap =
        user is Map ? Map<String, dynamic>.from(user) : <String, dynamic>{};
    final tier = ticket['ticket'];
    final tierMap =
        tier is Map ? Map<String, dynamic>.from(tier) : <String, dynamic>{};

    final holderName = _holderName(ticket);
    final badgeName = (ticket['con_badge_name'] as String?)?.trim();
    final resolvedBadgeName = badgeName != null && badgeName.isNotEmpty
        ? badgeName
        : holderName;

    return _ScannedTicketDetails(
      referenceCode: ticket['reference_code'] as String? ?? fallbackCode,
      holderName: holderName,
      tierName: _tierName(ticket),
      idCard: userMap['id_card'] as String?,
      badgeName: resolvedBadgeName,
      avatarUrl: userMap['avatar'] as String?,
      badgeImage: ticket['badge_image'] as String?,
      namecardUrl: ticket['namecard_url'] as String?,
      tierCode: tierMap['tier_code'] as String?,
      isFursuiter: ticket['is_fursuiter'] as bool? ?? false,
      isFursuitStaff: ticket['is_fursuit_staff'] as bool? ?? false,
      isDealer: userMap['is_dealer'] as bool? ?? false,
      isCheckedIn: ticket['is_checked_in'] as bool? ?? false,
    );
  }

  _ScannedTicketDetails _detailsFromResult(ScanTicketResult result) {
    return _ScannedTicketDetails(
      referenceCode: result.referenceCode ?? result.code,
      holderName: result.holderName,
      tierName: result.tierName,
      idCard: result.idCard,
      badgeName: result.badgeName,
      avatarUrl: result.avatarUrl,
      badgeImage: result.badgeImage,
      namecardUrl: result.namecardUrl,
      tierCode: result.tierCode,
      isFursuiter: result.isFursuiter,
      isFursuitStaff: result.isFursuitStaff,
      isDealer: result.isDealer,
    );
  }
  String? _holderName(Map<String, dynamic> ticket) {
    final user = ticket['user'];
    if (user is! Map) return ticket['con_badge_name'] as String?;

    final first = user['first_name'] as String? ?? '';
    final last = user['last_name'] as String? ?? '';
    final full = '$first $last'.trim();
    if (full.isNotEmpty) return full;
    return user['fursona_name'] as String? ??
        user['email'] as String? ??
        ticket['con_badge_name'] as String?;
  }

  String? _tierName(Map<String, dynamic> ticket) {
    final tier = ticket['ticket'];
    if (tier is Map) {
      return tier['ticket_name'] as String? ?? tier['name'] as String?;
    }
    return null;
  }
}

class _ScannedTicketDetails {
  const _ScannedTicketDetails({
    required this.referenceCode,
    this.holderName,
    this.tierName,
    this.idCard,
    this.badgeName,
    this.avatarUrl,
    this.badgeImage,
    this.namecardUrl,
    this.tierCode,
    this.isFursuiter = false,
    this.isFursuitStaff = false,
    this.isDealer = false,
    this.isCheckedIn = false,
  });

  final String referenceCode;
  final String? holderName;
  final String? tierName;
  final String? idCard;
  final String? badgeName;
  final String? avatarUrl;
  final String? badgeImage;
  final String? namecardUrl;
  final String? tierCode;
  final bool isFursuiter;
  final bool isFursuitStaff;
  final bool isDealer;
  final bool isCheckedIn;
}
