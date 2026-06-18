import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';

/// Stable mock tier IDs used in routes (`/ticket/:id`, `/ticket/purchase/:id`).
abstract final class MockTicketIds {
  static const standard = 'mock-tier-standard';
  static const vip = 'mock-tier-vip';
  static const sponsor = 'mock-tier-sponsor';
}

abstract final class MockTicketData {
  static const tiers = [
    TicketTier(
      id: MockTicketIds.standard,
      tierCode: 'T1',
      ticketName: 'Standard',
      description: 'Vé tiêu chuẩn — tham gia sự kiện, badge và quà cơ bản.',
      benefits: [
        '1-Day Event Pass',
        'Standard Name Badge',
        'Basic Gift Set',
      ],
      price: 150000,
      priceUsd: 6,
      isSoldOut: false,
      isActive: true,
      isVisible: true,
    ),
    TicketTier(
      id: MockTicketIds.vip,
      tierCode: 'T2',
      ticketName: 'VIP',
      description: 'Check-in ưu tiên, badge tùy chỉnh và bộ quà nâng cao.',
      benefits: [
        'Lối đi ưu tiên riêng biệt (Fast Track)',
        'Khu vực Lounge VIP với thức uống miễn phí',
        'Túi quà tặng (Gift bag) phiên bản giới hạn',
      ],
      price: 750000,
      priceUsd: 30,
      isSoldOut: false,
      isActive: true,
      isVisible: true,
    ),
    TicketTier(
      id: MockTicketIds.sponsor,
      tierCode: 'T3',
      ticketName: 'Super Sponsor',
      description: 'Trải nghiệm thượng lưu trọn vẹn',
      benefits: [
        'Ký tặng Seiyuu riêng (Slot Private)',
        'Đặc quyền Tea-break tại VIP Lounge',
        'Set quà tặng Ultra-rare phiên bản giới hạn',
      ],
      price: 1500000,
      priceUsd: 60,
      isSoldOut: false,
      isActive: true,
      isVisible: true,
    ),
  ];

  static TicketTier? tierById(String id) {
    for (final tier in tiers) {
      if (tier.id == id) return tier;
    }
    return null;
  }

  static TicketTier tierOrDefault(String id) =>
      tierById(id) ?? tiers.first;
}
