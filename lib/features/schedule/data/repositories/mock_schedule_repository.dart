import 'package:fuvekonmobile/core/errors/failures.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/featured_event_summary.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/itinerary_item.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_activity.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/schedule_event.dart';
import 'package:fuvekonmobile/features/schedule/domain/entities/venue.dart';
import 'package:fuvekonmobile/features/schedule/domain/repositories/schedule_repository.dart';

/// Realistic Vietnamese mock data until itinerary endpoints ship.
class MockScheduleRepository implements ScheduleRepository {
  MockScheduleRepository() {
    _seed();
  }

  static const scheduleEventId = 'sched-fuvekon-2026';

  late ScheduleEvent _event;
  late List<ScheduleActivity> _activities;
  late List<Venue> _venues;
  final List<ItineraryItem> _itinerary = [];

  void _seed() {
    final day1 = DateTime(2026, 8, 15);
    final day2 = DateTime(2026, 8, 16);

    _venues = [
      const Venue(
        id: 'venue-main',
        name: 'Sân khấu chính',
        description:
            'Khu vực biểu diễn chính với sức chứa 800 khán giả, âm thanh và ánh sáng chuyên nghiệp.',
        order: 1,
        mapX: 0.5,
        mapY: 0.28,
        locations: [
          VenueLocation(
            id: 'loc-main-stage',
            name: 'Main Stage',
            description: 'Sân khấu trung tâm hội trường.',
          ),
        ],
      ),
      const Venue(
        id: 'venue-hall-a',
        name: 'Hall A',
        description: 'Phòng hội thảo lớn dành cho panel và workshop.',
        order: 2,
        mapX: 0.22,
        mapY: 0.55,
        locations: [
          VenueLocation(
            id: 'loc-hall-a',
            name: 'Hall A',
            description: 'Tầng 2, khu B.',
          ),
        ],
      ),
      const Venue(
        id: 'venue-hall-b',
        name: 'Hall B',
        description: 'Không gian panel nhỏ và giao lưu fan.',
        order: 3,
        mapX: 0.78,
        mapY: 0.55,
        locations: [
          VenueLocation(
            id: 'loc-hall-b',
            name: 'Hall B',
            description: 'Tầng 2, khu C.',
          ),
        ],
      ),
      const Venue(
        id: 'venue-cosplay',
        name: 'Khu Cosplay',
        description: 'Sân chụp ảnh và biểu diễn cosplay ngoài trời.',
        order: 4,
        mapX: 0.5,
        mapY: 0.78,
        locations: [
          VenueLocation(
            id: 'loc-cosplay-ring',
            name: 'Cosplay Ring',
            description: 'Vòng sân cosplay phía sau hội trường.',
          ),
        ],
      ),
    ];

    _activities = [
      ScheduleActivity(
        id: 'act-opening',
        scheduleEventId: scheduleEventId,
        title: 'Lễ khai mạc FUVEKON 2026',
        description:
            'Khai mạc chính thức với phát biểu của BTC, màn trình diễn mở đầu và giới thiệu chương trình 2 ngày.',
        kind: ScheduleActivityKind.ceremony,
        startAt: DateTime(day1.year, day1.month, day1.day, 9, 0),
        endAt: DateTime(day1.year, day1.month, day1.day, 9, 45),
        venueId: 'venue-main',
        venueName: 'Sân khấu chính',
        locationName: 'Main Stage',
        tags: const ['Khai mạc', 'Toàn thể'],
      ),
      ScheduleActivity(
        id: 'act-panel-voice',
        scheduleEventId: scheduleEventId,
        title: 'Panel Voice Actor',
        description:
            'Giao lưu cùng diễn viên lồng tiếng quốc tế: hành trình nghề nghiệp, kỹ thuật dubbing và Q&A với khán giả.',
        kind: ScheduleActivityKind.panel,
        startAt: DateTime(day1.year, day1.month, day1.day, 10, 30),
        endAt: DateTime(day1.year, day1.month, day1.day, 12, 0),
        venueId: 'venue-hall-a',
        venueName: 'Hall A',
        locationName: 'Hall A',
        speakers: const ['Nguyễn Minh An', 'Guest VA (JP)'],
        tags: const ['Panel', 'Voice'],
      ),
      ScheduleActivity(
        id: 'act-furry-art',
        scheduleEventId: scheduleEventId,
        title: 'Furry Art Live',
        description:
            'Phiên live vẽ trực tiếp cùng họa sĩ furry nổi tiếng. Khán giả có thể đặt câu hỏi và nhận sketch mini.',
        kind: ScheduleActivityKind.workshop,
        startAt: DateTime(day1.year, day1.month, day1.day, 14, 0),
        endAt: DateTime(day1.year, day1.month, day1.day, 15, 30),
        venueId: 'venue-hall-b',
        venueName: 'Hall B',
        locationName: 'Hall B',
        speakers: const ['Artist Kuro'],
        tags: const ['Workshop', 'Art'],
      ),
      ScheduleActivity(
        id: 'act-talent-1',
        scheduleEventId: scheduleEventId,
        title: 'Talent Show — Vòng loại',
        description:
            'Tiết mục biểu diễn đa dạng: ca hát, cosplay performance, nhảy và skit. Top 8 vào chung kết ngày 2.',
        kind: ScheduleActivityKind.talent,
        startAt: DateTime(day1.year, day1.month, day1.day, 16, 0),
        endAt: DateTime(day1.year, day1.month, day1.day, 18, 0),
        venueId: 'venue-main',
        venueName: 'Sân khấu chính',
        locationName: 'Main Stage',
        tags: const ['Talent', 'Biểu diễn'],
      ),
      ScheduleActivity(
        id: 'act-cosplay-parade',
        scheduleEventId: scheduleEventId,
        title: 'Cosplay Parade',
        description:
            'Đại parade cosplay quanh khu hội trường. Đăng ký tại quầy Cosplay Desk trước 15:30.',
        kind: ScheduleActivityKind.ceremony,
        startAt: DateTime(day1.year, day1.month, day1.day, 14, 30),
        endAt: DateTime(day1.year, day1.month, day1.day, 15, 30),
        venueId: 'venue-cosplay',
        venueName: 'Khu Cosplay',
        locationName: 'Cosplay Ring',
        tags: const ['Cosplay', 'Parade'],
      ),
      ScheduleActivity(
        id: 'act-panel-indie',
        scheduleEventId: scheduleEventId,
        title: 'Panel Indie Game Việt',
        description:
            'Các studio indie chia sẻ kinh nghiệm phát triển game tại Việt Nam và demo gameplay.',
        kind: ScheduleActivityKind.panel,
        startAt: DateTime(day2.year, day2.month, day2.day, 10, 0),
        endAt: DateTime(day2.year, day2.month, day2.day, 11, 30),
        venueId: 'venue-hall-a',
        venueName: 'Hall A',
        locationName: 'Hall A',
        speakers: const ['Studio Meow', 'Pixel Dragon'],
        tags: const ['Panel', 'Game'],
      ),
      ScheduleActivity(
        id: 'act-talent-final',
        scheduleEventId: scheduleEventId,
        title: 'Talent Show — Chung kết',
        description:
            'Chung kết Talent Show ngày 2 với ban giám khảo chuyên môn và trao giải.',
        kind: ScheduleActivityKind.talent,
        startAt: DateTime(day2.year, day2.month, day2.day, 14, 0),
        endAt: DateTime(day2.year, day2.month, day2.day, 16, 30),
        venueId: 'venue-main',
        venueName: 'Sân khấu chính',
        locationName: 'Main Stage',
        tags: const ['Talent', 'Chung kết'],
      ),
      ScheduleActivity(
        id: 'act-closing',
        scheduleEventId: scheduleEventId,
        title: 'Lễ bế mạc',
        description:
            'Tổng kết sự kiện, cảm ơn nhà tài trợ và hẹn gặp lại FUVEKON 2027.',
        kind: ScheduleActivityKind.ceremony,
        startAt: DateTime(day2.year, day2.month, day2.day, 17, 0),
        endAt: DateTime(day2.year, day2.month, day2.day, 17, 45),
        venueId: 'venue-main',
        venueName: 'Sân khấu chính',
        locationName: 'Main Stage',
        tags: const ['Bế mạc'],
      ),
    ];

    _event = ScheduleEvent(
      id: scheduleEventId,
      name: kHomeFeaturedEvent.title,
      description: kHomeFeaturedEvent.description,
      startAt: day1,
      endAt: DateTime(day2.year, day2.month, day2.day, 23, 59, 59),
      venues: _venues,
      locationLabel: kHomeFeaturedEvent.locationLabel,
      tags: kHomeFeaturedEvent.tags,
      heroImageAsset: kHomeFeaturedEvent.imageAsset,
    );
  }

