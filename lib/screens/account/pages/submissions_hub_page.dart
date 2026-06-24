import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/screens/account/services/account_submissions_service.dart';
import 'package:fuvekonmobile/shared/models/submission_summary.dart';
import 'package:fuvekonmobile/shared/utils/submission_status.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
import 'package:go_router/go_router.dart';

/// Màn 49–52 — submissions hub (panel / talent / conbook).
class SubmissionsHubPage extends StatefulWidget {
  const SubmissionsHubPage({super.key});

  @override
  State<SubmissionsHubPage> createState() => _SubmissionsHubPageState();
}

class _SubmissionsHubPageState extends State<SubmissionsHubPage> {
  final _service = sl<AccountSubmissionsService>();
  late Future<List<SubmissionSummary>> _future = _service.getAll();

  Future<void> _refresh() async {
    setState(() => _future = _service.getAll());
    await _future;
  }

  String _routeFor(SubmissionSummary item) => switch (item.type) {
    SubmissionType.panel => Routes.accountPanelDetail(item.id),
    SubmissionType.talent => Routes.accountTalentDetail(item.id),
    SubmissionType.conbook => Routes.accountConbookDetail(item.id),
  };

  IconData _iconFor(SubmissionType type) => switch (type) {
    SubmissionType.panel => Icons.groups_outlined,
    SubmissionType.talent => Icons.mic_external_on_outlined,
    SubmissionType.conbook => Icons.collections_bookmark_outlined,
  };

  String _typeLabel(SubmissionType type) => switch (type) {
    SubmissionType.panel => 'Panel',
    SubmissionType.talent => 'Talent',
    SubmissionType.conbook => 'Conbook',
  };

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Hồ sơ đã gửi',
      padding: EdgeInsets.zero,
      body: FutureBuilder<List<SubmissionSummary>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? const [];
          if (items.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(FuvekonSpacing.page),
              child: Column(
                children: [
                  const EmptyState(
                    title: 'Chưa có hồ sơ',
                    subtitle:
                        'Gửi panel, talent hoặc conbook để theo dõi tại đây.',
                    icon: Icons.folder_open_outlined,
                  ),
                  const SizedBox(height: FuvekonSpacing.stackGapLg),
                  FuvePillButton(
                    label: 'Đăng ký panel',
                    variant: FuvePillButtonVariant.outline,
                    expanded: false,
                    onPressed: () => context.push(Routes.panel),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(FuvekonSpacing.page),
              children: [
                const FuveSectionHeader(title: 'Tất cả hồ sơ'),
                const SizedBox(height: FuvekonSpacing.stackGapMd),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: FuvekonSpacing.stackGapMd,
                    ),
                    child: _SubmissionCard(
                      item: item,
                      icon: _iconFor(item.type),
                      typeLabel: _typeLabel(item.type),
                      onTap: () => context.push(_routeFor(item)),
                    ),
                  ),
                ),
                const SizedBox(height: FuvekonSpacing.stackGapSm),
                FuvePillButton(
                  label: 'Gửi hồ sơ mới',
                  icon: Icons.add,
                  variant: FuvePillButtonVariant.outline,
                  onPressed: () => _showNewSubmissionSheet(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showNewSubmissionSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Chọn loại hồ sơ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.groups_outlined),
                title: const Text('Panel'),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.panel);
                },
              ),
              ListTile(
                leading: const Icon(Icons.mic_external_on_outlined),
                title: const Text('Talent'),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.talent);
                },
              ),
              ListTile(
                leading: const Icon(Icons.collections_bookmark_outlined),
                title: const Text('Conbook'),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.accountConbookSubmit);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmissionCard extends StatelessWidget {
  const _SubmissionCard({
    required this.item,
    required this.icon,
    required this.typeLabel,
    required this.onTap,
  });

  final SubmissionSummary item;
  final IconData icon;
  final String typeLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;

    return FuveMintCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: FuvekonColors.premiumPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: ext.contentOnCard),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeLabel,
                  style: TextStyle(
                    color: ext.contentOnCardMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  style: TextStyle(
                    color: ext.contentOnCard,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                if (item.subtitle?.isNotEmpty == true) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle!,
                    style: TextStyle(
                      color: ext.contentOnCardMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          FuveStatusBadge(
            label: statusLabelVi(item.status),
            variant: statusBadgeVariant(item.status),
          ),
        ],
      ),
    );
  }
}
