import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/purchase_ticket_result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_ticket_tier_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_ticket_tiers_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/purchase_ticket_usecase.dart';

sealed class TicketTierDetailEvent {
  const TicketTierDetailEvent();
}

final class TicketTierDetailStarted extends TicketTierDetailEvent {
  const TicketTierDetailStarted(this.tierId);

  final String tierId;
}

final class TicketTierDetailPurchaseRequested extends TicketTierDetailEvent {
  const TicketTierDetailPurchaseRequested();
}

sealed class TicketTierDetailState {
  const TicketTierDetailState();
}

final class TicketTierDetailInitial extends TicketTierDetailState {
  const TicketTierDetailInitial();
}

final class TicketTierDetailLoading extends TicketTierDetailState {
  const TicketTierDetailLoading();
}

final class TicketTierDetailLoaded extends TicketTierDetailState {
  const TicketTierDetailLoaded({
    required this.tier,
    required this.allTiers,
    this.isPurchasing = false,
  });

  final TicketTier tier;
  final List<TicketTier> allTiers;
  final bool isPurchasing;

  TicketTierDetailLoaded copyWith({
    TicketTier? tier,
    List<TicketTier>? allTiers,
    bool? isPurchasing,
  }) {
    return TicketTierDetailLoaded(
      tier: tier ?? this.tier,
      allTiers: allTiers ?? this.allTiers,
      isPurchasing: isPurchasing ?? this.isPurchasing,
    );
  }
}

final class TicketTierDetailFailure extends TicketTierDetailState {
  const TicketTierDetailFailure(this.message);

  final String message;
}

class TicketTierDetailBloc
    extends Bloc<TicketTierDetailEvent, TicketTierDetailState> {
  TicketTierDetailBloc({
    required GetTicketTierUseCase getTicketTierUseCase,
    required GetTicketTiersUseCase getTicketTiersUseCase,
    required PurchaseTicketUseCase purchaseTicketUseCase,
  })  : _getTicketTierUseCase = getTicketTierUseCase,
        _getTicketTiersUseCase = getTicketTiersUseCase,
        _purchaseTicketUseCase = purchaseTicketUseCase,
        super(const TicketTierDetailInitial()) {
    on<TicketTierDetailStarted>(_onStarted);
    on<TicketTierDetailPurchaseRequested>(_onPurchase);
  }

  final GetTicketTierUseCase _getTicketTierUseCase;
  final GetTicketTiersUseCase _getTicketTiersUseCase;
  final PurchaseTicketUseCase _purchaseTicketUseCase;

  String? lastActionError;
  PurchaseTicketResult? lastPurchaseResult;

  Future<void> _onStarted(
    TicketTierDetailStarted event,
    Emitter<TicketTierDetailState> emit,
  ) async {
    emit(const TicketTierDetailLoading());

    final tierResult = await _getTicketTierUseCase(event.tierId);
    if (tierResult case Error(:final failure)) {
      emit(TicketTierDetailFailure(failure.message));
      return;
    }

    final tier = (tierResult as Success<TicketTier>).data;
    final tiersResult = await _getTicketTiersUseCase();
    final allTiers = switch (tiersResult) {
      Success(:final data) => data,
      Error() => <TicketTier>[],
    }
        .where((item) => item.isVisible && item.isActive)
        .toList()
      ..sort((a, b) => a.price.compareTo(b.price));

    if (!allTiers.any((item) => item.id == tier.id)) {
      allTiers.add(tier);
    }

    emit(TicketTierDetailLoaded(tier: tier, allTiers: allTiers));
  }

  Future<void> _onPurchase(
    TicketTierDetailPurchaseRequested event,
    Emitter<TicketTierDetailState> emit,
  ) async {
    final current = state;
    if (current is! TicketTierDetailLoaded || current.isPurchasing) return;

    emit(current.copyWith(isPurchasing: true));
    lastActionError = null;

    final result = await _purchaseTicketUseCase(current.tier.id);
    switch (result) {
      case Success(:final data):
        lastPurchaseResult = data;
        emit(current.copyWith(isPurchasing: false));
      case Error(:final failure):
        lastActionError = failure.message;
        emit(current.copyWith(isPurchasing: false));
    }
  }
}
