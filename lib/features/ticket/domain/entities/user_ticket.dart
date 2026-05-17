import 'package:equatable/equatable.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';

class UserTicket extends Equatable {
  const UserTicket({
    required this.id,
    required this.referenceCode,
    required this.status,
    required this.ticketNumber,
    this.conBadgeName,
    this.badgeImage,
    this.namecardUrl,
    required this.isFursuiter,
    required this.isFursuitStaff,
    required this.isCheckedIn,
    this.tshirtSize,
    this.denialReason,
    required this.createdAt,
    this.previousReferenceCode,
    this.tier,
  });

  final String id;
  final String referenceCode;
  final TicketStatus status;
  final int ticketNumber;
  final String? conBadgeName;
  final String? badgeImage;
  final String? namecardUrl;
  final bool isFursuiter;
  final bool isFursuitStaff;
  final bool isCheckedIn;
  final String? tshirtSize;
  final String? denialReason;
  final DateTime createdAt;
  final String? previousReferenceCode;
  final TicketTier? tier;

  bool get needsPayment =>
      status == TicketStatus.pending;

  @override
  List<Object?> get props => [
        id,
        referenceCode,
        status,
        ticketNumber,
        conBadgeName,
        badgeImage,
        namecardUrl,
        isFursuiter,
        isFursuitStaff,
        isCheckedIn,
        tshirtSize,
        denialReason,
        createdAt,
        previousReferenceCode,
        tier,
      ];
}
