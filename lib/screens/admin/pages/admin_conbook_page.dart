import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_conbook_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_panel_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_approval_page.dart';

class AdminConbookPage extends StatelessWidget {
  const AdminConbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = sl<AdminConbookService>();

    return AdminApprovalPage(
      title: 'Duyệt Conbook',
      tabs: const [
        AdminApprovalTabConfig(label: 'Chờ duyệt', index: 0),
        AdminApprovalTabConfig(label: 'Đã duyệt', index: 1),
        AdminApprovalTabConfig(label: 'Từ chối', index: 2),
      ],
      loadItems: (index) => service.getConbooks(AdminApprovalTab.values[index]),
      onApprove: (item) async => service.approve(item.id),
      onDeny: (item) async => service.deny(item.id),
      onMarkPending: (item) async => service.markPending(item.id),
      showMarkPending: true,
      approveLabel: 'Duyệt conbook',
      denyLabel: 'Từ chối conbook',
      markPendingLabel: 'Đưa về chờ duyệt',
    );
  }
}
