import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuvekonmobile/core/utils/ticket/render_namecard.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';

part 'my_ticket_state.freezed.dart';

@freezed
sealed class MyTicketState with _$MyTicketState {
  const factory MyTicketState.initial() = MyTicketInitial;
  const factory MyTicketState.loading() = MyTicketLoading;
  const factory MyTicketState.loaded({
    required UserTicket ticket,
    required Account account,
    required String badgeName,
    required bool isFursuiter,
    required bool isFursuitStaff,
    @Default(false) bool isSavingNameCard,
    @Default(false) bool isGeneratingPreview,
  }) = MyTicketLoaded;
  const factory MyTicketState.empty() = MyTicketEmpty;
  const factory MyTicketState.failure(String message) = MyTicketFailure;
}

extension MyTicketLoadedX on MyTicketLoaded {
  bool get canViewNameCard =>
      ticket.status == TicketStatus.approved ||
      ticket.status == TicketStatus.adminGranted;

  bool get canSaveNameCard => canViewNameCard;

  int get tierCodeNumber => tierCodeFromTierCodeString(ticket.tier?.tierCode);

  bool get canEditNameCard => tierCodeNumber >= 1;

  String get previewName =>
      badgeName.trim().isNotEmpty
          ? badgeName.trim()
          : (account.displayName ?? 'Guest');
}
