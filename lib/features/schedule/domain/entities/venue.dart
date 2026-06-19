import 'package:equatable/equatable.dart';

class VenueLocation extends Equatable {
  const VenueLocation({
    required this.id,
    required this.name,
    this.description = '',
  });

  final String id;
  final String name;
  final String description;

  @override
  List<Object?> get props => [id, name, description];
}

class Venue extends Equatable {
  const Venue({
    required this.id,
    required this.name,
    this.description = '',
    this.order = 0,
    this.mapX,
    this.mapY,
    this.locations = const [],
  });

  final String id;
  final String name;
  final String description;
  final int order;
  final double? mapX;
  final double? mapY;
  final List<VenueLocation> locations;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        order,
        mapX,
        mapY,
        locations,
      ];
}
