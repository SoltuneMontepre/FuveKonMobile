import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/confirm_payment_result.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';

class ConfirmTicketPaymentUseCase {
  ConfirmTicketPaymentUseCase(this._repository);

  final TicketRepository _repository;

  Future<Result<ConfirmPaymentResult>> call() => _repository.confirmPayment();
}
