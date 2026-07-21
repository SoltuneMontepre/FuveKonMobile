import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';
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
      bookmarkedActivityIds: current.bookmarkedActivityIds,
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
      bookmarkedActivityIds: current.bookmarkedActivityIds,
    );
  }

  /// Narrows the currently loaded day's activities to [kind]. `null` clears
  /// the filter back to "all categories". Purely client-side: no new
  /// activities need to be fetched.
  void selectKind(ScheduleActivityKind? kind) {
    final current = state;
    if (current is! ScheduleListLoaded) return;
    emit(current.copyWith(selectedKind: kind, clearSelectedKind: kind == null));
  }

  Future<void> toggleBookmark(ScheduleActivity activity) async {
    final current = state;
    if (current is! ScheduleListLoaded) return;

    if (current.isBookmarked(activity.id)) {
      final result = await _repository.removeFromItinerary(activity.id);
      switch (result) {
        case Error(:final failure):
          emit(current.copyWith(bookmarkError: failure.message));
        case Success():
          emit(
            current.copyWith(
              bookmarkedActivityIds: {...current.bookmarkedActivityIds}
                ..remove(activity.id),
              clearBookmarkError: true,
            ),
          );
      }
      return;
    }

    final result = await _repository.addToItinerary(activity.id);
    switch (result) {
      case Error(:final failure):
        emit(current.copyWith(bookmarkError: failure.message));
      case Success():
        emit(
          current.copyWith(
            bookmarkedActivityIds: {
              ...current.bookmarkedActivityIds,
              activity.id,
            },
            clearBookmarkError: true,
          ),
        );
    }
  }

  void clearBookmarkError() {
    final current = state;
    if (current is ScheduleListLoaded && current.bookmarkError != null) {
      emit(current.copyWith(clearBookmarkError: true));
    }
  }

  Future<void> _loadActivities({
    required ScheduleEvent event,
    required DateTime day,
    String? venueId,
    Set<String>? bookmarkedActivityIds,
  }) async {
    final activitiesResult = await _repository.listActivities(
      day: day,
      venueId: venueId,
    );

    switch (activitiesResult) {
      case Error(:final failure):
        emit(ScheduleListFailure(failure.message));
      case Success(:final data):
        final resolvedBookmarks =
            bookmarkedActivityIds ?? await _loadBookmarkedActivityIds();
        emit(
          ScheduleListLoaded(
            event: event,
            activities: data,
            selectedDay: day,
            selectedVenueId: venueId,
            bookmarkedActivityIds: resolvedBookmarks,
          ),
        );
    }
  }

  Future<Set<String>> _loadBookmarkedActivityIds() async {
    final result = await _repository.getItinerary();
    return switch (result) {
      Success(:final data) => data.map((item) => item.activityId).toSet(),
      Error() => const {},
    };
  }
}
