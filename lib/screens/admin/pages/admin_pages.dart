import 'package:flutter/material.dart';
import 'package:fuvekonmobile/screens/admin/pages/admin_conbook_page.dart';
import 'package:fuvekonmobile/shared/widgets/placeholder_page.dart';export 'admin_conbook_page.dart';
export 'admin_lost_found_detail_page.dart';
export 'admin_lost_found_page.dart';
export 'admin_lost_found_return_page.dart';
export 'admin_dashboard_page.dart';
export 'admin_dealer_detail_page.dart';
export 'admin_dealers_page.dart';
export 'admin_panels_page.dart';
export 'admin_scan_history_page.dart';
export 'admin_scan_ticket_page.dart';
export 'admin_schedules_page.dart';
export 'admin_schedule_detail_page.dart';
export 'admin_user_detail_page.dart';
export 'admin_user_edit_page.dart';
export 'admin_tier_edit_page.dart';
export 'admin_tickets_page.dart';
export 'admin_users_page.dart';
export 'admin_system_page.dart';

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

class AdminArtSubmitPage extends StatelessWidget {
  const AdminArtSubmitPage({super.key});

  @override
  Widget build(BuildContext context) => const AdminConbookPage();
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
