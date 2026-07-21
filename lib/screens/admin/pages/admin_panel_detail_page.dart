import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_panel_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_performance_application_detail_page.dart';

/// Full-screen review page for a single panel application, replacing the
/// bottom sheet previously used on [AdminPanelsPage].
class AdminPanelDetailPage extends StatelessWidget {
  const AdminPanelDetailPage({
    super.key,
    required this.panel,
    required this.service,
  });

  final AdminPanelItem panel;
  final AdminPanelService service;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AdminPerformanceApplicationDetailPage(
      appBarTitle: l10n.adminPanelsTitle,
      title: panel.title,
      nickname: panel.nickname,
      representativeUrl: panel.representativeUrl,
      performanceGenre: panel.performanceGenre,
      durationMinutes: panel.durationMinutes,
      participantCount: panel.participantCount,
      slotLabel: panel.slotLabel,
      introduction: panel.introduction,
      status: panel.status,
      createdAt: panel.createdAt,
      approveLabel: l10n.adminPanelsApprove,
      denyLabel: l10n.adminPanelsDeny,
      onApprove: () => service.approve(panel.id),
      onRequireChanges: () => service.requireChanges(panel.id),
      onDeny: () => service.deny(panel.id),
      onMarkPending: () => service.markPending(panel.id),
    );
  }
}
