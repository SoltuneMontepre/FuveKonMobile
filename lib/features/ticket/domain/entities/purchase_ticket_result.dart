import 'package:equatable/equatable.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';

class PurchaseTicketResult extends Equatable {
  const PurchaseTicketResult({
    this.ticket,
    required this.queued,
    required this.statusCode,
  });

  final UserTicket? ticket;
  final bool queued;
  final int statusCode;

  @override
  List<Object?> get props => [ticket, queued, statusCode];
}
