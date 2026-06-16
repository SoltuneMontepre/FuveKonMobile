import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/theme_mode_notifier.dart';
import 'package:go_router/go_router.dart';

class FuvekonTopNavBar extends StatelessWidget {
  const FuvekonTopNavBar({super.key});

  static bool isAuthRoute(String location) {
    return location == Routes.login ||
        location == Routes.forgotPassword ||
        location.startsWith('${Routes.register}/') ||
        location == Routes.register;
  }

  static bool isSelected(String route, String location) {
    if (route == Routes.login) return isAuthRoute(location);
    return location == route || location.startsWith('$route/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = GoRouterState.of(context).matchedLocation;
    final themeModeNotifier = sl<ThemeModeNotifier>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      (label: l10n.navIntroduction, route: Routes.introduction),
      (label: l10n.navFaq, route: Routes.faq),
      (label: l10n.navRules, route: Routes.tos),
      (label: l10n.navLogin, route: Routes.login),
    ];

    final background = Theme.of(context).scaffoldBackgroundColor;
    final brandColor =
        isDark ? const Color(0xFFD1EAD8) : FuvekonColors.textPrimary;
    final iconColor = isDark ? Colors.white : FuvekonColors.textPrimary;
    final borderColor = isDark
        ? const Color(0xFF2A2A2A)
        : FuvekonColors.inputBorder.withValues(alpha: 0.45);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'FUVEKON',
                    style: TextStyle(
                      color: brandColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      fontSize: 15,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    themeModeNotifier.isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: iconColor,
                  ),
                  tooltip: themeModeNotifier.isDark
                      ? l10n.themeSwitchToLight
                      : l10n.themeSwitchToDark,
                  onPressed: themeModeNotifier.toggle,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: Icon(Icons.translate, color: iconColor),
                  tooltip: l10n.languageTitle,
                  onPressed: () => context.go(Routes.language),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    _NavChip(
                      label: items[i].label,
                      selected: isSelected(items[i].route, location),
                      isDark: isDark,
                      onTap: () {
                        if (location == items[i].route) return;
                        context.go(items[i].route);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavChip extends StatelessWidget {
  const _NavChip({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unselectedBg =
        isDark ? const Color(0xFF1E1E1E) : FuvekonColors.bgSecondary;
    final unselectedText =
        isDark ? const Color(0xFF8FA898) : FuvekonColors.textSecondary;

    return Material(
      color: selected ? const Color(0xFF4A7C59) : unselectedBg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : unselectedText,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class FuvekonNavScaffold extends StatelessWidget {
  const FuvekonNavScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
  });

  final Widget body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SafeArea(bottom: false, child: FuvekonTopNavBar()),
          Expanded(child: body),
        ],
      ),
    );
  }
}
