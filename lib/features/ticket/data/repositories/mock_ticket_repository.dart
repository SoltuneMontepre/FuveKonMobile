import 'package:fuvekonmobile/core/errors/failures.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/data/mock/mock_ticket_data.dart';
import 'package:fuvekonmobile/features/ticket/data/mock/mock_ticket_store.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/purchase_ticket_result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/update_badge_details_input.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';

class MockTicketRepository implements TicketRepository {
  MockTicketRepository({required MockTicketStore store}) : _store = store;

  final MockTicketStore _store;

  @override
  Future<Result<List<TicketTier>>> getTiers() async {
    await _delay();
    return Success(MockTicketData.tiers);
  }

  @override
  Future<Result<TicketTier>> getTierById(String tierId) async {
    await _delay();
    final tier = MockTicketData.tierById(tierId);
    if (tier == null) {
      return const Error(ValidationFailure('Mock tier not found.'));
    }
    return Success(tier);
  }

  @override
  Future<Result<UserTicket?>> getMyTicket() async {
    await _delay();
    return Success(_store.ticket);
  }

  @override
  Future<Result<PurchaseTicketResult>> purchaseTicket(String tierId) async {
    await _delay();
    final existing = _store.ticket;
    if (existing != null && existing.status != TicketStatus.denied) {
      return const Error(
        ValidationFailure('Bạn đã có vé (mock). Dùng panel DEMO để reset.'),
      );
    }
    _store.purchase(tierId);
    return Success(
      PurchaseTicketResult(
        ticket: _store.ticket,
        queued: false,
        statusCode: 200,
      ),
    );
  }

  @override
  Future<Result<UserTicket>> confirmPayment() async {
    await _delay();
    if (_store.ticket == null) {
      return const Error(ValidationFailure('Chưa có vé mock.'));
    }
    _store.confirmPayment();
    return Success(_store.ticket!);
  }

  @override
  Future<Result<UserTicket>> updateBadgeDetails(
    UpdateBadgeDetailsInput input,
  ) async {
    await _delay();
    try {
      final updated = _store.updateBadgeDetails(input);
      return Success(updated);
    } catch (_) {
      return const Error(ValidationFailure('Chưa có vé mock.'));
    }
  }

  @override
  Future<Result<UserTicket>> upgradeTicket(String newTierId) async {
    await _delay();
    if (_store.ticket == null) {
      return const Error(ValidationFailure('Chưa có vé mock.'));
    }
    _store.simulateUpgrade(newTierId: newTierId);
    return Success(_store.ticket!);
  }

  Future<void> _delay() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
