import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/fuvekon_top_nav_bar.dart';
import 'package:fuvekonmobile/shared/widgets/s3_avatar.dart';

class AdminHomeAppBar extends StatelessWidget {
  const AdminHomeAppBar({
    super.key,
    this.onMenuTap,
    this.avatarUrl,
    this.initials = '?',
    this.onAvatarTap,
  });

  final VoidCallback? onMenuTap;
  final String? avatarUrl;
  final String initials;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenuTap ?? FuvekonGuestDrawer.openFromAdminShell,
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            icon: const Icon(Icons.menu_rounded, color: FuvekonColors.darkText),
          ),
          Expanded(
            child: Text(
              'FUVEKON Admin',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: FuvekonColors.darkText,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
            ),
          ),
          IconButton(
            onPressed: onAvatarTap,
            padding: EdgeInsets.zero,
            icon: S3Avatar(
              imageUrl: avatarUrl,
              initials: initials,
              radius: 18,
            ),
          ),
        ],
      ),
    );
  }
}
