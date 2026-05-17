import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_ticket_event.freezed.dart';

@freezed
sealed class MyTicketEvent with _$MyTicketEvent {
  const factory MyTicketEvent.started() = MyTicketStarted;
  const factory MyTicketEvent.refreshRequested() = MyTicketRefreshRequested;
  const factory MyTicketEvent.badgeNameChanged(String value) =
      MyTicketBadgeNameChanged;
  const factory MyTicketEvent.fursuiterChanged(bool value) =
      MyTicketFursuiterChanged;
  const factory MyTicketEvent.fursuitStaffChanged(bool value) =
      MyTicketFursuitStaffChanged;
  const factory MyTicketEvent.saveNameCardRequested() =
      MyTicketSaveNameCardRequested;
  const factory MyTicketEvent.previewRegenerateRequested() =
      MyTicketPreviewRegenerateRequested;
}
