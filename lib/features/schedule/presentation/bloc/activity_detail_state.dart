import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';

sealed class ActivityDetailState {
  const ActivityDetailState();
}

final class ActivityDetailInitial extends ActivityDetailState {
  const ActivityDetailInitial();
}

final class ActivityDetailLoading extends ActivityDetailState {
  const ActivityDetailLoading();
}

final class ActivityDetailLoaded extends ActivityDetailState {
  const ActivityDetailLoaded({
    required this.activity,
    required this.isBookmarked,
    this.isBookmarking = false,
    this.conflictWith,
    this.bookmarkError,
  });

  final ScheduleActivity activity;
  final bool isBookmarked;
  final bool isBookmarking;
  final ScheduleActivity? conflictWith;
  final String? bookmarkError;

  ActivityDetailLoaded copyWith({
    ScheduleActivity? activity,
    bool? isBookmarked,
    bool? isBookmarking,
    ScheduleActivity? conflictWith,
    bool clearConflict = false,
    String? bookmarkError,
    bool clearBookmarkError = false,
  }) {
    return ActivityDetailLoaded(
      activity: activity ?? this.activity,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isBookmarking: isBookmarking ?? this.isBookmarking,
      conflictWith: clearConflict ? null : (conflictWith ?? this.conflictWith),
      bookmarkError: clearBookmarkError
          ? null
          : (bookmarkError ?? this.bookmarkError),
    );
  }
}

final class ActivityDetailFailure extends ActivityDetailState {
  const ActivityDetailFailure(this.message);

  final String message;
}
