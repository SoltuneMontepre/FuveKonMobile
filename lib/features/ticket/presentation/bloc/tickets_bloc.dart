import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/purchase_ticket_result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_my_ticket_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_ticket_tiers_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/purchase_ticket_usecase.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/tickets_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  TicketsBloc({
    required GetTicketTiersUseCase getTicketTiersUseCase,
    required GetMyTicketUseCase getMyTicketUseCase,
    required GetMeUseCase getMeUseCase,
    required PurchaseTicketUseCase purchaseTicketUseCase,
  })  : _getTicketTiersUseCase = getTicketTiersUseCase,
        _getMyTicketUseCase = getMyTicketUseCase,
        _getMeUseCase = getMeUseCase,
        _purchaseTicketUseCase = purchaseTicketUseCase,
        super(const TicketsState.initial()) {
    on<TicketsStarted>(_onLoad);
    on<TicketsRefreshRequested>(_onLoad);
    on<TicketsPurchaseRequested>(_onPurchase);
  }

  final GetTicketTiersUseCase _getTicketTiersUseCase;
  final GetMyTicketUseCase _getMyTicketUseCase;
  final GetMeUseCase _getMeUseCase;
  final PurchaseTicketUseCase _purchaseTicketUseCase;

  PurchaseTicketResult? lastPurchaseResult;
  String? lastPurchaseError;

  Future<void> _onLoad(TicketsEvent event, Emitter<TicketsState> emit) async {
    emit(const TicketsState.loading());

    final tiersResult = await _getTicketTiersUseCase();
    final ticketResult = await _getMyTicketUseCase();
    final accountResult = await _getMeUseCase();

    if (tiersResult case Error(:final failure)) {
      emit(TicketsState.failure(failure.message));
      return;
    }

    final tiers = (tiersResult as Success<List<TicketTier>>).data;
    final myTicket = switch (ticketResult) {
      Success(:final data) => data,
      Error() => null,
    };
    final account = switch (accountResult) {
      Success(:final data) => data,
      Error() => null,
    };

    emit(
      TicketsState.loaded(
        tiers: tiers,
        myTicket: myTicket,
        account: account,
      ),
    );
  }

  Future<void> _onPurchase(
    TicketsPurchaseRequested event,
    Emitter<TicketsState> emit,
  ) async {
    final current = state;
    if (current is! TicketsLoaded) return;

    emit(current.copyWith(isPurchasing: true));
    lastPurchaseError = null;
    final result = await _purchaseTicketUseCase(event.tierId);

    switch (result) {
      case Success(:final data):
        lastPurchaseResult = data;
        final purchase = data;
        final refreshedResult = await _getMyTicketUseCase();
        final myTicket = switch (refreshedResult) {
          Success(:final data) => data ?? purchase.ticket ?? current.myTicket,
          Error() => purchase.ticket ?? current.myTicket,
        };
        emit(
          current.copyWith(
            isPurchasing: false,
            myTicket: myTicket,
          ),
        );
      case Error(:final failure):
        lastPurchaseError = failure.message;
        emit(current.copyWith(isPurchasing: false));
    }
  }
}
