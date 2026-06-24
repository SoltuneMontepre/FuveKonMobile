import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/screens/admin/pages/admin_conbook_page.dart';
import 'package:fuvekonmobile/shared/widgets/placeholder_page.dart';

export 'admin_conbook_page.dart';
export 'admin_dashboard_users_page.dart';
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
export 'admin_notification_broadcast_page.dart';
export 'admin_notification_create_page.dart';
export 'admin_notifications_hub_page.dart';
export 'admin_user_detail_page.dart';
export 'admin_user_edit_page.dart';
export 'admin_tier_edit_page.dart';
export 'admin_ticket_detail_page.dart';
export 'admin_tickets_page.dart';
export 'admin_users_page.dart';
export 'admin_system_page.dart';

class AdminArtSubmitPage extends StatelessWidget {
  const AdminArtSubmitPage({super.key});

  @override
  Widget build(BuildContext context) => const AdminConbookPage();
}

class AdminTalentsPage extends StatelessWidget {
  const AdminTalentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PlaceholderPage(
      title: l10n.adminPlaceholderTalent,
      subtitle: l10n.adminPlaceholderTalentSubtitle,
      icon: Icons.mic_external_on_outlined,
    );
  }
}
