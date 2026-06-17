import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';
import 'package:go_router/go_router.dart';

class GuestLandingPage extends StatelessWidget {
  const GuestLandingPage({super.key});

  static const backgroundAsset =
      'assets/images/un-auth-user-landing-section.png';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      drawer: const FuvekonGuestDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Align(
            alignment: Alignment.bottomCenter,
            child: _LandingBackground(),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FuvekonLandingHeader(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final topInset = constraints.maxHeight * 0.30;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: topInset),
                              _EventBadge(label: l10n.landingBadge),
                              const SizedBox(height: 20),
                              Text(
                                l10n.landingHeroTitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: _LandingColors.heroTitle,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.landingHeroBody,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: FuvekonColors.darkText.withValues(
                                    alpha: 0.88,
                                  ),
                                  fontSize: 15,
                                  height: 1.55,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 28),
                              Row(
                                children: [
                                  Expanded(
                                    child: _PrimaryPillButton(
                                      label: l10n.landingRegister,
                                      backgroundColor:
                                          _LandingColors.mintButton,
                                      foregroundColor:
                                          _LandingColors.mintButtonText,
                                      onTap: () => context.go(Routes.register),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _PrimaryPillButton(
                                      label: l10n.landingViewTickets,
                                      backgroundColor:
                                          _LandingColors.pinkButton,
                                      foregroundColor:
                                          _LandingColors.pinkButtonText,
                                      onTap: () => context.go(Routes.ticket),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _OutlinePillButton(
                                label: l10n.loginTitle,
                                onTap: () => context.go(Routes.login),
                              ),
                              const SizedBox(height: 48),
                              Text(
                                l10n.landingExperienceTitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: _LandingColors.heroTitle,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                l10n.landingExperienceBody,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: FuvekonColors.darkTextSecondary
                                      .withValues(alpha: 0.9),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
  static const heroTitle = Color(0xFFD1EAD8);
  static const mintButton = Color(0xFFD1EAD8);
  static const mintButtonText = Color(0xFF0A2E1F);
  static const pinkButton = Color(0xFFE8C4D0);
  static const pinkButtonText = Color(0xFF3D1F2A);
  static const badgeDot = Color(0xFFE8C547);
}

class _LandingBackground extends StatelessWidget {
  const _LandingBackground();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      GuestLandingPage.backgroundAsset,
      fit: BoxFit.fitWidth,
      alignment: Alignment.bottomCenter,
      width: MediaQuery.sizeOf(context).width,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class _EventBadge extends StatelessWidget {
  const _EventBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: _LandingColors.badgeDot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
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
          padding: const EdgeInsets.symmetric(vertical: 14),
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
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
