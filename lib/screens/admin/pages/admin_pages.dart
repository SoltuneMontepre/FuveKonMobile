import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/widgets/staff_tab_scaffold.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/placeholder_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Analytics Dashboard',
      subtitle: 'Event metrics and overview charts.',
      icon: Icons.analytics_outlined,
    );
  }
}

class AdminDashboardUsersPage extends StatelessWidget {
  const AdminDashboardUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Dashboard Users',
      subtitle: 'User analytics and breakdowns.',
      icon: Icons.people_outline,
    );
  }
}

class AdminTicketsPage extends StatelessWidget {
  const AdminTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Ticket Management',
      subtitle: 'Manage ticket tiers, sales, and inventory.',
      icon: Icons.confirmation_number_outlined,
    );
  }
}

class AdminScanTicketPage extends StatelessWidget {
  const AdminScanTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StaffTabScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner_outlined,
                size: 72,
                color: FuvekonColors.darkPrimary,
              ),
              const SizedBox(height: 16),
              Text(
                'Quét vé',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: FuvekonColors.darkText,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Đưa mã QR vé vào khung hình để check-in.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminScanHistoryPage extends StatelessWidget {
  const AdminScanHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StaffTabScaffold(
      child: const EmptyState(
        title: 'Lịch sử quét vé',
        subtitle: 'Chưa có lượt quét nào được ghi nhận.',
        icon: Icons.history_rounded,
      ),
    );
  }
}

class AdminLostFoundPage extends StatelessWidget {
  const AdminLostFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StaffTabScaffold(
      child: const EmptyState(
        title: 'Thất lạc',
        subtitle: 'Danh sách vật thất lạc sẽ hiển thị tại đây.',
        icon: Icons.inventory_2_outlined,
      ),
    );
  }
}

class AdminArtSubmitPage extends StatelessWidget {
  const AdminArtSubmitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Conbook Approval',
      subtitle: 'Review and approve artbook submissions.',
      icon: Icons.approval_outlined,
    );
  }
}

class AdminPanelsPage extends StatelessWidget {
  const AdminPanelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Panel Management',
      subtitle: 'Review and manage panel applications.',
      icon: Icons.groups_outlined,
    );
  }
}

class AdminTalentsPage extends StatelessWidget {
  const AdminTalentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Talent Management',
      subtitle: 'Review and manage talent applications.',
      icon: Icons.mic_external_on_outlined,
    );
  }
}

class AdminDealersPage extends StatelessWidget {
  const AdminDealersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Dealer Management',
      subtitle: 'Review and manage dealer booths.',
      icon: Icons.storefront_outlined,
    );
  }
}

class AdminUserDetailPage extends StatelessWidget {
  const AdminUserDetailPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'User Detail',
      subtitle: 'Profile and actions for user $userId.',
      icon: Icons.person_outline,
    );
  }
}
