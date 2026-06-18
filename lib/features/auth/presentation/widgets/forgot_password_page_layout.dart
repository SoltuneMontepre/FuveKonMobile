import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';

abstract final class _ForgotColors {
  static const cardBg = FuvekonColors.mintCard;
  static const decorGold = FuvekonColors.lightGold;
}

class ForgotPasswordPageLayout extends StatelessWidget {
  const ForgotPasswordPageLayout({
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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: _ForgotColors.cardBg,
                  borderRadius: BorderRadius.circular(FuvekonRadii.card),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      form,
                      const SizedBox(height: 20),
                      footer,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -12,
                right: -8,
                child: _DecorBlob(
                  size: 72,
                  color: _ForgotColors.decorGold.withValues(alpha: 0.35),
                ),
              ),
              Positioned(
                bottom: -16,
                left: -10,
                child: _DecorBlob(
                  size: 88,
                  color: _ForgotColors.decorGold.withValues(alpha: 0.22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorBlob extends StatelessWidget {
  const _DecorBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
