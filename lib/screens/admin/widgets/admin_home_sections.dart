import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/auth/user_permissions.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/notification/presentation/pages/notifications_page.dart';
import 'package:fuvekonmobile/shared/widgets/home/fuvekon_home_layout.dart';
import 'package:go_router/go_router.dart';

/// Permission-gated home sections for admin and staff operations home.
class AdminHomeSections extends StatelessWidget {
  const AdminHomeSections({
    super.key,
    required this.auth,
    required this.variant,
    this.includePublicSchedule = false,
  });

  final AuthSessionNotifier auth;
  final AdminHomeVariant variant;
  final bool includePublicSchedule;

  @override
  Widget build(BuildContext context) {
    final sections = switch (variant) {
      AdminHomeVariant.admin => _adminSections(context),
      AdminHomeVariant.staff => _staffSections(context),
    };

    if (sections.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          if (i > 0) const SizedBox(height: 28),
          sections[i],
        ],
      ],
    );
  }

  List<Widget> _adminSections(BuildContext context) {
    return [
      _section(
        context,
        title: 'Vận hành tại chỗ',
        subtitle: 'Check-in, lịch sử quét và đồ thất lạc.',
        icon: Icons.qr_code_scanner_outlined,
        items: [
          if (auth.hasPermission(UserPermissions.scanTickets))
            _item(
              context,
              label: 'Quét vé',
              icon: Icons.qr_code_scanner_outlined,
              onTap: () => context.go(Routes.adminScanTicket),
            ),
          if (auth.hasPermission(UserPermissions.scanTickets))
            _item(
              context,
              label: 'Lịch sử quét',
              icon: Icons.history_rounded,
              onTap: () => context.go(Routes.adminHistory),
            ),
          if (auth.hasPermission(UserPermissions.approveProfiles))
            _item(
              context,
              label: 'Thất lạc',
              icon: Icons.inventory_2_outlined,
              onTap: () => context.go(Routes.adminLostFound),
            ),
        ],
      ),
      _section(
        context,
        title: 'Quản lý sự kiện',
        subtitle: 'Vé, cấu hình và vận hành sự kiện.',
        icon: Icons.event_outlined,
        items: [
          if (auth.hasPermission(UserPermissions.manageTickets))
            _item(
              context,
              label: 'Quản lý vé',
              icon: Icons.confirmation_number_outlined,
              onTap: () => context.push(Routes.adminTickets),
            ),
        ],
      ),
      _section(
        context,
        title: 'Duyệt nội dung',
        subtitle: 'Conbook, panel và gian hàng dealer.',
        icon: Icons.fact_check_outlined,
        permission: UserPermissions.approveProfiles,
        items: [
          _item(
            context,
            label: 'Duyệt Conbook',
            icon: Icons.menu_book_outlined,
            onTap: () => context.push(Routes.adminArtSubmit),
          ),
          _item(
            context,
            label: 'Quản lý Panel',
            icon: Icons.groups_outlined,
            onTap: () => context.push(Routes.adminPanels),
          ),
          _item(
            context,
            label: 'Quản lý Dealer',
            icon: Icons.storefront_outlined,
            onTap: () => context.push(Routes.adminDealers),
          ),
        ],
      ),
      _section(
        context,
        title: 'Người dùng & báo cáo',
        subtitle: 'Tài khoản và số liệu bán vé.',
        icon: Icons.insights_outlined,
        items: [
          if (auth.hasPermission(UserPermissions.manageUsers))
            _item(
              context,
              label: 'Người dùng',
              icon: Icons.people_outline,
              onTap: () => context.push(Routes.adminUsers),
            ),
          if (auth.hasPermission(UserPermissions.viewDashboard))
            _item(
              context,
              label: 'Thống kê',
              icon: Icons.analytics_outlined,
              onTap: () => context.go(Routes.adminDashboard),
            ),
        ],
      ),
    ].whereType<Widget>().toList();
  }

  List<Widget> _staffSections(BuildContext context) {
    return [
      _section(
        context,
        title: 'Vận hành tại chỗ',
        subtitle: 'Công cụ phục vụ khách tại sự kiện.',
        icon: Icons.qr_code_scanner_outlined,
        items: [
          if (auth.hasPermission(UserPermissions.scanTickets))
            _item(
              context,
              label: 'Lịch sử quét',
              icon: Icons.history_rounded,
              onTap: () => context.go(Routes.adminHistory),
            ),
          if (auth.hasPermission(UserPermissions.approveProfiles))
            _item(
              context,
              label: 'Thất lạc',
              icon: Icons.inventory_2_outlined,
              onTap: () => context.go(Routes.adminLostFound),
            ),
        ],
      ),
      _section(
        context,
        title: 'Quản lý',
        subtitle: 'Vé, người dùng và thống kê.',
        icon: Icons.tune_outlined,
        items: [
          if (auth.hasPermission(UserPermissions.manageTickets))
            _item(
              context,
              label: 'Quản lý vé',
              icon: Icons.confirmation_number_outlined,
              onTap: () => context.push(Routes.adminTickets),
            ),
          if (auth.hasPermission(UserPermissions.viewDashboard))
            _item(
              context,
              label: 'Thống kê',
              icon: Icons.analytics_outlined,
              onTap: () => context.go(Routes.adminDashboard),
            ),
          if (auth.hasPermission(UserPermissions.manageUsers))
            _item(
              context,
              label: 'Người dùng',
              icon: Icons.people_outline,
              onTap: () => context.push(Routes.adminUsers),
            ),
        ],
      ),
      _section(
        context,
        title: 'Khác',
        subtitle: 'Thông báo và lịch trình công khai.',
        icon: Icons.more_horiz_rounded,
        items: [
          _item(
            context,
            label: 'Thông báo',
            icon: Icons.notifications_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NotificationsPage(),
                ),
              );
            },
          ),
          if (includePublicSchedule &&
              !auth.hasPermission(UserPermissions.approveProfiles))
            _item(
              context,
              label: 'Lịch trình',
              icon: Icons.calendar_month_outlined,
              onTap: () => context.push(Routes.schedule),
            ),
        ],
      ),
    ].whereType<Widget>().toList();
  }

  Widget? _section(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<FuvekonQuickActionItem> items,
    String? permission,
  }) {
    if (permission != null && !auth.hasPermission(permission)) {
      return null;
    }
    if (items.isEmpty) return null;

    return AdminHomeActionSection(
      title: title,
      subtitle: subtitle,
      icon: icon,
      items: items,
    );
  }

  FuvekonQuickActionItem _item(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return FuvekonQuickActionItem(label: label, icon: icon, onTap: onTap);
  }
}

enum AdminHomeVariant { admin, staff }

class AdminHomeActionSection extends StatelessWidget {
  const AdminHomeActionSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.items,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<FuvekonQuickActionItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: FuvekonColors.darkPrimary, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: FuvekonColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: items.map((item) => _ActionTile(item: item)).toList(),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.item});

  final FuvekonQuickActionItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FuvekonColors.darkSurfaceElevated,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: FuvekonColors.darkText, size: 28),
              const SizedBox(height: 10),
              Text(
                item.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
