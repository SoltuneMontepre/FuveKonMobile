import 'package:equatable/equatable.dart';

enum ScheduleActivityKind { panel, talent, workshop, ceremony, other }

class ScheduleActivity extends Equatable {
  const ScheduleActivity({
    required this.id,
    required this.scheduleEventId,
    required this.title,
    required this.description,
    required this.kind,
    required this.startAt,
    required this.endAt,
    required this.venueId,
    required this.venueName,
    required this.locationName,
    this.speakers = const [],
    this.tags = const [],
  });

  final String id;
  final String scheduleEventId;
  final String title;
  final String description;
  final ScheduleActivityKind kind;
  final DateTime startAt;
  final DateTime endAt;
  final String venueId;
  final String venueName;
  final String locationName;
  final List<String> speakers;
  final List<String> tags;

  bool overlaps(ScheduleActivity other) {
    return startAt.isBefore(other.endAt) && endAt.isAfter(other.startAt);
  }

  @override
  List<Object?> get props => [
    id,
    scheduleEventId,
    title,
    description,
    kind,
    startAt,
    endAt,
    venueId,
    venueName,
    locationName,
    speakers,
    tags,
  ];
}
