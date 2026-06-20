import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_ticket_tiers_usecase.dart';

sealed class TicketTiersEvent {
  const TicketTiersEvent();
}

final class TicketTiersStarted extends TicketTiersEvent {
  const TicketTiersStarted();
}

final class TicketTiersRefreshRequested extends TicketTiersEvent {
  const TicketTiersRefreshRequested();
}

sealed class TicketTiersState {
  const TicketTiersState();
}

final class TicketTiersInitial extends TicketTiersState {
  const TicketTiersInitial();
}

final class TicketTiersLoading extends TicketTiersState {
  const TicketTiersLoading();
}

final class TicketTiersLoaded extends TicketTiersState {
  const TicketTiersLoaded(this.tiers);

  final List<TicketTier> tiers;
}

final class TicketTiersFailure extends TicketTiersState {
  const TicketTiersFailure(this.message);

  final String message;
}

class TicketTiersBloc extends Bloc<TicketTiersEvent, TicketTiersState> {
  TicketTiersBloc({required GetTicketTiersUseCase getTicketTiersUseCase})
    : _getTicketTiersUseCase = getTicketTiersUseCase,
      super(const TicketTiersInitial()) {
    on<TicketTiersStarted>(_onLoad);
    on<TicketTiersRefreshRequested>(_onLoad);
  }

  final GetTicketTiersUseCase _getTicketTiersUseCase;

  Future<void> _onLoad(
    TicketTiersEvent event,
    Emitter<TicketTiersState> emit,
  ) async {
    emit(const TicketTiersLoading());

    final result = await _getTicketTiersUseCase();
    switch (result) {
      case Success(:final data):
        final tiers = data.where((t) => t.isVisible && t.isActive).toList()
          ..sort((a, b) => a.price.compareTo(b.price));
        emit(TicketTiersLoaded(tiers));
      case Error(:final failure):
        emit(TicketTiersFailure(failure.message));
    }
  }
}
