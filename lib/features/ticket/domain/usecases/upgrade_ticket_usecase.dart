import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';

class UpgradeTicketUseCase {
  UpgradeTicketUseCase(this._repository);

  final TicketRepository _repository;

  Future<Result<UserTicket>> call(String newTierId) =>
      _repository.upgradeTicket(newTierId);
}
