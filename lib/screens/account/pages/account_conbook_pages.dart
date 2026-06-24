import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/screens/account/services/account_submissions_service.dart';
import 'package:fuvekonmobile/screens/contribute/conbook_rules_section.dart';
import 'package:fuvekonmobile/screens/contribute/conbook_submission_helper.dart';
import 'package:fuvekonmobile/screens/contribute/conbook_submit_form_fields.dart';
import 'package:fuvekonmobile/shared/models/submission_summary.dart';
import 'package:fuvekonmobile/shared/utils/submission_status.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
import 'package:go_router/go_router.dart';

/// Account hub for conbook info, rules, and the user's submissions.
class AccountConbookPage extends StatefulWidget {
  const AccountConbookPage({super.key});

  @override
  State<AccountConbookPage> createState() => _AccountConbookPageState();
}

class _AccountConbookPageState extends State<AccountConbookPage> {
  final _service = sl<AccountSubmissionsService>();
  late Future<List<SubmissionSummary>> _future = _service.getConbooks();

  Future<void> _refresh() async {
    setState(() => _future = _service.getConbooks());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ext = context.fuvekonTheme;

    return AppPageScaffold(
      title: l10n.artbookTitle,
      padding: EdgeInsets.zero,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<SubmissionSummary>>(
          future: _future,
          builder: (context, snapshot) {
            final loading =
                snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData;
            final items = snapshot.data ?? const [];

            return ListView(
              padding: const EdgeInsets.all(FuvekonSpacing.page),
              children: [
                FuveMintCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.artbookTitle,
                        style: TextStyle(
                          color: ext.contentOnCard,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.artbookDescription,
                        style: TextStyle(
                          color: ext.contentOnCardMuted,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: FuvekonSpacing.stackGapLg),
                      FuvePillButton(
                        label: l10n.artbookSubmitCta,
                        icon: Icons.upload_outlined,
                        onPressed: () =>
                            context.push(Routes.accountConbookSubmit),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: FuvekonSpacing.stackGapLg),
                FuveMintCard(
                  child: ConbookRulesSection(
                    l10n: l10n,
                    variant: ConbookRulesVariant.card,
                  ),
                ),
                const SizedBox(height: FuvekonSpacing.stackGapLg),
                FuveSectionHeader(title: 'Conbook của tôi'),
                const SizedBox(height: FuvekonSpacing.stackGapMd),
                if (loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (items.isEmpty)
                  EmptyState(
                    title: 'Chưa có tác phẩm',
                    subtitle: l10n.artbookSubmitIntro,
                    icon: Icons.collections_bookmark_outlined,
                  )
                else
                  ...items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: FuvekonSpacing.stackGapMd,
                      ),
                      child: FuveMintCard(
                        onTap: () =>
                            context.push(Routes.accountConbookDetail(item.id)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      color: ext.contentOnCard,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (item.subtitle?.isNotEmpty == true) ...[
                                    const SizedBox(height: 4),
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
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Account-scoped conbook submission form.
class AccountConbookSubmitPage extends StatefulWidget {
  const AccountConbookSubmitPage({super.key});

  @override
  State<AccountConbookSubmitPage> createState() =>
      _AccountConbookSubmitPageState();
}

class _AccountConbookSubmitPageState extends State<AccountConbookSubmitPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _portfolioController = TextEditingController();

  String? _genre;
  String? _previewUrl;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      await ConbookSubmissionHelper.submit(
        context: context,
        title: _titleController.text.trim(),
        handle: _authorController.text.trim(),
        description: ConbookSubmissionHelper.buildDescription(
          genre: _genre,
          idea: _descriptionController.text.trim(),
          portfolio: _portfolioController.text.trim(),
        ),
        imageUrl: _previewUrl,
        successRoute: Routes.accountConbook,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScrollPage(
      title: l10n.artbookSubmitTitle,
      footer: FuvePillButton(
        label: _submitting ? 'Đang gửi...' : l10n.artbookSubmitButton,
        icon: Icons.send_outlined,
        onPressed: _submitting ? null : _submit,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.artbookSubmitIntro,
              style: TextStyle(
                color: context.fuvekonTheme.contentOnCardMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: FuvekonSpacing.stackGapLg),
            ConbookSubmitFormFields(
              titleController: _titleController,
              authorController: _authorController,
              descriptionController: _descriptionController,
              portfolioController: _portfolioController,
              genre: _genre,
              onGenreChanged: (value) => setState(() => _genre = value),
              previewUrl: _previewUrl,
              onPreviewUrlChanged: (url) => setState(() => _previewUrl = url),
              enabled: !_submitting,
            ),
            const SizedBox(height: FuvekonSpacing.stackGapLg),
            ConbookRulesSection(
              l10n: l10n,
              variant: ConbookRulesVariant.card,
            ),
          ],
        ),
      ),
    );
  }
}

/// Edit a conbook submission after staff requested changes.
class AccountConbookEditPage extends StatefulWidget {
  const AccountConbookEditPage({super.key, required this.conbookId});

  final String conbookId;

  @override
  State<AccountConbookEditPage> createState() => _AccountConbookEditPageState();
}

class _AccountConbookEditPageState extends State<AccountConbookEditPage> {
  final _service = sl<AccountSubmissionsService>();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _portfolioController = TextEditingController();

  late final Future<Map<String, dynamic>> _future = _service.getConbookDetail(
    widget.conbookId,
  );
  bool _initialized = false;
  String? _genre;
  String? _previewUrl;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  void _populate(Map<String, dynamic> data) {
    if (_initialized) return;
    _initialized = true;
    _titleController.text = data['title'] as String? ?? '';
    _authorController.text = data['handle'] as String? ?? '';
    _previewUrl = data['image_url'] as String?;

    final parsed = ConbookSubmissionHelper.parseDescription(
      data['description'] as String? ?? '',
    );
    _genre = parsed.genre;
    _descriptionController.text = parsed.idea;
    _portfolioController.text = parsed.portfolio;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      await ConbookSubmissionHelper.update(
        context: context,
        id: widget.conbookId,
        title: _titleController.text.trim(),
        handle: _authorController.text.trim(),
        description: ConbookSubmissionHelper.buildDescription(
          genre: _genre,
          idea: _descriptionController.text.trim(),
          portfolio: _portfolioController.text.trim(),
        ),
        imageUrl: _previewUrl,
        successRoute: Routes.accountConbookDetail(widget.conbookId),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FutureBuilder<Map<String, dynamic>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppScrollPage(
            title: 'Chỉnh sửa conbook',
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return AppScrollPage(
            title: 'Chỉnh sửa conbook',
            child: Center(
              child: Text('Không thể tải tác phẩm: ${snapshot.error}'),
            ),
          );
        }

        final data = snapshot.data!;
        _populate(data);

        return AppScrollPage(
          title: 'Chỉnh sửa conbook',
          footer: FuvePillButton(
            label: _submitting ? 'Đang gửi...' : 'Gửi lại tác phẩm',
            icon: Icons.send_outlined,
            onPressed: _submitting ? null : _submit,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Cập nhật tác phẩm theo yêu cầu của BTC, sau đó gửi lại để được xét duyệt.',
                  style: TextStyle(
                    color: context.fuvekonTheme.contentOnCardMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: FuvekonSpacing.stackGapLg),
                ConbookSubmitFormFields(
                  titleController: _titleController,
                  authorController: _authorController,
                  descriptionController: _descriptionController,
                  portfolioController: _portfolioController,
                  genre: _genre,
                  onGenreChanged: (value) => setState(() => _genre = value),
                  previewUrl: _previewUrl,
                  onPreviewUrlChanged: (url) => setState(() => _previewUrl = url),
                  enabled: !_submitting,
                ),
                const SizedBox(height: FuvekonSpacing.stackGapLg),
                ConbookRulesSection(
                  l10n: l10n,
                  variant: ConbookRulesVariant.card,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
