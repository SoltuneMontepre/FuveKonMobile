import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/activity_detail_state.dart';

class ActivityDetailCubit extends Cubit<ActivityDetailState> {
  ActivityDetailCubit({required ScheduleRepository repository})
      : _repository = repository,
        super(const ActivityDetailInitial());

  final ScheduleRepository _repository;

  Future<void> load(String activityId) async {
    emit(const ActivityDetailLoading());

    final activityResult = await _repository.getActivity(activityId);
    switch (activityResult) {
      case Error(:final failure):
        emit(ActivityDetailFailure(failure.message));
        return;
      case Success(:final data):
        final bookmarkResult = await _repository.isInItinerary(activityId);
        final isBookmarked = switch (bookmarkResult) {
          Success(:final data) => data,
          Error() => false,
        };
        emit(ActivityDetailLoaded(activity: data, isBookmarked: isBookmarked));
    }
  }

  void clearConflict() {
    final current = state;
    if (current is ActivityDetailLoaded) {
      emit(current.copyWith(clearConflict: true));
    }
  }

  Future<void> toggleBookmark() async {
    final current = state;
    if (current is! ActivityDetailLoaded || current.isBookmarking) return;

    if (current.isBookmarked) {
      emit(current.copyWith(isBookmarking: true));
      await _repository.removeFromItinerary(current.activity.id);
      emit(current.copyWith(isBookmarked: false, isBookmarking: false));
      return;
    }

    final conflictResult =
        await _repository.findItineraryConflict(current.activity.id);
    switch (conflictResult) {
      case Error(:final failure):
        emit(ActivityDetailFailure(failure.message));
        return;
      case Success(:final data):
        if (data != null) {
          emit(
            current.copyWith(
              isBookmarking: false,
              conflictWith: data,
            ),
          );
          return;
        }
    }

    await _addBookmark(current);
  }

  Future<void> confirmReplaceConflict() async {
    final current = state;
    if (current is! ActivityDetailLoaded) return;
    emit(current.copyWith(isBookmarking: true, clearConflict: true));
    await _addBookmark(current, replaceConflict: true);
  }

  Future<void> _addBookmark(
    ActivityDetailLoaded current, {
    bool replaceConflict = false,
  }) async {
    final result = await _repository.addToItinerary(
      current.activity.id,
      replaceConflict: replaceConflict,
    );

    switch (result) {
      case Error(:final failure):
        emit(ActivityDetailFailure(failure.message));
      case Success():
        emit(
          current.copyWith(
            isBookmarked: true,
            isBookmarking: false,
            clearConflict: true,
          ),
        );
    }
  }
}
