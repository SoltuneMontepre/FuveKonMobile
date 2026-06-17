class AdminScheduleItem {
  const AdminScheduleItem({
    required this.id,
    required this.name,
    this.startAt,
    this.endAt,
    this.dayCount = 0,
    this.timelineItemCount = 0,
    this.days = const [],
  });

  final String id;
  final String name;
  final DateTime? startAt;
  final DateTime? endAt;
  final int dayCount;
  final int timelineItemCount;
  final List<AdminScheduleDay> days;

  factory AdminScheduleItem.fromJson(Map<String, dynamic> json) {
    final daysRaw = json['days'];
    return AdminScheduleItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      startAt: _parseDate(json['start_at']),
      endAt: _parseDate(json['end_at']),
      dayCount: json['day_count'] as int? ?? 0,
      timelineItemCount: json['timeline_item_count'] as int? ?? 0,
      days: daysRaw is List
          ? daysRaw
                .whereType<Map<String, dynamic>>()
                .map(AdminScheduleDay.fromJson)
                .toList()
          : const [],
    );
  }
}

class AdminScheduleDay {
  const AdminScheduleDay({
    required this.date,
    this.timeline = const [],
  });

  final String date;
  final List<AdminTimelineItem> timeline;

  factory AdminScheduleDay.fromJson(Map<String, dynamic> json) {
    final timelineRaw = json['timeline'];
    return AdminScheduleDay(
      date: json['date']?.toString() ?? '',
      timeline: timelineRaw is List
          ? timelineRaw
                .whereType<Map<String, dynamic>>()
                .map(AdminTimelineItem.fromJson)
                .toList()
          : const [],
    );
  }
}

class AdminTimelineItem {
  const AdminTimelineItem({
    required this.id,
    required this.title,
    this.description = '',
    required this.startAt,
    required this.endAt,
    this.category = '',
    this.location = '',
  });

  final String id;
  final String title;
  final String description;
  final DateTime startAt;
  final DateTime endAt;
  final String category;
  final String location;

  factory AdminTimelineItem.fromJson(Map<String, dynamic> json) {
    return AdminTimelineItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      startAt: _parseDate(json['start_at']) ?? DateTime.now(),
      endAt: _parseDate(json['end_at']) ?? DateTime.now(),
      category: json['category']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
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
  const UpdateScheduleInput({this.name, this.startAt, this.endAt});

  final String? name;
  final DateTime? startAt;
  final DateTime? endAt;

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (startAt != null) 'start_at': startAt!.toUtc().toIso8601String(),
    if (endAt != null) 'end_at': endAt!.toUtc().toIso8601String(),
  };
}

class TimelineItemInput {
  const TimelineItemInput({
    required this.title,
    this.description = '',
    required this.startAt,
    required this.endAt,
    this.category = '',
    this.location = '',
  });

  final String title;
  final String description;
  final DateTime startAt;
  final DateTime endAt;
  final String category;
  final String location;

  Map<String, dynamic> toJson() => {
    'title': title,
    if (description.isNotEmpty) 'description': description,
    'start_at': startAt.toUtc().toIso8601String(),
    'end_at': endAt.toUtc().toIso8601String(),
    if (category.isNotEmpty) 'category': category,
    if (location.isNotEmpty) 'location': location,
  };
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toLocal();
  return DateTime.tryParse(value.toString())?.toLocal();
}
