import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_illustrated_background.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';
import 'package:go_router/go_router.dart';

class GuestLandingPage extends StatelessWidget {
  const GuestLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      drawer: const FuvekonGuestDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: FuvekonIllustratedBackground()),
          // Soft bottom scrim so text stays readable without a heavy card.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.72),
                  ],
                  stops: const [0.0, 0.35, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FuvekonLandingHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 3),
                        Text(
                          l10n.landingHeroTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _LandingColors.heroTitle,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l10n.landingHeroBody,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: FuvekonColors.darkText.withValues(
                              alpha: 0.9,
                            ),
                            fontSize: 16,
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _PrimaryPillButton(
                          label: l10n.landingRegister,
                          backgroundColor: _LandingColors.mintButton,
                          foregroundColor: _LandingColors.mintButtonText,
                          onTap: () => context.go(Routes.register),
                        ),
                        const SizedBox(height: 12),
                        _OutlinePillButton(
                          label: l10n.loginTitle,
                          onTap: () => context.go(Routes.login),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () => context.go(Routes.ticket),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white.withValues(
                                alpha: 0.85,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              l10n.landingViewTickets,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
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
}

abstract final class _LandingColors {
  static const heroTitle = FuvekonColors.darkPrimary;
  static const mintButton = FuvekonColors.darkButton;
  static const mintButtonText = FuvekonColors.darkButtonText;
}

class _PrimaryPillButton extends StatelessWidget {
  const _PrimaryPillButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinePillButton extends StatelessWidget {
  const _OutlinePillButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.55),
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
