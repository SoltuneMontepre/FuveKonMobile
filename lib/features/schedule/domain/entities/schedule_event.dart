import 'package:equatable/equatable.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/venue.dart';

class ScheduleEvent extends Equatable {
  const ScheduleEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.startAt,
    required this.endAt,
    this.venues = const [],
  });

  final String id;
  final String name;
  final String description;
  final DateTime startAt;
  final DateTime endAt;
  final List<Venue> venues;

  @override
  List<Object?> get props => [id, name, description, startAt, endAt, venues];
}
