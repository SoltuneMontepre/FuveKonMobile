import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

/// Admin entry point for single-user and broadcast notifications.
class AdminNotificationsHubPage extends StatelessWidget {
  const AdminNotificationsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminNotificationsHubTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          FuvekonSpacing.page,
          8,
          FuvekonSpacing.page,
          32,
        ),
        children: [
          Text(
            l10n.adminNotificationsHubSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: FuvekonColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _HubTile(
            icon: Icons.person_outline,
            title: l10n.adminNotificationSendToUser,
            subtitle: l10n.adminNotificationSendToUserHint,
            onTap: () => context.push(Routes.adminNotificationCreate),
          ),
          const SizedBox(height: 12),
          _HubTile(
            icon: Icons.campaign_outlined,
            title: l10n.adminNotificationBroadcastAction,
            subtitle: l10n.adminNotificationBroadcastSubtitle,
            onTap: () => context.push(Routes.adminNotificationBroadcast),
          ),
        ],
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  const _HubTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FuvekonColors.darkSurfaceElevated,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: FuvekonColors.darkPrimary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: FuvekonColors.darkText,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: FuvekonColors.darkTextSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: FuvekonColors.darkTextSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
