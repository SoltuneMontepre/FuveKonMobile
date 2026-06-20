import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_illustrated_background.dart';

/// Wraps interactive sections on illustrated pages with the dark content panel
/// and light-on-dark theme tokens for nested form widgets.
class AppIllustratedInteractiveSection extends StatelessWidget {
  const AppIllustratedInteractiveSection({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<FuvekonThemeExtension>()!;

    final illustratedExt = ext.copyWith(
      contentCard: Colors.transparent,
      contentOnCard: FuvekonColors.darkPrimary,
      contentOnCardMuted: FuvekonColors.darkTextSecondary,
      uploadZoneBackground: FuvekonColors.darkSurface.withValues(alpha: 0.55),
      uploadZoneBorder: Colors.white.withValues(alpha: 0.22),
      infoTitle: Colors.white,
      notesSurface: Colors.black.withValues(alpha: 0.35),
    );

    return Theme(
      data: theme.copyWith(
        extensions: theme.extensions.values.map<ThemeExtension<dynamic>>((
          extension,
        ) {
          return extension is FuvekonThemeExtension
              ? illustratedExt
              : extension;
        }).toList(),
      ),
      child: FuvekonIllustratedContentPanel(
        padding: padding ?? const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: child,
      ),
    );
  }
}

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
    this.illustratedBackground = false,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final EdgeInsetsGeometry padding;
  final bool illustratedBackground;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final content = illustratedBackground
        ? AppIllustratedInteractiveSection(child: body)
        : Padding(padding: padding, child: body);

    return Scaffold(
      extendBodyBehindAppBar: illustratedBackground,
      backgroundColor: illustratedBackground ? FuvekonColors.darkBg : null,
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton && canPop,
        actions: actions,
        backgroundColor: illustratedBackground ? Colors.transparent : null,
        elevation: illustratedBackground ? 0 : null,
        scrolledUnderElevation: illustratedBackground ? 0 : null,
        surfaceTintColor: illustratedBackground ? Colors.transparent : null,
      ),
      floatingActionButton: floatingActionButton,
      body: illustratedBackground
          ? FuvekonIllustratedPageStack(
              child: SafeArea(
                child: Padding(padding: padding, child: content),
              ),
            )
          : content,
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
    this.illustratedBackground = false,
  });

  final String? title;
  final Widget child;
  final Widget? footer;
  final Widget? hero;
  final bool wrapInCard;
  final bool showBackButton;
  final EdgeInsetsGeometry padding;
  final bool illustratedBackground;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final scrollContent = SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hero != null) ...[
            hero!,
            const SizedBox(height: FuvekonSpacing.section),
          ],
          if (wrapInCard)
            illustratedBackground
                ? AppIllustratedInteractiveSection(child: child)
                : AppContentCard(child: child)
          else
            child,
          if (footer != null) ...[
            const SizedBox(height: FuvekonSpacing.field),
            illustratedBackground
                ? AppIllustratedInteractiveSection(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: footer!,
                  )
                : footer!,
          ],
        ],
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: illustratedBackground,
      backgroundColor: illustratedBackground ? FuvekonColors.darkBg : null,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              automaticallyImplyLeading: showBackButton && canPop,
              backgroundColor: illustratedBackground
                  ? Colors.transparent
                  : null,
              elevation: illustratedBackground ? 0 : null,
              scrolledUnderElevation: illustratedBackground ? 0 : null,
              surfaceTintColor: illustratedBackground
                  ? Colors.transparent
                  : null,
            ),
      body: illustratedBackground
          ? FuvekonIllustratedPageStack(child: SafeArea(child: scrollContent))
          : SafeArea(child: scrollContent),
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
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Section heading inside a content card.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({super.key, required this.title, this.subtitle});

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
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: ext.contentOnCard),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: ext.contentOnCardMuted),
          ),
        ],
      ],
    );
  }
}

/// Form field label with optional required asterisk.
class AppFormLabel extends StatelessWidget {
  const AppFormLabel({super.key, required this.text, this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: ext.contentOnCard);

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
  const AppUploadZone({super.key, required this.label, this.hint, this.onTap});

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
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: ext.contentOnCardMuted),
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
  const AppInfoSection({super.key, required this.title, required this.items});

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
                child: Text('• $item', style: theme.textTheme.bodySmall),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
