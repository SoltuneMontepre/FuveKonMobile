import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/pages/admin_talent_detail_page.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_panel_service.dart'
    show AdminApprovalTab;
import 'package:fuvekonmobile/screens/admin/services/admin_talent_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_approval_page.dart';

class AdminTalentsPage extends StatelessWidget {
  const AdminTalentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final service = sl<AdminTalentService>();

    return AdminApprovalPage(
      title: l10n.adminTalentsTitle,
      tabs: [
        AdminApprovalTabConfig(label: l10n.adminStatusPending, index: 0),
        AdminApprovalTabConfig(label: l10n.adminStatusApproved, index: 1),
        AdminApprovalTabConfig(label: l10n.adminStatusRequireChanges, index: 2),
        AdminApprovalTabConfig(label: l10n.adminStatusDenied, index: 3),
      ],
      loadItems: (index) => service.getTalents(AdminApprovalTab.values[index]),
      onItemTap: (item) => Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => AdminTalentDetailPage(
            talent: item as AdminTalentItem,
            service: service,
          ),
        ),
      ),
    );
  }
}
