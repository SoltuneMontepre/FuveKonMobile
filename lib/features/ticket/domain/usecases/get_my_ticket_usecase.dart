import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';

class GetMyTicketUseCase {
  GetMyTicketUseCase(this._repository);

  final TicketRepository _repository;

  Future<Result<UserTicket?>> call() => _repository.getMyTicket();
}
