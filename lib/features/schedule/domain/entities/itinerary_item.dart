import 'package:equatable/equatable.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';

class ItineraryItem extends Equatable {
  const ItineraryItem({
    required this.id,
    required this.activityId,
    required this.activity,
    required this.addedAt,
  });

  final String id;
  final String activityId;
  final ScheduleActivity activity;
  final DateTime addedAt;

  @override
  List<Object?> get props => [id, activityId, activity, addedAt];
}