  ScheduleActivity? _activityById(String id) {
    try {
      return _activities.firstWhere((a) => a.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  Future<Result<List<ScheduleEvent>>> listScheduleEvents() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return Success([_event]);
  }

  @override
  Future<Result<ScheduleEvent>> getScheduleEvent(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (id == _event.id) return Success(_event);
    return const Error(ValidationFailure('Schedule event not found'));
  }

  @override
  Future<Result<List<ScheduleActivity>>> listActivities({
    DateTime? day,
    String? venueId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    var filtered = _activities;
    if (day != null) {
      filtered = filtered
          .where(
            (a) =>
                a.startAt.year == day.year &&
                a.startAt.month == day.month &&
                a.startAt.day == day.day,
          )
          .toList();
    }
    if (venueId != null && venueId.isNotEmpty) {
      filtered = filtered.where((a) => a.venueId == venueId).toList();
    }
    filtered.sort((a, b) => a.startAt.compareTo(b.startAt));
    return Success(filtered);
  }

  @override
  Future<Result<ScheduleActivity>> getActivity(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final activity = _activityById(id);
    if (activity == null) {
      return const Error(ValidationFailure('Activity not found'));
    }
    return Success(activity);
  }

  @override
  Future<Result<List<Venue>>> listVenues() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return Success([..._venues]..sort((a, b) => a.order.compareTo(b.order)));
  }

  @override
  Future<Result<Venue>> getVenue(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      return Success(_venues.firstWhere((v) => v.id == id));
    } on StateError {
      return const Error(ValidationFailure('Venue not found'));
    }
  }

  @override
  Future<Result<List<ItineraryItem>>> getItinerary() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final sorted = [..._itinerary]
      ..sort((a, b) => a.activity.startAt.compareTo(b.activity.startAt));
    return Success(sorted);
  }

