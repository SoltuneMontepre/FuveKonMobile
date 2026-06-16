import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/shared/services/app_preferences.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';
import 'package:go_router/go_router.dart';

class EventRulesPage extends StatefulWidget {
  const EventRulesPage({super.key});

  @override
  State<EventRulesPage> createState() => _EventRulesPageState();
}

class _EventRulesPageState extends State<EventRulesPage> {
  bool _agreed = false;

  Future<void> _confirm() async {
    await sl<AppPreferences>().setEventRulesAccepted(true);
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FuvekonNavScaffold(
      body: Column(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => setState(() => _agreed = !_agreed),
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
                            value: _agreed,
                            onChanged: (value) =>
                                setState(() => _agreed = value ?? false),
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
                  onPressed: _agreed ? _confirm : null,
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
        ],
      ),
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
  static const title = Color(0xFFD1EAD8);
  static const cardBg = Color(0xFFF0F2F0);
  static const textDark = Color(0xFF0A2E1F);
  static const textMuted = Color(0xFF48715B);
  static const accentGreen = Color(0xFF4A7C59);
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
