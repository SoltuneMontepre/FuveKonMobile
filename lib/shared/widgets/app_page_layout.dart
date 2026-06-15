import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';

/// Standard page shell: dark background, sage app-bar title, optional back button.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = true,
    this.padding = const EdgeInsets.all(FuvekonSpacing.page),
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton && canPop,
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: Padding(
        padding: padding,
        child: body,
      ),
    );
  }
}

/// Scrollable page with optional pale-sage content card (matches dealer form layout).
class AppScrollPage extends StatelessWidget {
  const AppScrollPage({
    super.key,
    this.title,
    required this.child,
    this.footer,
    this.hero,
    this.wrapInCard = true,
    this.showBackButton = true,
    this.padding = const EdgeInsets.all(FuvekonSpacing.page),
  });

  final String? title;
  final Widget child;
  final Widget? footer;
  final Widget? hero;
  final bool wrapInCard;
  final bool showBackButton;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              automaticallyImplyLeading: showBackButton && canPop,
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (hero != null) ...[
                hero!,
                const SizedBox(height: FuvekonSpacing.section),
              ],
              if (wrapInCard)
                AppContentCard(child: child)
              else
                child,
              if (footer != null) ...[
                const SizedBox(height: FuvekonSpacing.field),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Large rounded pale-sage card used for forms and grouped content.
class AppContentCard extends StatelessWidget {
  const AppContentCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(FuvekonSpacing.card),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;

    return Material(
      color: ext.contentCard,
      borderRadius: BorderRadius.circular(FuvekonRadii.card),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Section heading inside a content card.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ext.contentOnCard,
              ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ext.contentOnCardMuted,
                ),
          ),
        ],
      ],
    );
  }
}

/// Form field label with optional required asterisk.
class AppFormLabel extends StatelessWidget {
  const AppFormLabel({
    super.key,
    required this.text,
    this.required = false,
  });

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
          color: ext.contentOnCard,
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text.rich(
        TextSpan(
          text: text,
          style: style,
          children: [
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Color(0xFFD64550)),
              ),
          ],
        ),
      ),
    );
  }
}

/// Label + input column matching the dealer-registration form style.
class AppLabeledField extends StatelessWidget {
  const AppLabeledField({
    super.key,
    required this.label,
    required this.field,
    this.required = false,
  });

  final String label;
  final Widget field;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppFormLabel(text: label, required: required),
        field,
      ],
    );
  }
}

/// Dashed upload zone for images and files.
class AppUploadZone extends StatelessWidget {
  const AppUploadZone({
    super.key,
    required this.label,
    this.hint,
    this.onTap,
  });

  final String label;
  final String? hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;

    return Material(
      color: ext.uploadZoneBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FuvekonRadii.upload),
        side: BorderSide(
          color: ext.uploadZoneBorder,
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FuvekonRadii.upload),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          child: Column(
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 36,
                color: ext.uploadZoneBorder,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ext.contentOnCardMuted,
                    ),
                textAlign: TextAlign.center,
              ),
              if (hint != null) ...[
                const SizedBox(height: 4),
                Text(
                  hint!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ext.contentOnCardMuted.withValues(alpha: 0.8),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Notes / conditions block shown below forms on the dark background.
class AppInfoSection extends StatelessWidget {
  const AppInfoSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: ext.notesSurface,
        borderRadius: BorderRadius.circular(FuvekonRadii.notes),
      ),
      child: Padding(
        padding: const EdgeInsets.all(FuvekonSpacing.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: ext.infoAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: ext.infoTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '• $item',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
