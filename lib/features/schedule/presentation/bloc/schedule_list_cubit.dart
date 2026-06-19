import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_event.dart';
import 'package:fuvekonmobile/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/schedule_list_state.dart';

class ScheduleListCubit extends Cubit<ScheduleListState> {
  ScheduleListCubit({required ScheduleRepository repository})
      : _repository = repository,
        super(const ScheduleListInitial());

  final ScheduleRepository _repository;

  Future<void> load() async {
    emit(const ScheduleListLoading());

    final eventResult = await _repository.listScheduleEvents();
    switch (eventResult) {
      case Error(:final failure):
        emit(ScheduleListFailure(failure.message));
        return;
      case Success(:final data):
        if (data.isEmpty) {
          emit(const ScheduleListFailure('No schedule available'));
          return;
        }
        final event = data.first;
        final day = DateTime(
          event.startAt.year,
          event.startAt.month,
          event.startAt.day,
        );
        await _loadActivities(event: event, day: day);
    }
  }

  Future<void> selectDay(DateTime day) async {
    final current = state;
    if (current is! ScheduleListLoaded) return;
    emit(const ScheduleListLoading());
    await _loadActivities(
      event: current.event,
      day: day,
      venueId: current.selectedVenueId,
    );
  }

  Future<void> selectVenue(String? venueId) async {
    final current = state;
    if (current is! ScheduleListLoaded) return;
    emit(const ScheduleListLoading());
    await _loadActivities(
      event: current.event,
      day: current.selectedDay,
      venueId: venueId,
    );
  }

  Future<void> _loadActivities({
    required ScheduleEvent event,
    required DateTime day,
    String? venueId,
  }) async {
    final activitiesResult = await _repository.listActivities(
      day: day,
      venueId: venueId,
    );

    switch (activitiesResult) {
      case Error(:final failure):
        emit(ScheduleListFailure(failure.message));
      case Success(:final data):
        emit(
          ScheduleListLoaded(
            event: event,
            activities: data,
            selectedDay: day,
            selectedVenueId: venueId,
          ),
        );
    }
  }
}
