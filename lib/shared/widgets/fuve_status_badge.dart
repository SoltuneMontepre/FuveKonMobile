import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';

enum FuveStatusBadgeVariant { success, pending, denied, neutral }

class FuveStatusBadge extends StatelessWidget {
  const FuveStatusBadge({
    super.key,
    required this.label,
    this.variant = FuveStatusBadgeVariant.neutral,
    this.icon,
  });

  final String label;
  final FuveStatusBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (variant) {
      FuveStatusBadgeVariant.success => (
        FuvekonColors.statusSuccessBg,
        FuvekonColors.premiumOnPrimary,
      ),
      FuveStatusBadgeVariant.pending => (
        FuvekonColors.statusPendingBg,
        Colors.white,
      ),
      FuveStatusBadgeVariant.denied => (
        FuvekonColors.statusDeniedBg,
        FuvekonColors.statusDeniedText,
      ),
      FuveStatusBadgeVariant.neutral => (
        FuvekonColors.premiumSurfaceContainerHigh,
        FuvekonColors.premiumOnSurface,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
