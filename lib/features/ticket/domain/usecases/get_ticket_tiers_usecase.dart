import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';

class GetTicketTiersUseCase {
  GetTicketTiersUseCase(this._repository);

  final TicketRepository _repository;

  Future<Result<List<TicketTier>>> call() => _repository.getTiers();
}
