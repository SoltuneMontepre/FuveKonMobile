import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';

enum FuvePillButtonVariant { primary, secondary, outline }

class FuvePillButton extends StatelessWidget {
  const FuvePillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = FuvePillButtonVariant.primary,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final FuvePillButtonVariant variant;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (variant) {
      FuvePillButtonVariant.primary => (
        FuvekonColors.premiumPrimary,
        FuvekonColors.premiumOnPrimary,
        Colors.transparent,
      ),
      FuvePillButtonVariant.secondary => (
        FuvekonColors.premiumSecondary,
        FuvekonColors.premiumOnPrimary,
        Colors.transparent,
      ),
      FuvePillButtonVariant.outline => (
        Colors.transparent,
        FuvekonColors.premiumPrimary,
        FuvekonColors.premiumPrimary,
      ),
    };

    final child = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );

    return Material(
      color: bg,
      shape: StadiumBorder(
        side: BorderSide(
          color: border,
          width: variant == FuvePillButtonVariant.outline ? 1.5 : 0,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: expanded
              ? SizedBox(width: double.infinity, child: child)
              : child,
        ),
      ),
    );
  }
}
