import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_my_ticket_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_ticket_tiers_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/upgrade_ticket_usecase.dart';

sealed class TicketUpgradeEvent {
  const TicketUpgradeEvent();
}

final class TicketUpgradeStarted extends TicketUpgradeEvent {
  const TicketUpgradeStarted();
}

final class TicketUpgradeTierSelected extends TicketUpgradeEvent {
  const TicketUpgradeTierSelected(this.tierId);

  final String tierId;
}

final class TicketUpgradeSubmitted extends TicketUpgradeEvent {
  const TicketUpgradeSubmitted();
}

sealed class TicketUpgradeState {
  const TicketUpgradeState();
}

final class TicketUpgradeInitial extends TicketUpgradeState {
  const TicketUpgradeInitial();
}

final class TicketUpgradeLoading extends TicketUpgradeState {
  const TicketUpgradeLoading();
}

final class TicketUpgradeLoaded extends TicketUpgradeState {
  const TicketUpgradeLoaded({
    required this.ticket,
    required this.options,
    required this.selectedTierId,
    this.isSubmitting = false,
  });

  final UserTicket ticket;
  final List<TicketTier> options;
  final String selectedTierId;
  final bool isSubmitting;

  TicketTier get currentTier => ticket.tier!;

  TicketTier get selectedTier =>
      options.firstWhere((t) => t.id == selectedTierId);

  double get priceDiff => selectedTier.price - currentTier.price;

  TicketUpgradeLoaded copyWith({
    UserTicket? ticket,
    List<TicketTier>? options,
    String? selectedTierId,
    bool? isSubmitting,
  }) {
    return TicketUpgradeLoaded(
      ticket: ticket ?? this.ticket,
      options: options ?? this.options,
      selectedTierId: selectedTierId ?? this.selectedTierId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

final class TicketUpgradeNoTicket extends TicketUpgradeState {
  const TicketUpgradeNoTicket();
}

final class TicketUpgradeNoOptions extends TicketUpgradeState {
  const TicketUpgradeNoOptions(this.ticket);

  final UserTicket ticket;
}

final class TicketUpgradeFailure extends TicketUpgradeState {
  const TicketUpgradeFailure(this.message);

  final String message;
}

final class TicketUpgradeSuccess extends TicketUpgradeState {
  const TicketUpgradeSuccess(this.tierId);

  final String tierId;
}

class TicketUpgradeBloc extends Bloc<TicketUpgradeEvent, TicketUpgradeState> {
  TicketUpgradeBloc({
    required GetMyTicketUseCase getMyTicketUseCase,
    required GetTicketTiersUseCase getTicketTiersUseCase,
    required UpgradeTicketUseCase upgradeTicketUseCase,
  })  : _getMyTicketUseCase = getMyTicketUseCase,
        _getTicketTiersUseCase = getTicketTiersUseCase,
        _upgradeTicketUseCase = upgradeTicketUseCase,
        super(const TicketUpgradeInitial()) {
    on<TicketUpgradeStarted>(_onStarted);
    on<TicketUpgradeTierSelected>(_onTierSelected);
    on<TicketUpgradeSubmitted>(_onSubmitted);
  }

  final GetMyTicketUseCase _getMyTicketUseCase;
  final GetTicketTiersUseCase _getTicketTiersUseCase;
  final UpgradeTicketUseCase _upgradeTicketUseCase;

  String? lastActionError;

  Future<void> _onStarted(
    TicketUpgradeStarted event,
    Emitter<TicketUpgradeState> emit,
  ) async {
    emit(const TicketUpgradeLoading());

    final ticketResult = await _getMyTicketUseCase();
    final tiersResult = await _getTicketTiersUseCase();

    if (ticketResult case Error(:final failure)) {
      emit(TicketUpgradeFailure(failure.message));
      return;
    }
    if (tiersResult case Error(:final failure)) {
      emit(TicketUpgradeFailure(failure.message));
      return;
    }

    final ticket = (ticketResult as Success<UserTicket?>).data;
    if (ticket == null || ticket.tier == null) {
      emit(const TicketUpgradeNoTicket());
      return;
    }

    if (ticket.status != TicketStatus.approved &&
        ticket.status != TicketStatus.adminGranted) {
      emit(TicketUpgradeFailure(
        'Chỉ vé đã duyệt mới được nâng cấp. Dùng DEMO vé → BTC duyệt nếu đang test.',
      ));
      return;
    }

    final allTiers = (tiersResult as Success<List<TicketTier>>).data;
    final currentPrice = ticket.tier!.price;
    final options = allTiers
        .where(
          (t) =>
              t.isActive &&
              !t.isSoldOut &&
              t.price > currentPrice,
        )
        .toList()
      ..sort((a, b) => a.price.compareTo(b.price));

    if (options.isEmpty) {
      emit(TicketUpgradeNoOptions(ticket));
      return;
    }

    emit(
      TicketUpgradeLoaded(
        ticket: ticket,
        options: options,
        selectedTierId: options.last.id,
      ),
    );
  }

  void _onTierSelected(
    TicketUpgradeTierSelected event,
    Emitter<TicketUpgradeState> emit,
  ) {
    final current = state;
    if (current is! TicketUpgradeLoaded) return;
    emit(current.copyWith(selectedTierId: event.tierId));
  }

  Future<void> _onSubmitted(
    TicketUpgradeSubmitted event,
    Emitter<TicketUpgradeState> emit,
  ) async {
    final current = state;
    if (current is! TicketUpgradeLoaded || current.isSubmitting) return;

    emit(current.copyWith(isSubmitting: true));
    final result = await _upgradeTicketUseCase(current.selectedTierId);

    switch (result) {
      case Success():
        emit(TicketUpgradeSuccess(current.selectedTierId));
      case Error(:final failure):
        lastActionError = failure.message;
        emit(current.copyWith(isSubmitting: false));
    }
  }
}

List<String> additionalUpgradeBenefits(TicketTier from, TicketTier to) {
  final existing = from.benefits.toSet();
  final added = to.benefits.where((b) => !existing.contains(b)).toList();
  return added.isNotEmpty ? added : to.benefits;
}

String currentTicketPaidLabel(TicketStatus status) {
  return switch (status) {
    TicketStatus.approved || TicketStatus.adminGranted => 'Đã thanh toán',
    TicketStatus.selfConfirmed => 'Chờ BTC duyệt',
    TicketStatus.pending => 'Chờ thanh toán',
    TicketStatus.denied => 'Đã từ chối',
  };
}
