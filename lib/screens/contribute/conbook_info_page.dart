import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/screens/contribute/conbook_rules_section.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:go_router/go_router.dart';

/// Màn 30 — static conbook info page linked from shortcuts.
class ConbookInfoPage extends StatelessWidget {
  const ConbookInfoPage({super.key, this.showSubmitButton = true});

  final bool showSubmitButton;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ext = context.fuvekonTheme;

    return AppPageScaffold(
      title: l10n.artbookTitle,
      body: ListView(
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
                  style: TextStyle(color: ext.contentOnCardMuted, height: 1.5),
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
          if (showSubmitButton) ...[
            const SizedBox(height: FuvekonSpacing.stackGapLg),
            FuvePillButton(
              label: l10n.artbookSubmitCta,
              icon: Icons.upload_outlined,
              onPressed: () => context.push(Routes.artbookSubmit),
            ),
          ],
        ],
      ),
    );
  }
}
