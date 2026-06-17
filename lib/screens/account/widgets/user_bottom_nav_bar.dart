import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class UserBottomNavBar extends StatelessWidget {
  const UserBottomNavBar({
    super.key,
    required this.currentBranchIndex,
    required this.onTap,
  });

  final int currentBranchIndex;
  final ValueChanged<int> onTap;

  static const _routes = [
    Routes.account,
    Routes.accountSchedule,
    Routes.accountTicket,
    Routes.accountNotifications,
    Routes.accountProfile,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      (label: l10n.navHome, icon: Icons.home_outlined),
      (label: l10n.navSchedule, icon: Icons.calendar_month_outlined),
      (label: l10n.navMyTickets, icon: Icons.confirmation_number_outlined),
      (label: l10n.navNotifications, icon: Icons.notifications_outlined),
      (label: l10n.navAccount, icon: Icons.person_outline),
    ];

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: FuvekonColors.premiumNav.withValues(alpha: 0.92),
            border: Border(
              top: BorderSide(
                color: FuvekonColors.premiumPrimary.withValues(alpha: 0.12),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: List.generate(items.length, (index) {
                  final selected = currentBranchIndex == index;
                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        if (selected) return;
                        onTap(index);
                        context.go(_routes[index]);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              items[index].icon,
                              color: selected
                                  ? FuvekonColors.premiumPrimary
                                  : FuvekonColors.premiumOnSurfaceVariant,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              items[index].label,
                              style: TextStyle(
                                color: selected
                                    ? FuvekonColors.premiumPrimary
                                    : FuvekonColors.premiumOnSurfaceVariant,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: selected ? 5 : 0,
                              height: selected ? 5 : 0,
                              decoration: const BoxDecoration(
                                color: FuvekonColors.premiumPrimary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
