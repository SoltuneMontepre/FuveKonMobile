import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/widgets/staff_dashboard_colors.dart';

class StaffTrafficWarningCard extends StatelessWidget {
  const StaffTrafficWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: StaffDashboardColors.trafficCardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: StaffDashboardColors.trafficAccent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CẢNH BÁO LƯU LƯỢNG',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: StaffDashboardColors.trafficAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Khu vực Dealer A đang quá tải (90%). Yêu cầu phân luồng khách tham quan.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
