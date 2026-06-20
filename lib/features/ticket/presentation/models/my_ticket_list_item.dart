import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';

/// Row model for the "Vé của tôi" list screen.
class MyTicketListItem {
  const MyTicketListItem({
    required this.id,
    required this.title,
    required this.dateLabel,
    required this.imageAsset,
    required this.isCheckedIn,
    required this.isActive,
    this.userTicket,
    this.account,
  });

  final String id;
  final String title;
  final String dateLabel;
  final String imageAsset;
  final bool isCheckedIn;
  final bool isActive;
  final UserTicket? userTicket;
  final Account? account;

  bool get isValidQr =>
      userTicket != null &&
      (userTicket!.status == TicketStatus.approved ||
          userTicket!.status == TicketStatus.adminGranted);

  factory MyTicketListItem.fromTicket({
    required UserTicket ticket,
    required Account account,
    required String eventDateLabel,
    String imageAsset = 'assets/images/event.png',
  }) {
    final tierName = ticket.tier?.ticketName ?? 'Standard';
    final isListedActive =
        ticket.status != TicketStatus.denied &&
        !ticket.isCheckedIn &&
        (ticket.status == TicketStatus.approved ||
            ticket.status == TicketStatus.adminGranted ||
            ticket.status == TicketStatus.selfConfirmed ||
            ticket.status == TicketStatus.pending);

    return MyTicketListItem(
      id: ticket.id,
      title: '${AppConfig.appName} — $tierName',
      dateLabel: eventDateLabel,
      imageAsset: imageAsset,
      isCheckedIn: ticket.isCheckedIn,
      isActive: isListedActive,
      userTicket: ticket,
      account: account,
    );
  }
}

class ETicketDetailArgs {
  const ETicketDetailArgs({
    required this.listItem,
    required this.ownerName,
    required this.tierLabel,
    required this.eventDayLabel,
    required this.referenceCode,
    required this.benefits,
    this.isValid = true,
  });

  final MyTicketListItem listItem;
  final String ownerName;
  final String tierLabel;
  final String eventDayLabel;
  final String referenceCode;
  final List<String> benefits;
  final bool isValid;

  factory ETicketDetailArgs.fromListItem(MyTicketListItem item) {
    final ticket = item.userTicket!;
    final account = item.account;
    final owner = account?.ticketHolderName ?? 'Khách';

    return ETicketDetailArgs(
      listItem: item,
      ownerName: owner,
      tierLabel: ticket.tier?.ticketName ?? 'Standard',
      eventDayLabel: item.dateLabel,
      referenceCode: ticket.referenceCode,
      benefits: ticket.tier?.benefits ?? const [],
      isValid: item.isValidQr,
    );
  }
}
