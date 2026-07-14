import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/upgrade_ticket_result.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';

class UpgradeTicketUseCase {
  const UpgradeTicketUseCase(this._repository);

  final TicketRepository _repository;

  Future<Result<UpgradeTicketResult>> call(String newTierId) =>
      _repository.upgradeTicket(newTierId);
}
