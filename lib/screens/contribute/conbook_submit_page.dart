import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/contribute/conbook_rules_section.dart';
import 'package:fuvekonmobile/screens/contribute/conbook_submission_helper.dart';
import 'package:fuvekonmobile/screens/contribute/conbook_submit_form_fields.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_illustrated_background.dart';
import 'package:go_router/go_router.dart';

class ConbookSubmitPage extends StatefulWidget {
  const ConbookSubmitPage({super.key});

  @override
  State<ConbookSubmitPage> createState() => _ConbookSubmitPageState();
}

class _ConbookSubmitPageState extends State<ConbookSubmitPage> {
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
    if (!_formKey.currentState!.validate()) return;

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
        successRoute: Routes.artbook,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ext = context.fuvekonTheme;

    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: FuvekonIllustratedPageStack(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SubmitHero(l10n: l10n),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppIllustratedInteractiveSection(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.public,
                                    size: 20,
                                    color: ext.contentOnCardMuted,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.artbookFormSectionTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: ext.contentOnCard,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ConbookSubmitFormFields(
                                titleController: _titleController,
                                authorController: _authorController,
                                descriptionController: _descriptionController,
                                portfolioController: _portfolioController,
                                genre: _genre,
                                onGenreChanged: (value) =>
                                    setState(() => _genre = value),
                                previewUrl: _previewUrl,
                                onPreviewUrlChanged: (url) =>
                                    setState(() => _previewUrl = url),
                                enabled: !_submitting,
                                illustratedStyle: true,
                              ),
                              const SizedBox(height: 24),
                              FilledButton.icon(
                                onPressed: _submitting ? null : _submit,
                                icon: _submitting
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.send_rounded, size: 18),
                                label: Text(l10n.artbookSubmitButton),
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      FuvekonColors.sageGreenContainer,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ConbookRulesSection(
                        l10n: l10n,
                        variant: ConbookRulesVariant.dark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitHero extends StatelessWidget {
  const _SubmitHero({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.55),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(Routes.artbook);
                      }
                    },
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: Text(
                      l10n.artbookSubmitBack,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    l10n.artbookSubmitTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.artbookSubmitIntro,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
