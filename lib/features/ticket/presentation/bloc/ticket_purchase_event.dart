import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_purchase_event.freezed.dart';

@freezed
sealed class TicketPurchaseEvent with _$TicketPurchaseEvent {
  const factory TicketPurchaseEvent.started({
    required String tierId,
    @Default(false) bool queued,
  }) = TicketPurchaseStarted;
  const factory TicketPurchaseEvent.refreshRequested() =
      TicketPurchaseRefreshRequested;
  const factory TicketPurchaseEvent.idCardSaved(String idCard) =
      TicketPurchaseIdCardSaved;
  const factory TicketPurchaseEvent.confirmPaymentRequested() =
      TicketPurchaseConfirmPaymentRequested;
}
