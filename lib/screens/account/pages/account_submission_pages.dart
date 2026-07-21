import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/screens/account/services/account_submissions_service.dart';
import 'package:fuvekonmobile/screens/contribute/performance_form_fields.dart';
import 'package:fuvekonmobile/shared/utils/submission_status.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
import 'package:go_router/go_router.dart';

class AccountPanelPage extends StatelessWidget {
  const AccountPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubmissionListPage(
      title: 'Panel của tôi',
      load: _loadPanels,
      emptyMessage: 'Bạn chưa gửi hồ sơ panel nào.',
      detailRoute: Routes.accountPanelDetail,
    );
  }

  static Future<List<Map<String, dynamic>>> _loadPanels() async {
    final service = sl<AccountSubmissionsService>();
    final items = await service.getPanels();
    return items
        .map((e) => {'id': e.id, 'title': e.title, 'status': e.status})
        .toList();
  }
}

class AccountPanelDetailPage extends StatelessWidget {
  const AccountPanelDetailPage({super.key, required this.panelId});

  final String panelId;

  @override
  Widget build(BuildContext context) {
    return _SubmissionDetailPage(
      title: 'Chi tiết panel',
      submissionId: panelId,
      load: () => sl<AccountSubmissionsService>().getPanelDetail(panelId),
      editRoute: Routes.accountPanelEdit,
      mock: {
        'title': 'Fursuit Dance Panel',
        'nickname': 'DancerFur',
        'performance_genre': 'Dance',
        'duration_minutes': 30,
        'participant_count': 3,
        'status': 'pending',
        'introduction': 'A fun interactive dance panel for all skill levels.',
      },
    );
  }
}

class AccountTalentPage extends StatelessWidget {
  const AccountTalentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubmissionListPage(
      title: 'Talent của tôi',
      load: _loadTalents,
      emptyMessage: 'Bạn chưa gửi hồ sơ talent nào.',
      detailRoute: Routes.accountTalentDetail,
    );
  }

  static Future<List<Map<String, dynamic>>> _loadTalents() async {
    final service = sl<AccountSubmissionsService>();
    final items = await service.getTalents();
    return items
        .map((e) => {'id': e.id, 'title': e.title, 'status': e.status})
        .toList();
  }
}

class AccountTalentDetailPage extends StatelessWidget {
  const AccountTalentDetailPage({super.key, required this.talentId});

  final String talentId;

  @override
  Widget build(BuildContext context) {
    return _SubmissionDetailPage(
      title: 'Chi tiết talent',
      submissionId: talentId,
      load: () => sl<AccountSubmissionsService>().getTalentDetail(talentId),
      editRoute: Routes.accountTalentEdit,
      mock: {
        'title': 'Live Music Performance',
        'nickname': 'MusicFur',
        'performance_genre': 'Music',
        'duration_minutes': 15,
        'participant_count': 2,
        'status': 'approved',
        'introduction': 'Acoustic set with furry-themed originals.',
      },
    );
  }
}

class AccountConbookDetailPage extends StatelessWidget {
  const AccountConbookDetailPage({super.key, required this.conbookId});

  final String conbookId;

  @override
  Widget build(BuildContext context) {
    return _SubmissionDetailPage(
      title: 'Chi tiết conbook',
      submissionId: conbookId,
      load: () => sl<AccountSubmissionsService>().getConbookDetail(conbookId),
      editRoute: Routes.accountConbookEdit,
      mock: {
        'title': 'My Fursona Portrait',
        'handle': 'artist_fur',
        'description': 'Full-color portrait for the conbook.',
        'status': 'pending',
      },
    );
  }
}

typedef _SubmissionListLoader = Future<List<Map<String, dynamic>>> Function();

class _SubmissionListPage extends StatefulWidget {
  const _SubmissionListPage({
    required this.title,
    required this.load,
    required this.emptyMessage,
    this.detailRoute,
  });

  final String title;
  final _SubmissionListLoader load;
  final String emptyMessage;
  final String Function(String id)? detailRoute;

  @override
  State<_SubmissionListPage> createState() => _SubmissionListPageState();
}

