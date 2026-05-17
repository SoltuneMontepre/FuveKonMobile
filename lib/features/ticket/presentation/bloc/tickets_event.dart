import 'package:freezed_annotation/freezed_annotation.dart';

part 'tickets_event.freezed.dart';

@freezed
sealed class TicketsEvent with _$TicketsEvent {
  const factory TicketsEvent.started() = TicketsStarted;
  const factory TicketsEvent.refreshRequested() = TicketsRefreshRequested;
  const factory TicketsEvent.purchaseRequested(String tierId) =
      TicketsPurchaseRequested;
}
