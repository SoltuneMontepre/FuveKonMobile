import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/utils/ticket/render_namecard.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_my_ticket_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/save_name_card_usecase.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_event.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_state.dart';

class MyTicketBloc extends Bloc<MyTicketEvent, MyTicketState> {
  MyTicketBloc({
    required GetMyTicketUseCase getMyTicketUseCase,
    required GetMeUseCase getMeUseCase,
    required SaveNameCardUseCase saveNameCardUseCase,
    required NamecardRenderer namecardRenderer,
  })  : _getMyTicketUseCase = getMyTicketUseCase,
        _getMeUseCase = getMeUseCase,
        _saveNameCardUseCase = saveNameCardUseCase,
        _namecardRenderer = namecardRenderer,
        super(const MyTicketState.initial()) {
    on<MyTicketStarted>(_onLoad);
    on<MyTicketRefreshRequested>(_onLoad);
    on<MyTicketBadgeNameChanged>(_onBadgeNameChanged);
    on<MyTicketFursuiterChanged>(_onFursuiterChanged);
    on<MyTicketFursuitStaffChanged>(_onFursuitStaffChanged);
    on<MyTicketSaveNameCardRequested>(_onSaveNameCard);
    on<MyTicketPreviewRegenerateRequested>(_onPreviewRegenerate);
  }

  final GetMyTicketUseCase _getMyTicketUseCase;
  final GetMeUseCase _getMeUseCase;
  final SaveNameCardUseCase _saveNameCardUseCase;
  final NamecardRenderer _namecardRenderer;

  Uint8List? previewPngBytes;
  String? lastActionError;
  bool saveSucceeded = false;

  Future<void> _onLoad(MyTicketEvent event, Emitter<MyTicketState> emit) async {
    emit(const MyTicketState.loading());
    previewPngBytes = null;

    final ticketResult = await _getMyTicketUseCase();
    final accountResult = await _getMeUseCase();

    if (accountResult case Error(:final failure)) {
      emit(MyTicketState.failure(failure.message));
      return;
    }

    final account = (accountResult as Success<Account>).data;

    switch (ticketResult) {
      case Success(:final data):
        if (data == null || data.status == TicketStatus.denied) {
          emit(const MyTicketState.empty());
          return;
        }
        emit(
          MyTicketState.loaded(
            ticket: data,
            account: account,
            badgeName: data.conBadgeName ?? account.firstName ?? '',
            isFursuiter: data.isFursuiter,
            isFursuitStaff: data.isFursuitStaff,
          ),
        );
        final loaded = state;
        if (loaded is MyTicketLoaded &&
            loaded.canViewNameCard &&
            loaded.canEditNameCard) {
          add(const MyTicketEvent.previewRegenerateRequested());
        }
      case Error(:final failure):
        emit(MyTicketState.failure(failure.message));
    }
  }

  void _onBadgeNameChanged(
    MyTicketBadgeNameChanged event,
    Emitter<MyTicketState> emit,
  ) {
    final current = state;
    if (current is! MyTicketLoaded) return;
    emit(current.copyWith(badgeName: event.value));
    add(const MyTicketEvent.previewRegenerateRequested());
  }

  void _onFursuiterChanged(
    MyTicketFursuiterChanged event,
    Emitter<MyTicketState> emit,
  ) {
    final current = state;
    if (current is! MyTicketLoaded) return;
    emit(current.copyWith(isFursuiter: event.value));
    add(const MyTicketEvent.previewRegenerateRequested());
  }

  void _onFursuitStaffChanged(
    MyTicketFursuitStaffChanged event,
    Emitter<MyTicketState> emit,
  ) {
    final current = state;
    if (current is! MyTicketLoaded) return;
    emit(current.copyWith(isFursuitStaff: event.value));
    add(const MyTicketEvent.previewRegenerateRequested());
  }

  Future<void> _onPreviewRegenerate(
    MyTicketPreviewRegenerateRequested event,
    Emitter<MyTicketState> emit,
  ) async {
    final current = state;
    if (current is! MyTicketLoaded) return;
    if (!current.canViewNameCard || !current.canEditNameCard) return;

    emit(current.copyWith(isGeneratingPreview: true));
    try {
      final tierCode = current.tierCodeNumber;
      if (tierCode < 1) return;
      previewPngBytes = await _namecardRenderer.renderPng(
        RenderNamecardOptions(
          tierCodeNumber: tierCode,
          avatarUrl: current.account.avatar,
          previewName: current.previewName,
          referenceCode: current.ticket.referenceCode,
          isFursuiter: current.isFursuiter,
          isFursuitStaff: current.isFursuitStaff,
          isDealer: current.account.isDealer == true,
        ),
      );
    } catch (_) {
      previewPngBytes = null;
    } finally {
      final latest = state;
      if (latest is MyTicketLoaded) {
        emit(latest.copyWith(isGeneratingPreview: false));
      }
    }
  }

  Future<void> _onSaveNameCard(
    MyTicketSaveNameCardRequested event,
    Emitter<MyTicketState> emit,
  ) async {
    final current = state;
    if (current is! MyTicketLoaded) return;

    emit(current.copyWith(isSavingNameCard: true));
    lastActionError = null;

    final result = await _saveNameCardUseCase(
      ticket: current.ticket,
      account: current.account,
      badgeName: current.badgeName,
      isFursuiter: current.isFursuiter,
      isFursuitStaff: current.isFursuitStaff,
    );

    switch (result) {
      case Success(:final data):
        saveSucceeded = true;
        emit(
          current.copyWith(
            ticket: data,
            badgeName: data.conBadgeName ?? current.badgeName,
            isFursuiter: data.isFursuiter,
            isFursuitStaff: data.isFursuitStaff,
            isSavingNameCard: false,
          ),
        );
        add(const MyTicketEvent.previewRegenerateRequested());
      case Error(:final failure):
        lastActionError = failure.message;
        emit(current.copyWith(isSavingNameCard: false));
    }
  }
}
