import 'package:flutter/foundation.dart';
import 'package:fuvekonmobile/features/ticket/data/mock/mock_ticket_data.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/update_badge_details_input.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';

/// In-memory ticket state for [AppConfig.mockTicketMode].
class MockTicketStore extends ChangeNotifier {
  UserTicket? _ticket;
  int _ticketSeq = 1;

  UserTicket? get ticket => _ticket;

  String get statusLabel {
    final t = _ticket;
    if (t == null) return 'Chưa có vé';
    return switch (t.status) {
      TicketStatus.pending => 'Chờ thanh toán',
      TicketStatus.selfConfirmed => 'Chờ BTC duyệt',
      TicketStatus.approved => 'Đã duyệt',
      TicketStatus.denied => 'Từ chối',
      TicketStatus.adminGranted => 'Admin cấp',
    };
  }

  void reset() {
    _ticket = null;
    notifyListeners();
  }

  void grantApproved({String tierId = MockTicketIds.standard}) {
    _ticket = _newTicket(
      tier: MockTicketData.tierOrDefault(tierId),
      status: TicketStatus.approved,
    );
    notifyListeners();
  }

  void purchase(String tierId) {
    _ticket = _newTicket(
      tier: MockTicketData.tierOrDefault(tierId),
      status: TicketStatus.pending,
    );
    notifyListeners();
  }

  void confirmPayment() {
    final current = _ticket;
    if (current == null || current.status != TicketStatus.pending) return;
    _ticket = _copyTicket(current, status: TicketStatus.selfConfirmed);
    notifyListeners();
  }

  void simulateAdminApprove() {
    final current = _ticket;
    if (current == null) return;
    if (current.status != TicketStatus.selfConfirmed &&
        current.status != TicketStatus.pending) {
      return;
    }
    _ticket = _copyTicket(current, status: TicketStatus.approved);
    notifyListeners();
  }

  void simulateUpgrade({String newTierId = MockTicketIds.vip}) {
    final current = _ticket;
    if (current == null) return;
    if (current.status != TicketStatus.approved &&
        current.status != TicketStatus.adminGranted) {
      return;
    }
    final newTier = MockTicketData.tierOrDefault(newTierId);
    final oldPrice = current.tier?.price ?? 0;
    if (newTier.price <= oldPrice) return;

    _ticketSeq += 1;
    _ticket = UserTicket(
      id: 'mock-ticket-$_ticketSeq',
      referenceCode: 'FVK-DEMO-${_ticketSeq.toString().padLeft(3, '0')}',
      status: TicketStatus.pending,
      ticketNumber: 1000 + _ticketSeq,
      conBadgeName: current.conBadgeName,
      badgeImage: current.badgeImage,
      namecardUrl: current.namecardUrl,
      isFursuiter: current.isFursuiter,
      isFursuitStaff: current.isFursuitStaff,
      isCheckedIn: false,
      tshirtSize: current.tshirtSize,
      denialReason: null,
      createdAt: DateTime.now(),
      previousReferenceCode: current.referenceCode,
      tier: newTier,
    );
    notifyListeners();
  }

  void deny({String reason = 'Demo: vé bị từ chối'}) {
    final current = _ticket;
    if (current == null) return;
    _ticket = _copyTicket(
      current,
      status: TicketStatus.denied,
      denialReason: reason,
    );
    notifyListeners();
  }

  UserTicket updateBadgeDetails(UpdateBadgeDetailsInput input) {
    final current = _ticket;
    if (current == null) {
      throw StateError('No mock ticket');
    }
    _ticket = UserTicket(
      id: current.id,
      referenceCode: current.referenceCode,
      status: current.status,
      ticketNumber: current.ticketNumber,
      conBadgeName: input.conBadgeName,
      badgeImage: current.badgeImage,
      namecardUrl: input.namecardUrl ?? current.namecardUrl,
      isFursuiter: input.isFursuiter,
      isFursuitStaff: input.isFursuitStaff,
      isCheckedIn: current.isCheckedIn,
      tshirtSize: current.tshirtSize,
      denialReason: current.denialReason,
      createdAt: current.createdAt,
      previousReferenceCode: current.previousReferenceCode,
      tier: current.tier,
    );
    notifyListeners();
    return _ticket!;
  }

  UserTicket _newTicket({
    required TicketTier tier,
    required TicketStatus status,
  }) {
    _ticketSeq += 1;
    return UserTicket(
      id: 'mock-ticket-$_ticketSeq',
      referenceCode: 'FVK-DEMO-${_ticketSeq.toString().padLeft(3, '0')}',
      status: status,
      ticketNumber: 1000 + _ticketSeq,
      conBadgeName: null,
      badgeImage: null,
      namecardUrl: null,
      isFursuiter: false,
      isFursuitStaff: false,
      isCheckedIn: false,
      tshirtSize: null,
      denialReason: null,
      createdAt: DateTime.now(),
      previousReferenceCode: null,
      tier: tier,
    );
  }

  UserTicket _copyTicket(
    UserTicket source, {
    TicketStatus? status,
    String? denialReason,
  }) {
    return UserTicket(
      id: source.id,
      referenceCode: source.referenceCode,
      status: status ?? source.status,
      ticketNumber: source.ticketNumber,
      conBadgeName: source.conBadgeName,
      badgeImage: source.badgeImage,
      namecardUrl: source.namecardUrl,
      isFursuiter: source.isFursuiter,
      isFursuitStaff: source.isFursuitStaff,
      isCheckedIn: source.isCheckedIn,
      tshirtSize: source.tshirtSize,
      denialReason: denialReason ?? source.denialReason,
      createdAt: source.createdAt,
      previousReferenceCode: source.previousReferenceCode,
      tier: source.tier,
    );
  }
}
