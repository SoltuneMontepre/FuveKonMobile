import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_conbook_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_panel_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_approval_page.dart';

class AdminConbookPage extends StatelessWidget {
  const AdminConbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final service = sl<AdminConbookService>();

    return AdminApprovalPage(
      title: l10n.adminConbookTitle,
      tabs: [
        AdminApprovalTabConfig(label: l10n.adminStatusPending, index: 0),
        AdminApprovalTabConfig(label: l10n.adminStatusApproved, index: 1),
        AdminApprovalTabConfig(label: l10n.adminStatusRequireChanges, index: 2),
        AdminApprovalTabConfig(label: l10n.adminStatusDenied, index: 3),
      ],
      loadItems: (index) => service.getConbooks(AdminApprovalTab.values[index]),
      onApprove: (item) async => service.approve(item.id),
      onRequireChanges: (item) async => service.requireChanges(item.id),
      onDeny: (item) async => service.deny(item.id),
      onMarkPending: (item) async => service.markPending(item.id),
      showRequireChanges: true,
      showMarkPending: true,
      approveLabel: l10n.adminConbookApprove,
      denyLabel: l10n.adminConbookDeny,
      markPendingLabel: l10n.adminMarkPendingReturn,
    );
  }
}
