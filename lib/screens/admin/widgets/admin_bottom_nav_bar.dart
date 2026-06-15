import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(
      label: 'Trang chủ',
      icon: Icons.home_outlined,
      route: Routes.admin,
    ),
    _NavItem(
      label: 'Quét mã',
      icon: Icons.qr_code_scanner_outlined,
      route: Routes.adminScanTicket,
    ),
    _NavItem(
      label: 'Lịch sử',
      icon: Icons.history_rounded,
      route: Routes.adminHistory,
    ),
    _NavItem(
      label: 'Thất lạc',
      icon: Icons.inventory_2_outlined,
      route: Routes.adminLostFound,
    ),
    _NavItem(
      label: 'Tài khoản',
      icon: Icons.person_outline,
      route: Routes.adminAccount,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurface,
        border: Border(
          top: BorderSide(
            color: FuvekonColors.darkBorder.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final selected = currentIndex == index;
              return Expanded(
                child: _NavButton(
                  item: item,
                  selected: selected,
                  onTap: () {
                    if (selected) return;
                    onTap(index);
                    context.go(item.route);
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        selected ? FuvekonColors.darkPrimary : FuvekonColors.darkTextSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: selected ? 5 : 0,
              height: selected ? 5 : 0,
              decoration: BoxDecoration(
                color: FuvekonColors.darkText,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
