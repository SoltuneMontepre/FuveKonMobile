import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_event.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_schedule_models.dart';

ScheduleEvent scheduleEventFromAdminItem(AdminScheduleItem item) {
  final startAt = item.startAt ?? DateTime.now();
  final endAt = item.endAt ?? startAt.add(const Duration(days: 1));

  return ScheduleEvent(
    id: item.id,
    name: item.name,
    description: '',
    startAt: startAt,
    endAt: endAt,
    locationLabel: _primaryLocationLabel(item),
  );
}

ScheduleActivity scheduleActivityFromTimelineItem({
  required AdminTimelineItem item,
  required String scheduleEventId,
}) {
  final location = item.location.trim();
  final venueId = location.isNotEmpty
      ? 'venue-${location.toLowerCase().replaceAll(RegExp(r'\s+'), '-')}'
      : 'venue-unknown';

  return ScheduleActivity(
    id: item.id,
    scheduleEventId: scheduleEventId,
    title: item.title,
    description: item.description,
    kind: _mapCategory(item.category),
    startAt: item.startAt,
    endAt: item.endAt,
    venueId: venueId,
    venueName: location.isNotEmpty ? location : 'TBA',
    locationName: location.isNotEmpty ? location : 'TBA',
    tags: item.category.isNotEmpty ? [item.category] : const [],
  );
}

List<ScheduleActivity> activitiesFromScheduleDetail(AdminScheduleItem item) {
  final activities = <ScheduleActivity>[];
  for (final day in item.days) {
    for (final timelineItem in day.timeline) {
      activities.add(
        scheduleActivityFromTimelineItem(
          item: timelineItem,
          scheduleEventId: item.id,
        ),
      );
    }
  }
  return activities;
}

String _primaryLocationLabel(AdminScheduleItem item) {
  for (final day in item.days) {
    for (final timelineItem in day.timeline) {
      if (timelineItem.location.trim().isNotEmpty) {
        return timelineItem.location.trim();
      }
    }
  }
  return '';
}

ScheduleActivityKind _mapCategory(String category) {
  final normalized = category.trim().toLowerCase();
  return switch (normalized) {
    'panel' => ScheduleActivityKind.panel,
    'talent' => ScheduleActivityKind.talent,
    'workshop' => ScheduleActivityKind.workshop,
    'ceremony' => ScheduleActivityKind.ceremony,
    _ => ScheduleActivityKind.other,
  };
}

AdminScheduleItem adminScheduleItemFromJson(Map<String, dynamic> json) {
  return AdminScheduleItem.fromJson(json);
}

AdminScheduleItem adminScheduleItemFromListEntry(Map<String, dynamic> json) {
  return AdminScheduleItem.fromJson(json);
}
