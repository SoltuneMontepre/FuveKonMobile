import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/notification/presentation/pages/notifications_page.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/screens/admin/widgets/staff_greeting.dart';
import 'package:fuvekonmobile/shared/widgets/s3_avatar.dart';

class StaffScanHeader extends StatelessWidget {
  const StaffScanHeader({
    super.key,
    required this.account,
    this.hasUnreadNotifications = false,
  });

  final Account account;
  final bool hasUnreadNotifications;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = account.displayName ?? account.email.split('@').first;

    return Row(
      children: [
        S3Avatar(
          imageUrl: account.avatar,
          radius: 24,
          initials: account.initials,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                staffGreeting(context.l10n),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              ),
              Text(
                displayName,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: FuvekonColors.darkText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const NotificationsPage(),
              ),
            );
          },
          icon: Badge(
            isLabelVisible: hasUnreadNotifications,
            child: const Icon(
              Icons.notifications_outlined,
              color: FuvekonColors.darkText,
            ),
          ),
        ),
      ],
    );
  }
}
