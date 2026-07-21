import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_talent_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_performance_application_detail_page.dart';

/// Full-screen review page for a single talent application, replacing the
/// bottom sheet previously used on [AdminTalentsPage].
class AdminTalentDetailPage extends StatelessWidget {
  const AdminTalentDetailPage({
    super.key,
    required this.talent,
    required this.service,
  });

  final AdminTalentItem talent;
  final AdminTalentService service;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AdminPerformanceApplicationDetailPage(
      appBarTitle: l10n.adminTalentsTitle,
      title: talent.title,
      nickname: talent.nickname,
      representativeUrl: talent.representativeUrl,
      performanceGenre: talent.performanceGenre,
      durationMinutes: talent.durationMinutes,
      participantCount: talent.participantCount,
      slotLabel: talent.slotLabel,
      introduction: talent.introduction,
      status: talent.status,
      createdAt: talent.createdAt,
      approveLabel: l10n.adminTalentsApprove,
      denyLabel: l10n.adminTalentsDeny,
      onApprove: () => service.approve(talent.id),
      onRequireChanges: () => service.requireChanges(talent.id),
      onDeny: () => service.deny(talent.id),
      onMarkPending: () => service.markPending(talent.id),
    );
  }
}
