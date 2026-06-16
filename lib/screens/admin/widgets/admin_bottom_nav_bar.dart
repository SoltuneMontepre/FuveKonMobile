import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/auth/user_permissions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({
    super.key,
    required this.currentBranchIndex,
    required this.hasPermission,
    required this.onTap,
  });

  final int currentBranchIndex;
  final bool Function(String permission) hasPermission;
  final ValueChanged<int> onTap;

  static const _branchLabels = {
    0: ('Trang chủ', Icons.home_outlined),
    1: ('Thống kê', Icons.analytics_outlined),
    2: ('Quét mã', Icons.qr_code_scanner_outlined),
    3: ('Lịch sử', Icons.history_rounded),
    4: ('Thất lạc', Icons.inventory_2_outlined),
    5: ('Hệ thống', Icons.dns_outlined),
  };

  List<_NavItem> _visibleItems() {
    return UserPermissions.adminShellBranches
        .where(
          (branch) =>
              branch.requiredPermission == null ||
              hasPermission(branch.requiredPermission!),
        )
        .map((branch) {
          final meta = _branchLabels[branch.branchIndex]!;
          return _NavItem(
            label: meta.$1,
            icon: meta.$2,
            route: branch.route,
            branchIndex: branch.branchIndex,
          );
        })
        .toList();
  }

  int _navIndexForBranch(List<_NavItem> items, int branchIndex) {
    return items.indexWhere((item) => item.branchIndex == branchIndex);
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleItems();
    if (items.isEmpty) return const SizedBox.shrink();

    final currentNavIndex = _navIndexForBranch(items, currentBranchIndex);

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
            children: List.generate(items.length, (index) {
              final item = items[index];
              final selected = currentNavIndex == index;
              return Expanded(
                child: _NavButton(
                  item: item,
                  selected: selected,
                  onTap: () {
                    if (selected) return;
                    onTap(item.branchIndex);
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
    required this.branchIndex,
  });

  final String label;
  final IconData icon;
  final String route;
  final int branchIndex;
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
