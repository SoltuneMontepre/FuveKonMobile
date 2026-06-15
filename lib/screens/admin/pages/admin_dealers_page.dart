import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_dealer_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_approval_page.dart';

class AdminDealersPage extends StatelessWidget {
  const AdminDealersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = sl<AdminDealerService>();

    return AdminApprovalPage(
      title: 'Quản lý Dealer',
      tabs: const [
        AdminApprovalTabConfig(label: 'Chờ duyệt', index: 0),
        AdminApprovalTabConfig(label: 'Đã duyệt', index: 1),
      ],
      loadItems: (index) => service.getDealers(
        index == 0 ? AdminDealerTab.pending : AdminDealerTab.verified,
      ),
      showApprove: true,
      showDeny: true,
      showMarkPending: false,
      onApprove: (item) async => service.verifyDealer(item.id),
      onDeny: (item) async => service.denyDealer(item.id),
      approveLabel: 'Duyệt gian hàng',
      denyLabel: 'Từ chối đăng ký',
    );
  }
}
