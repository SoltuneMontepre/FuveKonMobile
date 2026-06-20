import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
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
        body: FuvekonIllustratedPageStack(
          child: SafeArea(child: body),
        ),
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
                  ..._ruleCards(l10n),
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

  List<Widget> _ruleCards(AppLocalizations l10n) {
    final cards = [
      (
        icon: Icons.badge_outlined,
        iconBg: const Color(0xFF3D6B52),
        title: l10n.rulesAttendanceTitle,
        items: [l10n.rulesAttendance1, l10n.rulesAttendance2, l10n.rulesAttendance3],
      ),
      (
        icon: Icons.checkroom_outlined,
        iconBg: const Color(0xFFE879A8),
        title: l10n.rulesCosplayTitle,
        items: [l10n.rulesCosplay1, l10n.rulesCosplay2, l10n.rulesCosplay3],
      ),
      (
        icon: Icons.storefront_outlined,
        iconBg: const Color(0xFFE8B84A),
        title: l10n.rulesBoothTitle,
        items: [l10n.rulesBooth1, l10n.rulesBooth2, l10n.rulesBooth3],
      ),
      (
        icon: Icons.block_outlined,
        iconBg: const Color(0xFF5A5A5A),
        title: l10n.rulesConductTitle,
        items: [l10n.rulesConduct1, l10n.rulesConduct2, l10n.rulesConduct3],
      ),
    ];

    return [
      for (var i = 0; i < cards.length; i++) ...[
        if (i > 0) const SizedBox(height: 14),
        _RuleCard(
          icon: cards[i].icon,
          iconBg: cards[i].iconBg,
          title: cards[i].title,
          items: cards[i].items,
        ),
      ],
    ];
  }
}

abstract final class _RulesColors {
  static const title = FuvekonColors.darkPrimary;
  static const cardBg = FuvekonColors.mintCard;
  static const textDark = FuvekonColors.darkButtonText;
  static const textMuted = FuvekonColors.textSecondary;
  static const accentGreen = FuvekonColors.sageGreenContainer;
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.items,
  });

  final IconData icon;
  final Color iconBg;
  final String title;
  final List<String> items;

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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
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
          ...items.map(
            (item) => Padding(
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
