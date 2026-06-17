import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';

/// Mint content card per Figma / color.md (#E4EEE3 on dark canvas).
class FuveMintCard extends StatelessWidget {
  const FuveMintCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(FuvekonSpacing.card),
    this.onTap,
    this.showGoldAccent = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool showGoldAccent;

  @override
  Widget build(BuildContext context) {
    final theme = context.fuvekonTheme;
    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.contentCard,
        borderRadius: BorderRadius.circular(FuvekonRadii.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (showGoldAccent)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: FuvekonColors.premiumDecorativeGold
                        .withValues(alpha: 0.35),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FuvekonRadii.card),
        child: card,
      ),
    );
  }
}
