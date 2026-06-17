import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/auth/user_permissions.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/notification/presentation/pages/notifications_page.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_event.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_state.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_schedule_models.dart';
import 'package:fuvekonmobile/screens/admin/pages/admin_schedules_page.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_schedule_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_home_app_bar.dart';
import 'package:fuvekonmobile/screens/admin/widgets/event_management_section.dart';
import 'package:fuvekonmobile/shared/widgets/home/fuvekon_home_layout.dart';
import 'package:go_router/go_router.dart';

/// Admin / staff home — admin users see system status and event management.
class OperationsHomePage extends StatelessWidget {
  const OperationsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(const ProfileEvent.started()),
      child: const _OperationsHomeView(),
    );
  }
}

class _OperationsHomeView extends StatelessWidget {
  const _OperationsHomeView();

  static const _fallbackAccount = Account(
    id: '',
    email: 'staff@fuve.vn',
    firstName: 'Staff',
  );

  @override
  Widget build(BuildContext context) {
    final auth = sl<AuthSessionNotifier>();

    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: FuvekonColors.darkBg,
          body: SafeArea(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final account = switch (state) {
                  ProfileLoaded(:final account) => account,
                  _ => _fallbackAccount,
                };

                if (auth.isAdmin ||
                    auth.hasPermission(UserPermissions.approveProfiles)) {
                  return _AdminHomeContent(account: account, auth: auth);
                }

                return _StaffHomeContent(account: account, auth: auth);
              },
            ),
          ),
        );
      },
    );
  }
}

class _AdminHomeContent extends StatefulWidget {
  const _AdminHomeContent({required this.account, required this.auth});

  final Account account;
  final AuthSessionNotifier auth;

  @override
  State<_AdminHomeContent> createState() => _AdminHomeContentState();
}

class _AdminHomeContentState extends State<_AdminHomeContent> {
  final _scheduleService = sl<AdminScheduleService>();

  List<AdminScheduleItem> _schedules = const [];
  bool _schedulesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() => _schedulesLoading = true);
    try {
      final items = await _scheduleService.listSchedules();
      if (!mounted) return;
      setState(() {
        _schedules = items;
        _schedulesLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _schedulesLoading = false);
    }
  }

  Future<void> _openCreateSchedule() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AdminScheduleFormSheet(),
    );
    if (created == true) await _loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account;

    return RefreshIndicator(
      onRefresh: _loadSchedules,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          FuvekonSpacing.page,
          0,
          FuvekonSpacing.page,
          24,
        ),
        children: [
          AdminHomeAppBar(
            avatarUrl: account.avatar,
            initials: account.initials,
            onAvatarTap: () => context.push(Routes.accountProfile),
          ),
          const SizedBox(height: 20),
          EventManagementSection(
            schedules: _schedules,
            loading: _schedulesLoading,
            onCreate: _openCreateSchedule,
          ),
          const SizedBox(height: 28),
          FuvekonQuickActionsSection(items: _quickActions(context)),
        ],
      ),
    );
  }

  List<FuvekonQuickActionItem> _quickActions(BuildContext context) {
    return _buildPermissionQuickActions(context, widget.auth);
  }
}

