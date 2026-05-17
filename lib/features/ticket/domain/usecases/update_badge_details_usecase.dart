import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/update_badge_details_input.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';

class UpdateBadgeDetailsUseCase {
  UpdateBadgeDetailsUseCase(this._repository);

  final TicketRepository _repository;

  Future<Result<UserTicket>> call(UpdateBadgeDetailsInput input) =>
      _repository.updateBadgeDetails(input);
}
