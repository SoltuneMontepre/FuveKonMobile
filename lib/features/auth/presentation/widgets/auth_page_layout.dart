import 'package:flutter/material.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_hero.dart';

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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              AuthHero(title: heroTitle, subtitle: heroSubtitle),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: child,
                ),
              ),
              if (footer != null) ...[
                const SizedBox(height: 16),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