class _SubmissionListPageState extends State<_SubmissionListPage> {
  late final Future<List<Map<String, dynamic>>> _future = widget.load();

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: widget.title,
      padding: EdgeInsets.zero,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? const [];
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(FuvekonSpacing.page),
                child: Text(widget.emptyMessage, textAlign: TextAlign.center),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(FuvekonSpacing.page),
            itemCount: items.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: FuvekonSpacing.stackGapMd),
            itemBuilder: (context, index) {
              final item = items[index];
              final status = item['status'] as String? ?? 'pending';
              final id = item['id']?.toString();
              final onTap = widget.detailRoute != null && id != null
                  ? () => context.push(widget.detailRoute!(id))
                  : null;
              return FuveMintCard(
                onTap: onTap,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] as String? ?? '—',
                        style: TextStyle(
                          color: context.fuvekonTheme.contentOnCard,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    FuveStatusBadge(
                      label: statusLabelVi(status),
                      variant: statusBadgeVariant(status),
                    ),
                    if (onTap != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: context.fuvekonTheme.contentOnCardMuted,
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SubmissionDetailPage extends StatelessWidget {
  const _SubmissionDetailPage({
    required this.title,
    required this.load,
    required this.mock,
    this.submissionId,
    this.editRoute,
  });

  final String title;
  final Future<Map<String, dynamic>> Function() load;
  final Map<String, dynamic> mock;
  final String? submissionId;
  final String Function(String id)? editRoute;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: title,
      body: FutureBuilder<Map<String, dynamic>>(
        future: load().catchError((_) => mock),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data ?? mock;
          final status = data['status'] as String? ?? 'pending';
          final id = submissionId ?? data['id']?.toString();
          final canFix = submissionNeedsFix(status) &&
              id != null &&
              editRoute != null;
          final ext = context.fuvekonTheme;

          return ListView(
            children: [
              if (canFix) ...[
                FuveMintCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BTC yêu cầu bạn chỉnh sửa hồ sơ này trước khi xét duyệt lại.',
                        style: TextStyle(
                          color: ext.contentOnCard,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: FuvekonSpacing.stackGapMd),
                      FuvePillButton(
                        label: 'Chỉnh sửa hồ sơ',
                        icon: Icons.edit_outlined,
                        onPressed: () => context.push(editRoute!(id)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: FuvekonSpacing.stackGapMd),
              ],
              FuveMintCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data['title'] as String? ?? '—',
                            style: TextStyle(
                              color: ext.contentOnCard,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        FuveStatusBadge(
                          label: statusLabelVi(status),
                          variant: statusBadgeVariant(status),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._detailFields(data).map(
                      (field) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              field.$1,
                              style: TextStyle(
                                color: ext.contentOnCardMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              field.$2,
                              style: TextStyle(color: ext.contentOnCard),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<(String, String)> _detailFields(Map<String, dynamic> data) {
    final fields = <(String, String)>[];
    void add(String label, dynamic value) {
      if (value == null) return;
      final text = value.toString();
      if (text.isEmpty) return;
      fields.add((label, text));
    }

    add('Nickname', data['nickname']);
    add('Thể loại', data['performance_genre']);
    add('Số người', data['participant_count']);
    add('Thời lượng (phút)', data['duration_minutes']);
    add('Handle', data['handle'] != null ? '@${data['handle']}' : null);
    add('Mô tả', data['description'] ?? data['introduction']);
    add('Khung giờ', data['slot_label']);
    return fields;
  }
}

class AccountTalentEditPage extends StatelessWidget {
  const AccountTalentEditPage({super.key, required this.talentId});

  final String talentId;

  @override
  Widget build(BuildContext context) {
    final service = sl<AccountSubmissionsService>();
    return _PerformanceEditPage(
      title: 'Chỉnh sửa talent',
      defaultDurationMinutes: 15,
      load: () => service.getTalentDetail(talentId),
      onSubmit: (payload) => service.updateTalent(talentId, payload),
      successMessage: 'Đã cập nhật và gửi lại hồ sơ talent',
      detailRoute: Routes.accountTalentDetail(talentId),
    );
  }
}

class AccountPanelEditPage extends StatelessWidget {
  const AccountPanelEditPage({super.key, required this.panelId});

  final String panelId;

  @override
  Widget build(BuildContext context) {
    final service = sl<AccountSubmissionsService>();
    return _PerformanceEditPage(
      title: 'Chỉnh sửa panel',
      defaultDurationMinutes: 30,
      load: () => service.getPanelDetail(panelId),
      onSubmit: (payload) => service.updatePanel(panelId, payload),
      successMessage: 'Đã cập nhật và gửi lại hồ sơ panel',
      detailRoute: Routes.accountPanelDetail(panelId),
    );
  }
}

/// Shared edit form for a panel or talent submission that the organizers sent
/// back with `require_changes`, letting the submitter fix and resend it.
class _PerformanceEditPage extends StatefulWidget {
  const _PerformanceEditPage({
    required this.title,
    required this.load,
    required this.onSubmit,
    required this.successMessage,
    required this.detailRoute,
    required this.defaultDurationMinutes,
  });

  final String title;
  final Future<Map<String, dynamic>> Function() load;
  final Future<void> Function(Map<String, dynamic> payload) onSubmit;
  final String successMessage;
  final String detailRoute;
  final int defaultDurationMinutes;

  @override
  State<_PerformanceEditPage> createState() => _PerformanceEditPageState();
}

class _PerformanceEditPageState extends State<_PerformanceEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _genreController = TextEditingController();
  final _introController = TextEditingController();
  final _driveController = TextEditingController();
  final _repUrlController = TextEditingController();
  final _memberNameController = TextEditingController();

  late final Future<Map<String, dynamic>> _future = widget.load();
  bool _initialized = false;
  bool _submitting = false;
  late int _durationMinutes = widget.defaultDurationMinutes;

  @override
  void dispose() {
    _titleController.dispose();
    _nicknameController.dispose();
    _genreController.dispose();
    _introController.dispose();
    _driveController.dispose();
    _repUrlController.dispose();
    _memberNameController.dispose();
    super.dispose();
  }

  void _populate(Map<String, dynamic> data) {
    if (_initialized) return;
    _initialized = true;
    _titleController.text = data['title'] as String? ?? '';
    _nicknameController.text = data['nickname'] as String? ?? '';
    _genreController.text = data['performance_genre'] as String? ?? '';
    _introController.text = data['introduction'] as String? ?? '';
    _driveController.text = data['materials_drive_url'] as String? ?? '';
    _repUrlController.text = data['representative_url'] as String? ?? '';
    _durationMinutes =
        data['duration_minutes'] as int? ?? widget.defaultDurationMinutes;

    final members = data['members'];
    if (members is List && members.isNotEmpty) {
      final first = members.first;
      if (first is Map) {
        _memberNameController.text = first['name'] as String? ?? '';
      }
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      await widget.onSubmit({
        'title': _titleController.text.trim(),
        'nickname': _nicknameController.text.trim(),
        'representative_url': _repUrlController.text.trim(),
        'participant_count': 1,
        'performance_genre': _genreController.text.trim(),
        'introduction': _introController.text.trim(),
        'duration_minutes': _durationMinutes,
        'materials_drive_url': _driveController.text.trim(),
        'equipment_notes': '',
        'members': [
          {'name': _memberNameController.text.trim(), 'detail': ''},
        ],
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(widget.successMessage)));
      context.go(widget.detailRoute);
    } catch (e) {
      if (!mounted) return;
      final message = e is ServerException ? e.message : 'Không thể cập nhật';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppPageScaffold(
            title: widget.title,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return AppPageScaffold(
            title: widget.title,
            body: Center(child: Text('Không thể tải hồ sơ: ${snapshot.error}')),
          );
        }

        final data = snapshot.data!;
        _populate(data);

        return AppScrollPage(
          title: widget.title,
          footer: FuvePillButton(
            label: _submitting ? 'Đang gửi...' : 'Gửi lại hồ sơ',
            icon: Icons.send_outlined,
            onPressed: _submitting ? null : _submit,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Cập nhật thông tin theo yêu cầu của BTC, sau đó gửi lại để được xét duyệt.',
                  style: TextStyle(
                    color: context.fuvekonTheme.contentOnCardMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: FuvekonSpacing.stackGapLg),
                PerformanceFormFields(
                  titleController: _titleController,
                  nicknameController: _nicknameController,
                  genreController: _genreController,
                  introController: _introController,
                  driveController: _driveController,
                  repUrlController: _repUrlController,
                  memberNameController: _memberNameController,
                  enabled: !_submitting,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
