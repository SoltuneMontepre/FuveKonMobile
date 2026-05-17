import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/update_profile_input.dart';
import 'package:fuvekonmobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:fuvekonmobile/features/profile/domain/usecases/update_me_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/confirm_ticket_payment_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_my_ticket_usecase.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_purchase_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_purchase_state.dart';

class TicketPurchaseBloc
    extends Bloc<TicketPurchaseEvent, TicketPurchaseState> {
  TicketPurchaseBloc({
    required ConfirmTicketPaymentUseCase confirmTicketPaymentUseCase,
    required GetMyTicketUseCase getMyTicketUseCase,
    required GetMeUseCase getMeUseCase,
    required UpdateMeUseCase updateMeUseCase,
  })  : _confirmTicketPaymentUseCase = confirmTicketPaymentUseCase,
        _getMyTicketUseCase = getMyTicketUseCase,
        _getMeUseCase = getMeUseCase,
        _updateMeUseCase = updateMeUseCase,
        super(const TicketPurchaseState.initial()) {
    on<TicketPurchaseStarted>(_onStarted);
    on<TicketPurchaseRefreshRequested>(
      (event, emit) => _onStarted(
        TicketPurchaseStarted(tierId: _tierId ?? '', queued: _queued),
        emit,
      ),
    );
    on<TicketPurchaseIdCardSaved>(_onIdCardSaved);
    on<TicketPurchaseConfirmPaymentRequested>(_onConfirm);
  }

  final ConfirmTicketPaymentUseCase _confirmTicketPaymentUseCase;
  final GetMyTicketUseCase _getMyTicketUseCase;
  final GetMeUseCase _getMeUseCase;
  final UpdateMeUseCase _updateMeUseCase;

  String? _tierId;
  bool _queued = false;
  String? lastActionError;

  Future<void> _onStarted(
    TicketPurchaseEvent event,
    Emitter<TicketPurchaseState> emit,
  ) async {
    if (event is TicketPurchaseStarted) {
      _tierId = event.tierId;
      _queued = event.queued;
    }

    emit(const TicketPurchaseState.loading());

    final ticketResult = await _getMyTicketUseCase();
    final accountResult = await _getMeUseCase();

    if (accountResult case Error(:final failure)) {
      emit(TicketPurchaseState.failure(failure.message));
      return;
    }

    final account = (accountResult as Success<Account>).data;

    switch (ticketResult) {
      case Success(:final data):
        if (data == null) {
          emit(TicketPurchaseState.notFound(queued: _queued));
          return;
        }
        if (data.status == TicketStatus.denied) {
          emit(
            TicketPurchaseState.denied(
              ticket: data,
              denialReason: data.denialReason ?? '',
            ),
          );
          return;
        }
        if (_queued &&
            _tierId != null &&
            data.tier?.id != _tierId &&
            data.status == TicketStatus.pending) {
          emit(TicketPurchaseState.notFound(queued: true));
          return;
        }
        emit(
          TicketPurchaseState.loaded(
            ticket: data,
            account: account,
            tierId: _tierId ?? data.tier?.id ?? '',
            queued: _queued,
          ),
        );
      case Error(:final failure):
        emit(TicketPurchaseState.failure(failure.message));
    }
  }

  Future<void> _onIdCardSaved(
    TicketPurchaseIdCardSaved event,
    Emitter<TicketPurchaseState> emit,
  ) async {
    final current = state;
    if (current is! TicketPurchaseLoaded) return;

    emit(current.copyWith(isSavingIdCard: true));
    final result = await _updateMeUseCase(
      UpdateProfileInput(idCard: event.idCard.trim()),
    );

    switch (result) {
      case Success(:final data):
        emit(current.copyWith(account: data, isSavingIdCard: false));
      case Error(:final failure):
        lastActionError = failure.message;
        emit(current.copyWith(isSavingIdCard: false));
    }
  }

  Future<void> _onConfirm(
    TicketPurchaseConfirmPaymentRequested event,
    Emitter<TicketPurchaseState> emit,
  ) async {
    final current = state;
    if (current is! TicketPurchaseLoaded) return;

    final idCard = current.account.idCard?.trim() ?? '';
    if (idCard.isEmpty) {
      lastActionError = 'Please add your passport/ID number.';
      emit(current.copyWith(isConfirming: false));
      return;
    }

    emit(current.copyWith(isConfirming: true));
    lastActionError = null;
    final result = await _confirmTicketPaymentUseCase();

    switch (result) {
      case Success(:final data):
        emit(TicketPurchaseState.confirmed(data));
      case Error(:final failure):
        lastActionError = failure.message;
        emit(current.copyWith(isConfirming: false));
    }
  }
}
