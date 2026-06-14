import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_hero.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';

class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    super.key,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.child,
    this.footer,
  });

  final String heroTitle;
  final String heroSubtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return AppScrollPage(
      hero: AuthHero(title: heroTitle, subtitle: heroSubtitle),
      footer: footer,
      wrapInCard: true,
      child: child,
      padding: const EdgeInsets.symmetric(
        horizontal: FuvekonSpacing.page,
        vertical: FuvekonSpacing.section,
      ),
    );
  }
}