  @override
  Future<Result<ScheduleActivity?>> findItineraryConflict(
    String activityId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final activity = _activityById(activityId);
    if (activity == null) {
      return const Error(ValidationFailure('Activity not found'));
    }
    for (final item in _itinerary) {
      if (item.activityId == activityId) continue;
      if (activity.overlaps(item.activity)) {
        return Success(item.activity);
      }
    }
    return const Success(null);
  }

  @override
  Future<Result<ItineraryItem>> addToItinerary(
    String activityId, {
    bool replaceConflict = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final activity = _activityById(activityId);
    if (activity == null) {
      return const Error(ValidationFailure('Activity not found'));
    }

    if (_itinerary.any((i) => i.activityId == activityId)) {
      final existing = _itinerary.firstWhere((i) => i.activityId == activityId);
      return Success(existing);
    }

    ScheduleActivity? conflict;
    for (final item in _itinerary) {
      if (activity.overlaps(item.activity)) {
        conflict = item.activity;
        break;
      }
    }

    if (conflict != null && !replaceConflict) {
      return Error(ValidationFailure('Conflicts with "${conflict.title}"'));
    }

    if (conflict != null && replaceConflict) {
      _itinerary.removeWhere((i) => i.activityId == conflict!.id);
    }

    final item = ItineraryItem(
      id: 'it-$activityId-${DateTime.now().millisecondsSinceEpoch}',
      activityId: activityId,
      activity: activity,
      addedAt: DateTime.now(),
    );
    _itinerary.add(item);
    return Success(item);
  }

  @override
  Future<Result<void>> removeFromItinerary(String activityId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _itinerary.removeWhere((i) => i.activityId == activityId);
    return const Success(null);
  }

  @override
  Future<Result<bool>> isInItinerary(String activityId) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return Success(_itinerary.any((i) => i.activityId == activityId));
  }
}
