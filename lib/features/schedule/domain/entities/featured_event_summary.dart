/// Lightweight featured-event payload for the authenticated home card./// Phase 1: const data until a featured-events API ships.
class FeaturedEventSummary {
  const FeaturedEventSummary({
    required this.id,
    required this.title,
    required this.description,
    required this.locationLabel,
    required this.startAt,
    required this.endAt,
    required this.imageAsset,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String description;
  final String locationLabel;
  final DateTime startAt;
  final DateTime endAt;
  final String imageAsset;
  final List<String> tags;

  bool get isPast => endAt.isBefore(DateTime.now());
}

/// Home featured card — aligned with Figma Màn 13 (FUVEKON 2026).
final kHomeFeaturedEvent = FeaturedEventSummary(
  id: 'sched-fuvekon-2026',
  title: 'FUVEKON 2026',
  description:
      'FUVEKON 2026 là sự kiện giao lưu văn hóa đại chúng lớn nhất năm, '
      'quy tụ hàng ngàn người đam mê anime, manga, game và cosplay. '
      'Khám phá không gian triển lãm nghệ thuật đỉnh cao, gặp gỡ các khách mời '
      'quốc tế và đắm chìm trong không khí lễ hội sôi động.',
  locationLabel: 'Trung tâm Hội chợ và Triển lãm Sài Gòn (SECC)',
  startAt: DateTime(2026, 8, 15),
  endAt: DateTime(2026, 8, 16, 23, 59, 59),
  imageAsset: 'assets/images/event.png',
  tags: ['TRIỂN LÃM', 'POP CULTURE'],
);
