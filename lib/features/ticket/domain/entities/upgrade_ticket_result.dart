import 'package:equatable/equatable.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';

class UpgradeTicketResult extends Equatable {
  const UpgradeTicketResult({
    this.ticket,
    required this.priceDifference,
    required this.queued,
    required this.statusCode,
  });

  final UserTicket? ticket;
  final double priceDifference;
  final bool queued;
  final int statusCode;

  @override
  List<Object?> get props => [ticket, priceDifference, queued, statusCode];
}
