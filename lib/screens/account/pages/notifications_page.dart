import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ColoredBox(
      color: FuvekonColors.darkBg,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 56,
                  color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.navNotifications,
                  style: const TextStyle(
                    color: FuvekonColors.darkPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.authHomeNotificationsEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
