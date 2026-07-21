import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_event.dart';

sealed class ScheduleListState {
  const ScheduleListState();
}

final class ScheduleListInitial extends ScheduleListState {
  const ScheduleListInitial();
}

final class ScheduleListLoading extends ScheduleListState {
  const ScheduleListLoading();
}

final class ScheduleListLoaded extends ScheduleListState {
  const ScheduleListLoaded({
    required this.event,
    required this.activities,
    required this.selectedDay,
    this.selectedVenueId,
    this.selectedKind,
    this.bookmarkedActivityIds = const {},
    this.bookmarkError,
  });

  final ScheduleEvent event;
  final List<ScheduleActivity> activities;
  final DateTime selectedDay;
  final String? selectedVenueId;

  /// `null` means the "all categories" filter is active.
  final ScheduleActivityKind? selectedKind;
  final Set<String> bookmarkedActivityIds;
  final String? bookmarkError;

  /// Activities for [selectedDay], narrowed further by [selectedKind].
  List<ScheduleActivity> get filteredActivities {
    final kind = selectedKind;
    if (kind == null) return activities;
    return activities.where((activity) => activity.kind == kind).toList();
  }

  bool isBookmarked(String activityId) =>
      bookmarkedActivityIds.contains(activityId);

  ScheduleListLoaded copyWith({
    ScheduleEvent? event,
    List<ScheduleActivity>? activities,
    DateTime? selectedDay,
    String? selectedVenueId,
    ScheduleActivityKind? selectedKind,
    bool clearSelectedKind = false,
    Set<String>? bookmarkedActivityIds,
    String? bookmarkError,
    bool clearBookmarkError = false,
  }) {
    return ScheduleListLoaded(
      event: event ?? this.event,
      activities: activities ?? this.activities,
      selectedDay: selectedDay ?? this.selectedDay,
      selectedVenueId: selectedVenueId ?? this.selectedVenueId,
      selectedKind: clearSelectedKind
          ? null
          : (selectedKind ?? this.selectedKind),
      bookmarkedActivityIds:
          bookmarkedActivityIds ?? this.bookmarkedActivityIds,
      bookmarkError: clearBookmarkError
          ? null
          : (bookmarkError ?? this.bookmarkError),
    );
  }
}

final class ScheduleListFailure extends ScheduleListState {
  const ScheduleListFailure(this.message);

  final String message;
}
