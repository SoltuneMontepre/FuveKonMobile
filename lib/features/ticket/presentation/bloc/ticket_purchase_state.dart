import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';

part 'ticket_purchase_state.freezed.dart';

@freezed
sealed class TicketPurchaseState with _$TicketPurchaseState {
  const factory TicketPurchaseState.initial() = TicketPurchaseInitial;
  const factory TicketPurchaseState.loading() = TicketPurchaseLoading;
  const factory TicketPurchaseState.polling({
    required int attempt,
    required int maxAttempts,
  }) = TicketPurchasePolling;
  const factory TicketPurchaseState.loaded({
    required UserTicket ticket,
    required Account account,
    required String tierId,
    @Default(false) bool queued,
    @Default(false) bool isConfirming,
    @Default(false) bool isSavingIdCard,
    @Default(false) bool isUpgrade,
    double? payableAmount,
  }) = TicketPurchaseLoaded;
  const factory TicketPurchaseState.notFound({@Default(false) bool queued}) =
      TicketPurchaseNotFound;
  const factory TicketPurchaseState.queueTimedOut() =
      TicketPurchaseQueueTimedOut;
  const factory TicketPurchaseState.denied({
    required UserTicket ticket,
    required String denialReason,
  }) = TicketPurchaseDenied;
  const factory TicketPurchaseState.failure(String message) =
      TicketPurchaseFailure;
  const factory TicketPurchaseState.confirmed(UserTicket ticket) =
      TicketPurchaseConfirmed;
}
