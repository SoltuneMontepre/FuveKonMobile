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
  });

  final ScheduleActivity activity;
  final bool isBookmarked;
  final bool isBookmarking;
  final ScheduleActivity? conflictWith;

  ActivityDetailLoaded copyWith({
    ScheduleActivity? activity,
    bool? isBookmarked,
    bool? isBookmarking,
    ScheduleActivity? conflictWith,
    bool clearConflict = false,
  }) {
    return ActivityDetailLoaded(
      activity: activity ?? this.activity,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isBookmarking: isBookmarking ?? this.isBookmarking,
      conflictWith:
          clearConflict ? null : (conflictWith ?? this.conflictWith),
    );
  }
}

final class ActivityDetailFailure extends ActivityDetailState {
  const ActivityDetailFailure(this.message);

  final String message;
}
