import 'package:flutter/material.dart';
import 'package:fuvekonmobile/screens/admin/pages/admin_conbook_page.dart';
import 'package:fuvekonmobile/screens/admin/widgets/staff_tab_scaffold.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/placeholder_page.dart';
export 'admin_conbook_page.dart';
export 'admin_dashboard_page.dart';
export 'admin_dealers_page.dart';
export 'admin_panels_page.dart';
export 'admin_scan_history_page.dart';
export 'admin_scan_ticket_page.dart';
export 'admin_user_detail_page.dart';
export 'admin_user_edit_page.dart';
export 'admin_users_page.dart';

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
