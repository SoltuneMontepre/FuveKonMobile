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
  });

  final ScheduleEvent event;
  final List<ScheduleActivity> activities;
  final DateTime selectedDay;
  final String? selectedVenueId;
}

final class ScheduleListFailure extends ScheduleListState {
  const ScheduleListFailure(this.message);

  final String message;
}
