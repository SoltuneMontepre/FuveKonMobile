import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';

abstract final class _LoginColors {
  static const cardBg = FuvekonColors.mintCard;
  static const textDark = FuvekonColors.darkButtonText;
  static const titleAccent = FuvekonColors.darkPrimary;
}

class LoginPageLayout extends StatelessWidget {
  const LoginPageLayout({
    super.key,
    required this.form,
    required this.footer,
  });

  final Widget form;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FuvekonNavScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _LoginBrandHeader(),
              const SizedBox(height: 28),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: _LoginColors.cardBg,
                  borderRadius: BorderRadius.circular(FuvekonRadii.card),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.loginTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _LoginColors.textDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 24),
                      form,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              footer,
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginBrandHeader extends StatelessWidget {
  const _LoginBrandHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFE8F5EC),
              _LoginColors.titleAccent,
              FuvekonColors.tier3,
            ],
            stops: [0.0, 0.55, 1.0],
          ).createShader(bounds),
          child: const Text(
            'FUVEKON',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 4,
              fontSize: 36,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.brandTagline,
          style: TextStyle(
            color: _LoginColors.titleAccent.withValues(alpha: 0.85),
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
