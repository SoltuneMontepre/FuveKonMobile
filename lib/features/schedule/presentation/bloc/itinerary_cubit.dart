import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/itinerary_state.dart';

class ItineraryCubit extends Cubit<ItineraryState> {
  ItineraryCubit({required ScheduleRepository repository})
    : _repository = repository,
      super(const ItineraryInitial());

  final ScheduleRepository _repository;

  Future<void> load() async {
    emit(const ItineraryLoading());
    final result = await _repository.getItinerary();

    switch (result) {
      case Success(:final data):
        if (data.isEmpty) {
          emit(const ItineraryEmpty());
        } else {
          emit(ItineraryLoaded(data));
        }
      case Error(:final failure):
        emit(ItineraryFailure(failure.message));
    }
  }

  Future<void> remove(String activityId) async {
    await _repository.removeFromItinerary(activityId);
    await load();
  }

  Future<void> refresh() => load();
}
