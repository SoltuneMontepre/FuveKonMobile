import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// Dashboard params matching `DashboardAnalyticsParams` in `useDashboardAnalytics.ts`.
class DashboardAnalyticsParams {
  const DashboardAnalyticsParams({
    required this.timelineFrom,
    required this.timelineTo,
    required this.timelineGranularity,
    required this.revenueFrom,
    required this.revenueTo,
    required this.revenueGranularity,
  });

  final String timelineFrom;
  final String timelineTo;
  final String timelineGranularity;
  final String revenueFrom;
  final String revenueTo;
  final String revenueGranularity;

  Map<String, dynamic> toQuery() => {
        'timeline_from': timelineFrom,
        'timeline_to': timelineTo,
        'timeline_granularity': timelineGranularity,
        'revenue_from': revenueFrom,
        'revenue_to': revenueTo,
        'revenue_granularity': revenueGranularity,
      };
}

/// Analytics endpoints from `useDashboardAnalytics.ts`.
class AnalyticsApi extends BaseApi {
  AnalyticsApi(super.client);

  Future<ApiResponse<Map<String, dynamic>>> getDashboard(
    DashboardAnalyticsParams params,
  ) {
    return get(
      ApiConstants.adminAnalyticsDashboard,
      queryParameters: params.toQuery(),
      mapData: mapJsonObject,
    );
  }
}
