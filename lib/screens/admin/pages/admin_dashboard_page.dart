import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_dashboard_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/sales_timeline_chart.dart';
import 'package:fuvekonmobile/screens/admin/widgets/staff_tab_scaffold.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:intl/intl.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _service = sl<AdminDashboardService>();
  AdminDashboardData? _data;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _service.getDashboard();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StaffTabScaffold(
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(FuvekonSpacing.page),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const EmptyState(
                          title: 'Không tải được thống kê',
                          subtitle: 'Vui lòng thử lại sau.',
                          icon: Icons.error_outline,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _load,
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(FuvekonSpacing.page),
                    children: [
                      _SectionHeader(
                        title: 'Tổng quan sự kiện',
                        subtitle: 'Dữ liệu 90 ngày gần nhất',
                      ),
                      const SizedBox(height: 16),
                      _OverviewGrid(data: _data!),
                      const SizedBox(height: 24),
                      _SectionHeader(title: 'Vé'),
                      const SizedBox(height: 12),
                      _TicketStatsSection(data: _data!),
                      if (_data!.tierStats.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _SectionHeader(title: 'Theo hạng vé'),
                        const SizedBox(height: 12),
                        ..._data!.tierStats.map(
                          (tier) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _TierTile(tier: tier),
                          ),
                        ),
                      ],
                      if (_data!.salesTimeline.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        SalesTimelineChart(points: _data!.salesTimeline),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: FuvekonColors.darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: FuvekonColors.darkTextSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid({required this.data});

  final AdminDashboardData data;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final count = NumberFormat.decimalPattern('vi');

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Doanh thu',
                value: currency.format(data.totalRevenue),
                icon: Icons.payments_outlined,
                valueColor: FuvekonColors.available,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                label: 'Người dùng',
                value: count.format(data.userCount),
                icon: Icons.people_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Dealer',
                value: count.format(data.dealerCount),
                icon: Icons.storefront_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                label: 'Tổng vé',
                value: count.format(data.totalTickets),
                icon: Icons.confirmation_number_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TicketStatsSection extends StatelessWidget {
  const _TicketStatsSection({required this.data});

  final AdminDashboardData data;

  @override
  Widget build(BuildContext context) {
    final count = NumberFormat.decimalPattern('vi');

    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            label: 'Đã duyệt',
            value: count.format(data.approvedCount),
            icon: Icons.check_circle_outline,
            valueColor: FuvekonColors.available,
            compact: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            label: 'Chờ duyệt',
            value: count.format(data.pendingCount),
            icon: Icons.hourglass_empty_rounded,
            valueColor: const Color(0xFFFBBF24),
            compact: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            label: 'Từ chối',
            value: count.format(data.deniedCount),
            icon: Icons.cancel_outlined,
            valueColor: const Color(0xFFF0A0A8),
            compact: true,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
    this.compact = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 14 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: FuvekonColors.darkTextSecondary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 8 : 12),
            Text(
              value,
              style: (compact
                      ? theme.textTheme.titleLarge
                      : theme.textTheme.headlineSmall)
                  ?.copyWith(
                color: valueColor ?? FuvekonColors.darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TierTile extends StatelessWidget {
  const _TierTile({required this.tier});

  final TierStat tier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = NumberFormat.decimalPattern('vi');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text(
          tier.tierName,
          style: theme.textTheme.titleSmall?.copyWith(
            color: FuvekonColors.darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Đã bán ${count.format(tier.sold)} / ${count.format(tier.totalStock)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: FuvekonColors.darkTextSecondary,
          ),
        ),
        trailing: Text(
          'Còn ${count.format(tier.available)}',
          style: theme.textTheme.labelMedium?.copyWith(
            color: FuvekonColors.available,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
