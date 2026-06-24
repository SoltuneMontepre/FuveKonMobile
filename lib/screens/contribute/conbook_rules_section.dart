import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/contribute/conbook_content.dart';

enum ConbookRulesVariant { illustrated, card, dark }

class ConbookRulesSection extends StatelessWidget {
  const ConbookRulesSection({
    super.key,
    required this.l10n,
    this.variant = ConbookRulesVariant.illustrated,
  });

  final AppLocalizations l10n;
  final ConbookRulesVariant variant;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      ConbookRulesVariant.illustrated => DecoratedBox(
        decoration: BoxDecoration(
          color: FuvekonColors.mintCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: _ConbookRulesBody(
            l10n: l10n,
            titleColor: FuvekonColors.onSageGreen,
            sectionColor: FuvekonColors.onSageGreen,
            bodyColor: FuvekonColors.textSecondary,
          ),
        ),
      ),
      ConbookRulesVariant.card => _ConbookRulesBody(
        l10n: l10n,
        titleColor: FuvekonColors.onSageGreen,
        sectionColor: FuvekonColors.onSageGreen,
        bodyColor: FuvekonColors.textSecondary,
      ),
      ConbookRulesVariant.dark => DecoratedBox(
        decoration: BoxDecoration(
          color: FuvekonColors.darkSurfaceElevated,
          borderRadius: BorderRadius.circular(FuvekonRadii.notes),
          border: Border.all(
            color: FuvekonColors.darkBorder.withValues(alpha: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _ConbookRulesBody(
            l10n: l10n,
            titleColor: FuvekonColors.darkPrimary,
            bodyColor: FuvekonColors.darkTextSecondary.withValues(alpha: 0.95),
            sectionColor: FuvekonColors.darkText,
          ),
        ),
      ),
    };
  }
}

class _ConbookRulesBody extends StatelessWidget {
  const _ConbookRulesBody({
    required this.l10n,
    this.titleColor,
    this.bodyColor,
    this.sectionColor,
  });

  final AppLocalizations l10n;
  final Color? titleColor;
  final Color? bodyColor;
  final Color? sectionColor;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;
    final resolvedTitleColor = titleColor ?? ext.contentOnCard;
    final resolvedBodyColor = bodyColor ?? ext.contentOnCardMuted;
    final resolvedSectionColor = sectionColor ?? ext.contentOnCard;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.gavel_outlined, color: resolvedTitleColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.artbookRulesTitle,
                style: TextStyle(
                  color: resolvedTitleColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _Subsection(
          title: l10n.artbookRulesFormatSection,
          items: ConbookContent.formatRequirements(l10n),
          titleColor: resolvedSectionColor,
          bodyColor: resolvedBodyColor,
        ),
        const SizedBox(height: 20),
        _Subsection(
          title: l10n.artbookRulesTipsSection,
          items: ConbookContent.tips(l10n),
          titleColor: resolvedSectionColor,
          bodyColor: resolvedBodyColor,
        ),
      ],
    );
  }
}

class _Subsection extends StatelessWidget {
  const _Subsection({
    required this.title,
    required this.items,
    required this.titleColor,
    required this.bodyColor,
  });

  final String title;
  final List<String> items;
  final Color titleColor;
  final Color bodyColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: bodyColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ConbookScrollSeparator extends StatelessWidget {
  const ConbookScrollSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.white.withValues(alpha: 0.18),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.more_horiz,
              size: 18,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.white.withValues(alpha: 0.18),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
