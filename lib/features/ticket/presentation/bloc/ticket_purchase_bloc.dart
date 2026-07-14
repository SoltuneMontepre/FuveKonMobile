import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/update_profile_input.dart';
import 'package:fuvekonmobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:fuvekonmobile/features/profile/domain/usecases/update_me_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/confirm_ticket_payment_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_my_ticket_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_ticket_tiers_usecase.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_purchase_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_purchase_state.dart';

class TicketPurchaseBloc
    extends Bloc<TicketPurchaseEvent, TicketPurchaseState> {
  TicketPurchaseBloc({
    required ConfirmTicketPaymentUseCase confirmTicketPaymentUseCase,
    required GetMyTicketUseCase getMyTicketUseCase,
    required GetTicketTiersUseCase getTicketTiersUseCase,
    required GetMeUseCase getMeUseCase,
    required UpdateMeUseCase updateMeUseCase,
  }) : _confirmTicketPaymentUseCase = confirmTicketPaymentUseCase,
       _getMyTicketUseCase = getMyTicketUseCase,
       _getTicketTiersUseCase = getTicketTiersUseCase,
       _getMeUseCase = getMeUseCase,
       _updateMeUseCase = updateMeUseCase,
       super(const TicketPurchaseState.initial()) {
    on<TicketPurchaseStarted>(_onStarted);
    on<TicketPurchaseRefreshRequested>(
      (event, emit) => _onStarted(
        TicketPurchaseStarted(
          tierId: _tierId ?? '',
          queued: _queued,
          isUpgrade: _isUpgrade,
          payableAmount: _payableAmount,
        ),
        emit,
      ),
    );
    on<TicketPurchaseIdCardSaved>(_onIdCardSaved);
    on<TicketPurchaseConfirmPaymentRequested>(_onConfirm);
  }

  static const queuePollMaxAttempts = 10;
  static const queuePollDelay = Duration(milliseconds: 800);

  final ConfirmTicketPaymentUseCase _confirmTicketPaymentUseCase;
  final GetMyTicketUseCase _getMyTicketUseCase;
  final GetTicketTiersUseCase _getTicketTiersUseCase;
  final GetMeUseCase _getMeUseCase;
  final UpdateMeUseCase _updateMeUseCase;

  String? _tierId;
  bool _queued = false;
  bool _isUpgrade = false;
  double? _payableAmount;
  String? lastActionError;

  Future<void> _onStarted(
    TicketPurchaseEvent event,
    Emitter<TicketPurchaseState> emit,
  ) async {
    if (event is TicketPurchaseStarted) {
      _tierId = event.tierId;
      _queued = event.queued;
      _isUpgrade = event.isUpgrade;
      _payableAmount = event.payableAmount;
    }

    emit(const TicketPurchaseState.loading());

    final accountResult = await _getMeUseCase();
    if (accountResult case Error(:final failure)) {
      emit(TicketPurchaseState.failure(failure.message));
      return;
    }

    final account = (accountResult as Success<Account>).data;

    if (_queued) {
      for (var attempt = 1; attempt <= queuePollMaxAttempts; attempt++) {
        if (attempt > 1) {
          emit(
            TicketPurchaseState.polling(
              attempt: attempt,
              maxAttempts: queuePollMaxAttempts,
            ),
          );
          await Future<void>.delayed(queuePollDelay);
          if (isClosed) return;
        }

        final ticketResult = await _getMyTicketUseCase();
        final resolved = await _resolveTicketState(
          ticketResult,
          account,
          allowRetry: true,
        );

        if (resolved != null) {
          emit(resolved);
          return;
        }
      }

      emit(const TicketPurchaseState.queueTimedOut());
      return;
    }

    final ticketResult = await _getMyTicketUseCase();
    final resolved = await _resolveTicketState(
      ticketResult,
      account,
      allowRetry: false,
    );
    emit(resolved ?? TicketPurchaseState.notFound(queued: _queued));
  }

  Future<TicketPurchaseState?> _resolveTicketState(
    Result<UserTicket?> ticketResult,
    Account account, {
    required bool allowRetry,
  }) async {
    switch (ticketResult) {
      case Error(:final failure):
        return TicketPurchaseState.failure(failure.message);
      case Success(:final data):
        if (data == null) {
          return allowRetry
              ? null
              : TicketPurchaseState.notFound(queued: _queued);
        }
        if (data.status == TicketStatus.denied) {
          return TicketPurchaseState.denied(
            ticket: data,
            denialReason: data.denialReason ?? '',
          );
        }
        if (_queued &&
            _tierId != null &&
            data.tier?.id != _tierId &&
            data.status == TicketStatus.pending) {
          return allowRetry ? null : TicketPurchaseState.notFound(queued: true);
        }

        final isUpgrade = _isUpgrade || data.isUpgradeInProgress;
        final payableAmount = await _resolvePayableAmount(data, isUpgrade);

        return TicketPurchaseState.loaded(
          ticket: data,
          account: account,
          tierId: _tierId ?? data.tier?.id ?? '',
          queued: _queued,
          isUpgrade: isUpgrade,
          payableAmount: payableAmount,
        );
    }
  }

  Future<double?> _resolvePayableAmount(UserTicket ticket, bool isUpgrade) async {
    if (_payableAmount != null && _payableAmount! > 0) {
      return _payableAmount;
    }
    if (!isUpgrade) return null;

    final oldTierId = ticket.upgradedFromTierId;
    final newPrice = ticket.tier?.price;
    if (oldTierId == null || oldTierId.isEmpty || newPrice == null) {
      return _payableAmount;
    }

    final tiersResult = await _getTicketTiersUseCase();
    if (tiersResult case Success<List<TicketTier>>(:final data)) {
      TicketTier? oldTier;
      for (final tier in data) {
        if (tier.id == oldTierId) {
          oldTier = tier;
          break;
        }
      }
      if (oldTier != null) {
        final diff = newPrice - oldTier.price;
        if (diff > 0) return diff;
      }
    }
    return _payableAmount;
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
        final ticket = data.ticket ?? _asSelfConfirmed(current.ticket);
        emit(TicketPurchaseState.confirmed(ticket));
      case Error(:final failure):
        lastActionError = failure.message;
        emit(current.copyWith(isConfirming: false));
    }
  }

  UserTicket _asSelfConfirmed(UserTicket ticket) {
    return UserTicket(
      id: ticket.id,
      referenceCode: ticket.referenceCode,
      status: TicketStatus.selfConfirmed,
      ticketNumber: ticket.ticketNumber,
      conBadgeName: ticket.conBadgeName,
      badgeImage: ticket.badgeImage,
      namecardUrl: ticket.namecardUrl,
      isFursuiter: ticket.isFursuiter,
      isFursuitStaff: ticket.isFursuitStaff,
      isCheckedIn: ticket.isCheckedIn,
      tshirtSize: ticket.tshirtSize,
      denialReason: ticket.denialReason,
      createdAt: ticket.createdAt,
      previousReferenceCode: ticket.previousReferenceCode,
      upgradedFromTierId: ticket.upgradedFromTierId,
      upgradeDenialReason: ticket.upgradeDenialReason,
      tier: ticket.tier,
    );
  }
}
