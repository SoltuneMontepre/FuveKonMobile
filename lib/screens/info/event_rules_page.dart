import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/info/event_rules_content.dart';
import 'package:fuvekonmobile/shared/services/app_preferences.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_illustrated_background.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';
import 'package:go_router/go_router.dart';

class EventRulesPage extends StatefulWidget {
  const EventRulesPage({super.key, this.onboarding = false});

  final bool onboarding;

  @override
  State<EventRulesPage> createState() => _EventRulesPageState();
}

class _EventRulesPageState extends State<EventRulesPage> {
  bool _agreed = false;

  Future<void> _confirm() async {
    await sl<AppPreferences>().setEventRulesAccepted(true);
    if (!mounted) return;

    if (widget.onboarding) {
      context.go(Routes.home);
      return;
    }

    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final body = _RulesBody(
      l10n: l10n,
      showAcceptance: widget.onboarding,
      agreed: _agreed,
      onAgreedChanged: (value) => setState(() => _agreed = value),
      onConfirm: _agreed ? _confirm : null,
    );

    if (widget.onboarding) {
      return Scaffold(
        backgroundColor: FuvekonColors.darkBg,
        body: FuvekonIllustratedPageStack(child: SafeArea(child: body)),
      );
    }

    return FuvekonNavScaffold(body: body);
  }
}

class _RulesBody extends StatelessWidget {
  const _RulesBody({
    required this.l10n,
    required this.showAcceptance,
    required this.agreed,
    required this.onAgreedChanged,
    required this.onConfirm,
  });

  final AppLocalizations l10n;
  final bool showAcceptance;
  final bool agreed;
  final ValueChanged<bool> onAgreedChanged;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final groups = EventRulesContent.groups(l10n);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.rulesTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _RulesColors.title,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.rulesLastUpdated,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.rulesIntro,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 14,
                    height: 1.55,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                for (var g = 0; g < groups.length; g++) ...[
                  if (g > 0) const SizedBox(height: 20),
                  _SectionHeader(title: groups[g].title),
                  const SizedBox(height: 12),
                  for (var c = 0; c < groups[g].cards.length; c++) ...[
                    if (c > 0) const SizedBox(height: 14),
                    _RuleCard(card: groups[g].cards[c]),
                  ],
                ],
              ],
            ),
          ),
        ),
        if (showAcceptance)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: FuvekonIllustratedContentPanel(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () => onAgreedChanged(!agreed),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Checkbox(
                              value: agreed,
                              onChanged: (value) =>
                                  onAgreedChanged(value ?? false),
                              activeColor: _RulesColors.accentGreen,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.45),
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.rulesAgreeCheckbox,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13.5,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: onConfirm,
                    style: FilledButton.styleFrom(
                      backgroundColor: _RulesColors.accentGreen,
                      disabledBackgroundColor: const Color(0xFF3A3A3A),
                      disabledForegroundColor: const Color(0xFF888888),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      l10n.rulesConfirmButton,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
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

abstract final class _RulesColors {
  static const title = FuvekonColors.darkPrimary;
  static const cardBg = FuvekonColors.mintCard;
  static const textDark = FuvekonColors.darkButtonText;
  static const textMuted = FuvekonColors.textSecondary;
  static const accentGreen = FuvekonColors.sageGreenContainer;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontWeight: FontWeight.w700,
        fontSize: 15,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({required this.card});

  final EventRulesCardData card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: _RulesColors.cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (card.title != null) ...[
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: card.iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(card.icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    card.title!,
                    style: const TextStyle(
                      color: _RulesColors.textDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],
          ...card.paragraphs.map(_paragraph),
          if (card.paragraphs.isNotEmpty && card.items.isNotEmpty)
            const SizedBox(height: 4),
          ...card.items.map(_bullet),
          if (card.trailingParagraphs.isNotEmpty &&
              (card.items.isNotEmpty || card.paragraphs.isNotEmpty))
            const SizedBox(height: 6),
          ...card.trailingParagraphs.map(_paragraph),
        ],
      ),
    );
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: _RulesColors.textMuted,
          fontSize: 14,
          height: 1.45,
        ),
      ),
    );
  }

  Widget _bullet(String item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: _BulletDot(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item,
              style: const TextStyle(
                color: _RulesColors.textMuted,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletDot extends StatelessWidget {
  const _BulletDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: _RulesColors.textMuted,
        shape: BoxShape.circle,
      ),
    );
  }
}
