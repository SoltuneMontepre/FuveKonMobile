import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/purchase_ticket_result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/update_badge_details_input.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';

abstract interface class TicketRepository {
  Future<Result<List<TicketTier>>> getTiers();

  Future<Result<UserTicket?>> getMyTicket();

  Future<Result<PurchaseTicketResult>> purchaseTicket(String tierId);

  Future<Result<UserTicket>> confirmPayment();

  Future<Result<UserTicket>> updateBadgeDetails(UpdateBadgeDetailsInput input);

  Future<Result<UserTicket>> upgradeTicket(String newTierId);
}