List<FuvekonQuickActionItem> _buildPermissionQuickActions(
  BuildContext context,
  AuthSessionNotifier auth, {
  String scanLabel = 'Quét vé',
  bool includeScanHistory = false,
  bool includePublicSchedule = false,
}) {
  final actions = <FuvekonQuickActionItem>[];

  void add({
    required String permission,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    if (auth.hasPermission(permission)) {
      actions.add(FuvekonQuickActionItem(label: label, icon: icon, onTap: onTap));
    }
  }

  if (auth.hasPermission(UserPermissions.scanTickets)) {
    actions.add(
      FuvekonQuickActionItem(
        label: scanLabel,
        icon: Icons.qr_code_scanner_outlined,
        onTap: () => context.go(Routes.adminScanTicket),
      ),
    );
    if (includeScanHistory) {
      actions.add(
        FuvekonQuickActionItem(
          label: 'Lịch sử quét',
          icon: Icons.history_rounded,
          onTap: () => context.go(Routes.adminHistory),
        ),
      );
    }
  }

  add(
    permission: UserPermissions.manageTickets,
    label: 'Quản lý vé',
    icon: Icons.confirmation_number_outlined,
    onTap: () => context.push(Routes.adminTickets),
  );
  add(
    permission: UserPermissions.viewDashboard,
    label: 'Thống kê',
    icon: Icons.analytics_outlined,
    onTap: () => context.go(Routes.adminDashboard),
  );
  add(
    permission: UserPermissions.approveProfiles,
    label: 'Duyệt Conbook',
    icon: Icons.menu_book_outlined,
    onTap: () => context.push(Routes.adminArtSubmit),
  );
  add(
    permission: UserPermissions.approveProfiles,
    label: 'Quản lý Panel',
    icon: Icons.groups_outlined,
    onTap: () => context.push(Routes.adminPanels),
  );
  add(
    permission: UserPermissions.approveProfiles,
    label: 'Quản lý Dealer',
    icon: Icons.storefront_outlined,
    onTap: () => context.push(Routes.adminDealers),
  );
  add(
    permission: UserPermissions.approveProfiles,
    label: 'Thất lạc',
    icon: Icons.inventory_2_outlined,
    onTap: () => context.go(Routes.adminLostFound),
  );
  add(
    permission: UserPermissions.approveProfiles,
    label: 'Lịch trình',
    icon: Icons.calendar_month_outlined,
    onTap: () => context.push(Routes.adminSchedules),
  );
  add(
    permission: UserPermissions.manageUsers,
    label: 'Người dùng',
    icon: Icons.people_outline,
    onTap: () => context.push(Routes.adminUsers),
  );

  if (includePublicSchedule &&
      !auth.hasPermission(UserPermissions.approveProfiles)) {
    actions.add(
      FuvekonQuickActionItem(
        label: 'Lịch trình',
        icon: Icons.calendar_month_outlined,
        onTap: () => context.push(Routes.schedule),
      ),
    );
  }

  return actions;
}

class _StaffHomeContent extends StatelessWidget {
  const _StaffHomeContent({required this.account, required this.auth});

  final Account account;
  final AuthSessionNotifier auth;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(
              const ProfileEvent.refreshRequested(),
            );
        await context.read<ProfileBloc>().stream.firstWhere(
              (s) => s is ProfileLoaded || s is ProfileFailure,
            );
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          FuvekonSpacing.page,
          0,
          FuvekonSpacing.page,
          24,
        ),
        children: [
          FuvekonHomeAppBar(
            avatarUrl: account.avatar,
            initials: account.initials,
            onProfileTap: () => context.push(Routes.accountProfile),
          ),
          const SizedBox(height: 8),
          FuvekonHomeGreeting(
            name: account.displayName ?? account.email.split('@').first,
            subtitle: 'Sẵn sàng phục vụ khách tham dự tại sự kiện.',
          ),
          const SizedBox(height: 20),
          const FuvekonHeroBanner(),
          const SizedBox(height: 16),
          if (auth.hasPermission(UserPermissions.scanTickets)) ...[
            FuvekonSageCard(
              title: 'Check-in tại cổng',
              badge: 'Sẵn sàng',
              badgeIcon: Icons.check_rounded,
              badgeColor: FuvekonColors.available,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Quét mã QR vé để check-in khách tham dự.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: FuvekonColors.textSecondary,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => context.go(Routes.adminScanTicket),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        size: 48,
                        color: FuvekonColors.darkCardText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          FuvekonUtilitySection(items: _utilityItems(context)),
          const SizedBox(height: 24),
          FuvekonQuickActionsSection(items: _quickActions(context)),
        ],
      ),
    );
  }

  List<FuvekonUtilityItem> _utilityItems(BuildContext context) {
    final auth = this.auth;
    final items = <FuvekonUtilityItem>[];

    void addIfPermitted({
      required String permission,
      required String label,
      required IconData icon,
      required VoidCallback onTap,
      Color? accentColor,
    }) {
      if (auth.hasPermission(permission)) {
        items.add(
          FuvekonUtilityItem(
            label: label,
            icon: icon,
            onTap: onTap,
            accentColor: accentColor,
          ),
        );
      }
    }

    if (auth.hasPermission(UserPermissions.scanTickets)) {
      items.addAll([
        FuvekonUtilityItem(
          label: 'Quét mã',
          icon: Icons.qr_code_scanner_outlined,
          onTap: () => context.go(Routes.adminScanTicket),
        ),
        FuvekonUtilityItem(
          label: 'Lịch sử',
          icon: Icons.history_rounded,
          onTap: () => context.go(Routes.adminHistory),
        ),
      ]);
    }

    addIfPermitted(
      permission: UserPermissions.manageTickets,
      label: 'Quản lý vé',
      icon: Icons.confirmation_number_outlined,
      onTap: () => context.push(Routes.adminTickets),
    );
    addIfPermitted(
      permission: UserPermissions.viewDashboard,
      label: 'Thống kê',
      icon: Icons.analytics_outlined,
      onTap: () => context.go(Routes.adminDashboard),
    );
    addIfPermitted(
      permission: UserPermissions.manageUsers,
      label: 'Người dùng',
      icon: Icons.people_outline,
      onTap: () => context.push(Routes.adminUsers),
    );
    addIfPermitted(
      permission: UserPermissions.approveProfiles,
      label: 'Thất lạc',
      icon: Icons.inventory_2_outlined,
      onTap: () => context.go(Routes.adminLostFound),
      accentColor: const Color(0xFFFBBF24),
    );

    items.add(
      FuvekonUtilityItem(
        label: 'Thông báo',
        icon: Icons.notifications_outlined,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const NotificationsPage()),
          );
        },
      ),
    );

    return items;
  }

  List<FuvekonQuickActionItem> _quickActions(BuildContext context) {
    return _buildPermissionQuickActions(
      context,
      auth,
      scanLabel: 'Quét vé ngay',
      includeScanHistory: true,
      includePublicSchedule: true,
    );
  }
}
