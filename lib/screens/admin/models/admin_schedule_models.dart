class AdminScheduleItem {
  const AdminScheduleItem({
    required this.id,
    required this.name,
    this.startAt,
    this.endAt,
    this.venues = const [],
  });

  final String id;
  final String name;
  final DateTime? startAt;
  final DateTime? endAt;
  final List<AdminScheduleVenue> venues;

  int get eventCount => venues.fold(
        0,
        (sum, venue) =>
            sum +
            venue.locations.fold(
              0,
              (locSum, loc) => locSum + loc.events.length,
            ),
      );

  factory AdminScheduleItem.fromJson(Map<String, dynamic> json) {
    final venuesRaw = json['venues'];
    return AdminScheduleItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      startAt: _parseDate(json['start_at']),
      endAt: _parseDate(json['end_at']),
      venues: venuesRaw is List
          ? venuesRaw
              .whereType<Map<String, dynamic>>()
              .map(AdminScheduleVenue.fromJson)
              .toList()
          : const [],
    );
  }
}

class AdminScheduleVenue {
  const AdminScheduleVenue({
    required this.id,
    required this.name,
    this.description = '',
    this.order = 0,
    this.locations = const [],
  });

  final String id;
  final String name;
  final String description;
  final int order;
  final List<AdminScheduleLocation> locations;

  factory AdminScheduleVenue.fromJson(Map<String, dynamic> json) {
    final locationsRaw = json['locations'];
    return AdminScheduleVenue(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      order: json['order'] as int? ?? 0,
      locations: locationsRaw is List
          ? locationsRaw
              .whereType<Map<String, dynamic>>()
              .map(AdminScheduleLocation.fromJson)
              .toList()
          : const [],
    );
  }
}

class AdminScheduleLocation {
  const AdminScheduleLocation({
    required this.id,
    required this.name,
    this.description = '',
    this.order = 0,
    this.locationRefId,
    this.events = const [],
  });

  final String id;
  final String name;
  final String description;
  final int order;
  final String? locationRefId;
  final List<AdminScheduleEvent> events;

  factory AdminScheduleLocation.fromJson(Map<String, dynamic> json) {
    final eventsRaw = json['events'];
    return AdminScheduleLocation(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      order: json['order'] as int? ?? 0,
      locationRefId: json['location_ref_id']?.toString(),
      events: eventsRaw is List
          ? eventsRaw
              .whereType<Map<String, dynamic>>()
              .map(AdminScheduleEvent.fromJson)
              .toList()
          : const [],
    );
  }
}

class AdminScheduleEvent {
  const AdminScheduleEvent({
    required this.id,
    required this.title,
    this.description = '',
    required this.startAt,
    required this.endAt,
  });

  final String id;
  final String title;
  final String description;
  final DateTime startAt;
  final DateTime endAt;

  factory AdminScheduleEvent.fromJson(Map<String, dynamic> json) {
    return AdminScheduleEvent(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      startAt: _parseDate(json['start_at']) ?? DateTime.now(),
      endAt: _parseDate(json['end_at']) ?? DateTime.now(),
    );
  }
}

class AdminGlobalVenue {
  const AdminGlobalVenue({
    required this.id,
    required this.name,
    this.description = '',
    this.locations = const [],
  });

  final String id;
  final String name;
  final String description;
  final List<AdminGlobalLocation> locations;

  factory AdminGlobalVenue.fromJson(Map<String, dynamic> json) {
    final locationsRaw = json['locations'];
    return AdminGlobalVenue(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      locations: locationsRaw is List
          ? locationsRaw
              .whereType<Map<String, dynamic>>()
              .map(AdminGlobalLocation.fromJson)
              .toList()
          : const [],
    );
  }
}

class AdminGlobalLocation {
  const AdminGlobalLocation({
    required this.id,
    required this.name,
    this.description = '',
    this.order = 0,
  });

  final String id;
  final String name;
  final String description;
  final int order;

  factory AdminGlobalLocation.fromJson(Map<String, dynamic> json) {
    return AdminGlobalLocation(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      order: json['order'] as int? ?? 0,
    );
  }
}

class CreateScheduleInput {
  const CreateScheduleInput({
    required this.name,
    required this.startAt,
    required this.endAt,
  });

  final String name;
  final DateTime startAt;
  final DateTime endAt;

  Map<String, dynamic> toJson() => {
        'name': name,
        'start_at': startAt.toUtc().toIso8601String(),
        'end_at': endAt.toUtc().toIso8601String(),
      };
}

class UpdateScheduleInput {
  const UpdateScheduleInput({
    this.name,
    this.startAt,
    this.endAt,
  });

  final String? name;
  final DateTime? startAt;
  final DateTime? endAt;

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (startAt != null) 'start_at': startAt!.toUtc().toIso8601String(),
        if (endAt != null) 'end_at': endAt!.toUtc().toIso8601String(),
      };
}

class EventInput {
  const EventInput({
    required this.title,
    this.description = '',
    required this.startAt,
    required this.endAt,
  });

  final String title;
  final String description;
  final DateTime startAt;
  final DateTime endAt;

  Map<String, dynamic> toJson() => {
        'title': title,
        if (description.isNotEmpty) 'description': description,
        'start_at': startAt.toUtc().toIso8601String(),
        'end_at': endAt.toUtc().toIso8601String(),
      };
}

class CreateScheduleVenueInput {
  const CreateScheduleVenueInput({
    required this.name,
    this.description = '',
    this.order = 0,
  });

  final String name;
  final String description;
  final int order;

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description.isNotEmpty) 'description': description,
        if (order != 0) 'order': order,
      };
}

class CreateScheduleLocationInput {
  const CreateScheduleLocationInput({
    required this.name,
    this.description = '',
    this.order = 0,
  });

  final String name;
  final String description;
  final int order;

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description.isNotEmpty) 'description': description,
        if (order != 0) 'order': order,
      };
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toLocal();
  return DateTime.tryParse(value.toString())?.toLocal();
}
