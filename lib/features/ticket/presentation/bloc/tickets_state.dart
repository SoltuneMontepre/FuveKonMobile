import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';

part 'tickets_state.freezed.dart';

@freezed
sealed class TicketsState with _$TicketsState {
  const factory TicketsState.initial() = TicketsInitial;
  const factory TicketsState.loading() = TicketsLoading;
  const factory TicketsState.loaded({
    required List<TicketTier> tiers,
    UserTicket? myTicket,
    Account? account,
    @Default(false) bool isPurchasing,
  }) = TicketsLoaded;
  const factory TicketsState.failure(String message) = TicketsFailure;
}
