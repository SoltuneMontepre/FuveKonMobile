import 'package:fuvekonmobile/core/api/analytics_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';

class AdminDashboardData {
  const AdminDashboardData({
    required this.totalTickets,
    required this.approvedCount,
    required this.pendingCount,
    required this.deniedCount,
    required this.userCount,
    required this.dealerCount,
    required this.totalRevenue,
    required this.tierStats,
    required this.salesTimeline,
  });

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) {
    final ticketStats = json['ticket_stats'] as Map<String, dynamic>?;
    final revenue = json['revenue'] as Map<String, dynamic>?;
    final tierList = ticketStats?['tier_stats'] as List<dynamic>? ?? const [];
    final timeline = json['sales_timeline'] as List<dynamic>? ?? const [];

    return AdminDashboardData(
      totalTickets: (ticketStats?['total_tickets'] as num?)?.toInt() ?? 0,
      approvedCount: (ticketStats?['approved_count'] as num?)?.toInt() ?? 0,
      pendingCount: (ticketStats?['pending_count'] as num?)?.toInt() ?? 0,
      deniedCount: (ticketStats?['denied_count'] as num?)?.toInt() ?? 0,
      userCount: (json['user_count'] as num?)?.toInt() ?? 0,
      dealerCount: (json['dealer_count'] as num?)?.toInt() ?? 0,
      totalRevenue: (revenue?['total_revenue'] as num?)?.toDouble() ?? 0,
      tierStats: tierList
          .whereType<Map<String, dynamic>>()
          .map(TierStat.fromJson)
          .toList(),
      salesTimeline: timeline
          .whereType<Map<String, dynamic>>()
          .map(SalesTimelinePoint.fromJson)
          .toList(),
    );
  }

  final int totalTickets;
  final int approvedCount;
  final int pendingCount;
  final int deniedCount;
  final int userCount;
  final int dealerCount;
  final double totalRevenue;
  final List<TierStat> tierStats;
  final List<SalesTimelinePoint> salesTimeline;
}

class TierStat {
  const TierStat({
    required this.tierName,
    required this.sold,
    required this.available,
    required this.totalStock,
  });

  factory TierStat.fromJson(Map<String, dynamic> json) {
    return TierStat(
      tierName: json['tier_name'] as String? ?? '',
      sold: (json['sold'] as num?)?.toInt() ?? 0,
      available: (json['available'] as num?)?.toInt() ?? 0,
      totalStock: (json['total_stock'] as num?)?.toInt() ?? 0,
    );
  }

  final String tierName;
  final int sold;
  final int available;
  final int totalStock;
}

class SalesTimelinePoint {
  const SalesTimelinePoint({required this.date, required this.count});

  factory SalesTimelinePoint.fromJson(Map<String, dynamic> json) {
    return SalesTimelinePoint(
      date: json['date'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  final String date;
  final int count;
}

class AdminDashboardService {
  AdminDashboardService({required AnalyticsApi analyticsApi})
      : _api = analyticsApi;

  final AnalyticsApi _api;

  Future<AdminDashboardData> getDashboard() async {
    final now = DateTime.now().toUtc();
    final from = now.subtract(const Duration(days: 90));
    final params = DashboardAnalyticsParams(
      timelineFrom: from.toIso8601String(),
      timelineTo: now.toIso8601String(),
      timelineGranularity: 'day',
      revenueFrom: from.toIso8601String(),
      revenueTo: now.toIso8601String(),
      revenueGranularity: 'day',
    );

    final response = await _api.getDashboard(params);
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }

    return AdminDashboardData.fromJson(response.data!);
  }
}
