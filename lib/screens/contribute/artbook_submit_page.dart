import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/core/api/conbook_api.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_illustrated_background.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image_upload_field.dart';
import 'package:go_router/go_router.dart';

class ArtbookSubmitPage extends StatefulWidget {
  const ArtbookSubmitPage({super.key});

  @override
  State<ArtbookSubmitPage> createState() => _ArtbookSubmitPageState();
}

class _ArtbookSubmitPageState extends State<ArtbookSubmitPage> {
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

  List<String> _genres(AppLocalizations l10n) => [
    l10n.artbookGenreIllustration,
    l10n.artbookGenreComic,
    l10n.artbookGenrePhoto,
    l10n.artbookGenreDigital,
    l10n.artbookGenreOther,
  ];

  String _buildDescription() {
    final parts = <String>[];
    if (_genre != null && _genre!.isNotEmpty) {
      parts.add('Thể loại: $_genre');
    }
    final idea = _descriptionController.text.trim();
    if (idea.isNotEmpty) parts.add(idea);
    final portfolio = _portfolioController.text.trim();
    if (portfolio.isNotEmpty) parts.add('Portfolio: $portfolio');
    final text = parts.join('\n\n');
    return text.length > 500 ? text.substring(0, 500) : text;
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!sl<AuthSessionNotifier>().isAuthenticated) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.artbookLoginRequired)));
      context.go(Routes.login);
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    if (_previewUrl == null || _previewUrl!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.artbookPreviewRequired)));
      return;
    }

    setState(() => _submitting = true);
    try {
      await sl<ConbookApi>().upload({
        'title': _titleController.text.trim(),
        'handle': _authorController.text.trim(),
        'description': _buildDescription(),
        'image_url': _previewUrl,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.artbookSubmitSuccess)));
      context.go(Routes.artbook);
    } catch (e) {
      if (!mounted) return;
      final message = e is ServerException
          ? e.message
          : l10n.artbookSubmitFailed;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
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
                              _ArtbookField(
                                label: l10n.artbookFieldTitle,
                                required: true,
                                child: _ArtbookTextField(
                                  controller: _titleController,
                                  hint: l10n.artbookFieldTitleHint,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return l10n.artbookFieldRequired;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _ArtbookField(
                                label: l10n.artbookFieldAuthor,
                                required: true,
                                child: _ArtbookTextField(
                                  controller: _authorController,
                                  hint: l10n.artbookFieldAuthorHint,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return l10n.artbookFieldRequired;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _ArtbookField(
                                label: l10n.artbookFieldGenre,
                                required: true,
                                child: DropdownButtonFormField<String>(
                                  key: ValueKey(_genre),
                                  initialValue: _genre,
                                  decoration: _inputDecoration(
                                    hint: l10n.artbookFieldGenreHint,
                                  ),
                                  items: _genres(l10n)
                                      .map(
                                        (genre) => DropdownMenuItem(
                                          value: genre,
                                          child: Text(genre),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) =>
                                      setState(() => _genre = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return l10n.artbookFieldRequired;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _ArtbookField(
                                label: l10n.artbookFieldDescription,
                                child: _ArtbookTextField(
                                  controller: _descriptionController,
                                  hint: l10n.artbookFieldDescriptionHint,
                                  maxLines: 4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _ArtbookField(
                                label: l10n.artbookFieldPortfolio,
                                child: _ArtbookTextField(
                                  controller: _portfolioController,
                                  hint: l10n.artbookFieldPortfolioHint,
                                  keyboardType: TextInputType.url,
                                  prefixIcon: Icons.link,
                                ),
                              ),
                              const SizedBox(height: 16),
                              AppFormLabel(
                                text: l10n.artbookFieldPreview,
                                required: true,
                              ),
                              S3ImageUploadField(
                                imageUrl: _previewUrl,
                                folder: 'conbooks',
                                label: l10n.artbookUploadLabel,
                                onChanged: (url) =>
                                    setState(() => _previewUrl = url),
                              ),
                              Text(
                                l10n.artbookUploadHint,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: ext.contentOnCardMuted),
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
                      _RulesCard(l10n: l10n),
                      const SizedBox(height: 16),
                      _DeadlineCard(l10n: l10n),
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

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FuvekonRadii.input),
        borderSide: const BorderSide(color: FuvekonColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FuvekonRadii.input),
        borderSide: BorderSide(
          color: FuvekonColors.inputBorder.withValues(alpha: 0.7),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FuvekonRadii.input),
        borderSide: const BorderSide(
          color: FuvekonColors.sageGreen,
          width: 1.5,
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

class _ArtbookField extends StatelessWidget {
  const _ArtbookField({
    required this.label,
    required this.child,
    this.required = false,
  });

  final String label;
  final Widget child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppFormLabel(text: label, required: required),
        child,
      ],
    );
  }
}

class _ArtbookTextField extends StatelessWidget {
  const _ArtbookTextField({
    required this.controller,
    required this.hint,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: FuvekonColors.onSageGreen),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, size: 20, color: FuvekonColors.textSecondary),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FuvekonRadii.input),
          borderSide: const BorderSide(color: FuvekonColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FuvekonRadii.input),
          borderSide: BorderSide(
            color: FuvekonColors.inputBorder.withValues(alpha: 0.7),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FuvekonRadii.input),
          borderSide: const BorderSide(
            color: FuvekonColors.sageGreen,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _RulesCard extends StatelessWidget {
  const _RulesCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(FuvekonRadii.notes),
        border: Border.all(
          color: FuvekonColors.darkBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.gavel_outlined,
                  color: FuvekonColors.darkPrimary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.artbookRulesTitle,
                  style: const TextStyle(
                    color: FuvekonColors.darkPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _RuleRow(
              title: l10n.artbookRuleSizeTitle,
              body: l10n.artbookRuleSizeBody,
            ),
            const SizedBox(height: 12),
            _RuleRow(
              title: l10n.artbookRuleFormatTitle,
              body: l10n.artbookRuleFormatBody,
            ),
            const SizedBox(height: 12),
            _RuleRow(
              title: l10n.artbookRuleCopyrightTitle,
              body: l10n.artbookRuleCopyrightBody,
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: FuvekonColors.darkText,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          body,
          style: TextStyle(
            color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.95),
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _DeadlineCard extends StatelessWidget {
  const _DeadlineCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurface,
        borderRadius: BorderRadius.circular(FuvekonRadii.notes),
        border: Border.all(
          color: FuvekonColors.darkBorder.withValues(alpha: 0.45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              Icons.hourglass_bottom_outlined,
              color: FuvekonColors.lightGold.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.artbookDeadline,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
