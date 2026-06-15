import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({
    super.key,
    required this.currentBranchIndex,
    required this.isAdmin,
    required this.onTap,
  });

  final int currentBranchIndex;
  final bool isAdmin;
  final ValueChanged<int> onTap;

  static const _adminBranchIndices = [0, 1, 2, 3, 4, 5];
  static const _staffBranchIndices = [0, 2, 3, 4, 5];

  static const _allItems = [
    _NavItem(
      label: 'Trang chủ',
      icon: Icons.home_outlined,
      route: Routes.admin,
      adminOnly: false,
    ),
    _NavItem(
      label: 'Thống kê',
      icon: Icons.analytics_outlined,
      route: Routes.adminDashboard,
      adminOnly: true,
    ),
    _NavItem(
      label: 'Quét mã',
      icon: Icons.qr_code_scanner_outlined,
      route: Routes.adminScanTicket,
      adminOnly: false,
    ),
    _NavItem(
      label: 'Lịch sử',
      icon: Icons.history_rounded,
      route: Routes.adminHistory,
      adminOnly: false,
    ),
    _NavItem(
      label: 'Thất lạc',
      icon: Icons.inventory_2_outlined,
      route: Routes.adminLostFound,
      adminOnly: false,
    ),
    _NavItem(
      label: 'Tài khoản',
      icon: Icons.person_outline,
      route: Routes.adminAccount,
      adminOnly: false,
    ),
  ];

  List<_NavItem> _itemsFor(bool isAdmin) =>
      _allItems.where((item) => !item.adminOnly || isAdmin).toList();

  List<int> _branchIndicesFor(bool isAdmin) =>
      isAdmin ? _adminBranchIndices : _staffBranchIndices;

  int _navIndexForBranch(int branchIndex, bool isAdmin) {
    return _branchIndicesFor(isAdmin).indexOf(branchIndex);
  }

  int _branchIndexForNav(int navIndex, bool isAdmin) {
    return _branchIndicesFor(isAdmin)[navIndex];
  }

  @override
  Widget build(BuildContext context) {
    final items = _itemsFor(isAdmin);
    final currentNavIndex = _navIndexForBranch(
      currentBranchIndex,
      isAdmin,
    );

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
                    final branchIndex = _branchIndexForNav(
                      index,
                      isAdmin,
                    );
                    onTap(branchIndex);
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
    required this.adminOnly,
  });

  final String label;
  final IconData icon;
  final String route;
  final bool adminOnly;
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
