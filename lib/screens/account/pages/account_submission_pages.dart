import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/screens/account/services/account_submissions_service.dart';
import 'package:fuvekonmobile/shared/utils/submission_status.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';

class AccountPanelPage extends StatelessWidget {
  const AccountPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SubmissionListPage(
      title: 'Panel của tôi',
      load: _loadPanels,
      emptyMessage: 'Bạn chưa gửi hồ sơ panel nào.',
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
      load: () => sl<AccountSubmissionsService>().getPanelDetail(panelId),
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
    return const _SubmissionListPage(
      title: 'Talent của tôi',
      load: _loadTalents,
      emptyMessage: 'Bạn chưa gửi hồ sơ talent nào.',
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
      load: () => sl<AccountSubmissionsService>().getTalentDetail(talentId),
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

class AccountConbookPage extends StatelessWidget {
  const AccountConbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SubmissionListPage(
      title: 'Conbook của tôi',
      load: _loadConbooks,
      emptyMessage: 'Bạn chưa gửi ảnh conbook nào.',
    );
  }

  static Future<List<Map<String, dynamic>>> _loadConbooks() async {
    final service = sl<AccountSubmissionsService>();
    final items = await service.getConbooks();
    return items
        .map((e) => {'id': e.id, 'title': e.title, 'status': e.status})
        .toList();
  }
}

class AccountConbookDetailPage extends StatelessWidget {
  const AccountConbookDetailPage({super.key, required this.conbookId});

  final String conbookId;

  @override
  Widget build(BuildContext context) {
    return _SubmissionDetailPage(
      title: 'Chi tiết conbook',
      load: () => sl<AccountSubmissionsService>().getConbookDetail(conbookId),
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
  });

  final String title;
  final _SubmissionListLoader load;
  final String emptyMessage;

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
              return FuveMintCard(
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
  });

  final String title;
  final Future<Map<String, dynamic>> Function() load;
  final Map<String, dynamic> mock;

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
          final ext = context.fuvekonTheme;

          return ListView(
            children: [
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
