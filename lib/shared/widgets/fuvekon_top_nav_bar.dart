import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/theme_mode_notifier.dart';
import 'package:go_router/go_router.dart';

class FuvekonGuestDrawer extends StatelessWidget {
  const FuvekonGuestDrawer({super.key});

  static void open(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeModeNotifier = sl<ThemeModeNotifier>();
    final location = GoRouterState.of(context).matchedLocation;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navItems = [
      (icon: Icons.home_outlined, label: l10n.navHome, route: Routes.home),
      (
        icon: Icons.account_balance_outlined,
        label: l10n.navIntroduction,
        route: Routes.introduction,
      ),
      (icon: Icons.help_outline, label: l10n.navFaq, route: Routes.faq),
      (icon: Icons.description_outlined, label: l10n.navRules, route: Routes.tos),
      (icon: Icons.login_outlined, label: l10n.navLogin, route: Routes.login),
    ];

    return Drawer(
      backgroundColor: isDark ? FuvekonColors.darkSurface : FuvekonColors.paper,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Text(
                'FUVEKON',
                style: TextStyle(
                  color: isDark
                      ? FuvekonColors.darkPrimary
                      : FuvekonColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  for (final item in navItems)
                    _DrawerNavTile(
                      icon: item.icon,
                      label: item.label,
                      selected: _isSelected(item.route, location),
                      onTap: () {
                        Navigator.of(context).pop();
                        if (location != item.route) {
                          context.go(item.route);
                        }
                      },
                    ),
                  const Divider(height: 24, indent: 16, endIndent: 16),
                  _DrawerNavTile(
                    icon: Icons.translate,
                    label: l10n.languageTitle,
                    selected: location == Routes.language,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go(Routes.language);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      themeModeNotifier.isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      color: isDark ? Colors.white : FuvekonColors.textPrimary,
                    ),
                    title: Text(
                      themeModeNotifier.isDark
                          ? l10n.themeSwitchToLight
                          : l10n.themeSwitchToDark,
                      style: TextStyle(
                        color: isDark ? Colors.white : FuvekonColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: themeModeNotifier.toggle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static bool _isSelected(String route, String location) {
    if (route == Routes.login) {
      return FuvekonTopNavBar.isAuthRoute(location);
    }
    return location == route || location.startsWith('$route/');
  }
}

class _DrawerNavTile extends StatelessWidget {
  const _DrawerNavTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor =
        isDark ? FuvekonColors.darkPrimary : FuvekonColors.primary;

    return ListTile(
      leading: Icon(
        icon,
        color: selected
            ? selectedColor
            : (isDark ? Colors.white70 : FuvekonColors.textSecondary),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: selected
              ? selectedColor
              : (isDark ? Colors.white : FuvekonColors.textPrimary),
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: selected,
      onTap: onTap,
    );
  }
}

/// Minimal top bar: hamburger menu + brand title.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandColor =
        isDark ? FuvekonColors.darkPrimary : FuvekonColors.textPrimary;
    final iconColor = isDark ? Colors.white : FuvekonColors.textPrimary;
    final borderColor = isDark
        ? FuvekonColors.darkBorder
        : FuvekonColors.inputBorder.withValues(alpha: 0.45);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 12, 10),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: iconColor),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              onPressed: () => FuvekonGuestDrawer.open(context),
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: Text(
                'FUVEKON',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: brandColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
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
      drawer: const FuvekonGuestDrawer(),
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

/// Transparent header for landing page over background imagery.
class FuvekonLandingHeader extends StatelessWidget {
  const FuvekonLandingHeader({super.key});

  static const brandColor = FuvekonColors.darkPrimary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: brandColor),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            onPressed: () => FuvekonGuestDrawer.open(context),
            visualDensity: VisualDensity.compact,
          ),
          const Expanded(
            child: Text(
              'FUVEKON',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: brandColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
