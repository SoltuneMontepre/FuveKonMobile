import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/purchase_ticket_result.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';

class PurchaseTicketUseCase {
  PurchaseTicketUseCase(this._repository);

  final TicketRepository _repository;

  Future<Result<PurchaseTicketResult>> call(String tierId) =>
      _repository.purchaseTicket(tierId);
}
