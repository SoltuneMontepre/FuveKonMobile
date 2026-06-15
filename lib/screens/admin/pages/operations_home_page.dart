import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/notification/presentation/pages/notifications_page.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_event.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_state.dart';
import 'package:fuvekonmobile/shared/widgets/home/fuvekon_home_layout.dart';
import 'package:go_router/go_router.dart';

/// Admin / staff home — same layout as the attendee home screen.
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
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final account = switch (state) {
              ProfileLoaded(:final account) => account,
              _ => _fallbackAccount,
            };

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
                  const FuvekonHomeAppBar(),
                  const SizedBox(height: 8),
                  FuvekonHomeGreeting(
                    name: account.displayName ?? account.email.split('@').first,
                    subtitle: _isAdmin(account)
                        ? 'Quản lý sự kiện và vận hành tại chỗ.'
                        : 'Sẵn sàng phục vụ khách tham dự tại sự kiện.',
                  ),
                  const SizedBox(height: 20),
                  const FuvekonHeroBanner(),
                  const SizedBox(height: 16),
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
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: FuvekonColors.textSecondary),
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
                  FuvekonUtilitySection(items: _utilityItems(context)),
                  const SizedBox(height: 24),
                  FuvekonQuickActionsSection(
                    items: _quickActions(context, account),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isAdmin(Account account) => account.role?.toLowerCase() == 'admin';

  List<FuvekonUtilityItem> _utilityItems(BuildContext context) => [
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
    FuvekonUtilityItem(
      label: 'Thất lạc',
      icon: Icons.inventory_2_outlined,
      onTap: () => context.go(Routes.adminLostFound),
      accentColor: const Color(0xFFFBBF24),
    ),
    FuvekonUtilityItem(
      label: 'Thông báo',
      icon: Icons.notifications_outlined,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const NotificationsPage()),
        );
      },
    ),
  ];

  List<FuvekonQuickActionItem> _quickActions(
    BuildContext context,
    Account account,
  ) {
    if (_isAdmin(account)) {
      return [
        FuvekonQuickActionItem(
          label: 'Quét vé',
          icon: Icons.qr_code_scanner_outlined,
          onTap: () => context.go(Routes.adminScanTicket),
        ),
        FuvekonQuickActionItem(
          label: 'Quản lý vé',
          icon: Icons.confirmation_number_outlined,
          onTap: () => context.push(Routes.adminTickets),
        ),
        FuvekonQuickActionItem(
          label: 'Thống kê',
          icon: Icons.analytics_outlined,
          onTap: () => context.go(Routes.adminDashboard),
        ),
        FuvekonQuickActionItem(
          label: 'Duyệt Conbook',
          icon: Icons.menu_book_outlined,
          onTap: () => context.push(Routes.adminArtSubmit),
        ),
        FuvekonQuickActionItem(
          label: 'Quản lý Panel',
          icon: Icons.groups_outlined,
          onTap: () => context.push(Routes.adminPanels),
        ),
        FuvekonQuickActionItem(
          label: 'Quản lý Dealer',
          icon: Icons.storefront_outlined,
          onTap: () => context.push(Routes.adminDealers),
        ),
        FuvekonQuickActionItem(
          label: 'Người dùng',
          icon: Icons.people_outline,
          onTap: () => context.push(Routes.adminUsers),
        ),
      ];
    }

    return [
      FuvekonQuickActionItem(
        label: 'Quét vé ngay',
        icon: Icons.qr_code_scanner_outlined,
        onTap: () => context.go(Routes.adminScanTicket),
      ),
      FuvekonQuickActionItem(
        label: 'Lịch sử quét',
        icon: Icons.history_rounded,
        onTap: () => context.go(Routes.adminHistory),
      ),
      FuvekonQuickActionItem(
        label: 'Thất lạc',
        icon: Icons.inventory_2_outlined,
        onTap: () => context.go(Routes.adminLostFound),
      ),
      FuvekonQuickActionItem(
        label: 'Lịch trình',
        icon: Icons.calendar_month_outlined,
        onTap: () => context.push(Routes.schedule),
      ),
    ];
  }
}

class _ScheduleItem {
  const _ScheduleItem({
    required this.time,
    required this.endTime,
    required this.title,
    required this.location,
  });

  final String time;
  final String endTime;
  final String title;
  final String location;
}

class _ScheduleTimeline extends StatelessWidget {
  const _ScheduleTimeline({required this.items});

  final List<_ScheduleItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 48,
                child: Text(
                  item.time,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: FuvekonColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: FuvekonColors.available,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: FuvekonColors.inputBorder,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: FuvekonColors.darkCardText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.location,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: FuvekonColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${item.time} – ${item.endTime}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: FuvekonColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
