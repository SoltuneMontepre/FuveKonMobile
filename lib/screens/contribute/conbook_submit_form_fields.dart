import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image_upload_field.dart';

class ConbookSubmitFormFields extends StatelessWidget {
  const ConbookSubmitFormFields({
    super.key,
    required this.titleController,
    required this.authorController,
    required this.descriptionController,
    required this.portfolioController,
    required this.genre,
    required this.onGenreChanged,
    required this.previewUrl,
    required this.onPreviewUrlChanged,
    this.enabled = true,
    this.illustratedStyle = false,
  });

  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController descriptionController;
  final TextEditingController portfolioController;
  final String? genre;
  final ValueChanged<String?> onGenreChanged;
  final String? previewUrl;
  final ValueChanged<String?> onPreviewUrlChanged;
  final bool enabled;
  final bool illustratedStyle;

  List<String> _genres(AppLocalizations l10n) => [
    l10n.artbookGenreIllustration,
    l10n.artbookGenreComic,
    l10n.artbookGenrePhoto,
    l10n.artbookGenreDigital,
    l10n.artbookGenreOther,
  ];

  InputDecoration _decoration(String hint) {
    if (!illustratedStyle) {
      return InputDecoration(hintText: hint);
    }
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textStyle = illustratedStyle
        ? const TextStyle(color: FuvekonColors.onSageGreen)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppLabeledField(
          label: l10n.artbookFieldTitle,
          required: true,
          field: TextFormField(
            controller: titleController,
            enabled: enabled,
            style: textStyle,
            decoration: _decoration(l10n.artbookFieldTitleHint),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.artbookFieldRequired;
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: l10n.artbookFieldAuthor,
          required: true,
          field: TextFormField(
            controller: authorController,
            enabled: enabled,
            style: textStyle,
            decoration: _decoration(l10n.artbookFieldAuthorHint),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.artbookFieldRequired;
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: l10n.artbookFieldGenre,
          required: true,
          field: DropdownButtonFormField<String>(
            key: ValueKey(genre),
            initialValue: genre,
            decoration: _decoration(l10n.artbookFieldGenreHint),
            items: _genres(l10n)
                .map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)),
                )
                .toList(),
            onChanged: enabled ? onGenreChanged : null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.artbookFieldRequired;
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: l10n.artbookFieldDescription,
          field: TextFormField(
            controller: descriptionController,
            enabled: enabled,
            maxLines: 4,
            style: textStyle,
            decoration: _decoration(l10n.artbookFieldDescriptionHint),
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: l10n.artbookFieldPortfolio,
          field: TextFormField(
            controller: portfolioController,
            enabled: enabled,
            keyboardType: TextInputType.url,
            style: textStyle,
            decoration: _decoration(l10n.artbookFieldPortfolioHint).copyWith(
              prefixIcon: illustratedStyle
                  ? const Icon(
                      Icons.link,
                      size: 20,
                      color: FuvekonColors.textSecondary,
                    )
                  : const Icon(Icons.link, size: 20),
            ),
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppFormLabel(text: l10n.artbookFieldPreview, required: true),
        S3ImageUploadField(
          imageUrl: previewUrl,
          folder: 'conbooks',
          label: l10n.artbookUploadLabel,
          enabled: enabled,
          onChanged: onPreviewUrlChanged,
        ),
        const SizedBox(height: 6),
        Text(
          l10n.artbookUploadHint,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: illustratedStyle
                ? FuvekonColors.darkTextSecondary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
