import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';

class ConfirmTicketPaymentUseCase {
  ConfirmTicketPaymentUseCase(this._repository);

  final TicketRepository _repository;

  Future<Result<UserTicket>> call() => _repository.confirmPayment();
}
