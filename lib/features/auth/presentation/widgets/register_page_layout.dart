import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';

abstract final class _RegisterColors {
  static const cardBg = Color(0xFFD1EAD8);
  static const textDark = Color(0xFF0A2E1F);
  static const starGold = FuvekonColors.tier3;
}

class RegisterPageLayout extends StatelessWidget {
  const RegisterPageLayout({
    super.key,
    required this.form,
    required this.footer,
  });

  final Widget form;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return FuvekonNavScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _RegisterColors.cardBg,
              borderRadius: BorderRadius.circular(FuvekonRadii.card),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _RegisterHeader(l10n: context.l10n),
                  const SizedBox(height: 24),
                  form,
                  const SizedBox(height: 20),
                  footer,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.registerTitle,
              style: TextStyle(
                color: _RegisterColors.textDark,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.auto_awesome,
              size: 18,
              color: _RegisterColors.starGold.withValues(alpha: 0.95),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.registerSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _RegisterColors.textDark.withValues(alpha: 0.72),
            fontSize: 13.5,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
