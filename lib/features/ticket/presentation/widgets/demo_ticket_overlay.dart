import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/app_router.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/ticket/data/mock/mock_ticket_data.dart';
import 'package:fuvekonmobile/features/ticket/data/mock/mock_ticket_store.dart';

/// Floating demo controls when [AppConfig.mockTicketMode] is on.
class DemoTicketOverlay extends StatelessWidget {
  const DemoTicketOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.mockTicketMode) return child;

    return Stack(
      children: [
        child,
        const Positioned(
          right: 12,
          bottom: 88,
          child: _DemoTicketFab(),
        ),
      ],
    );
  }
}

class _DemoTicketFab extends StatelessWidget {
  const _DemoTicketFab();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FuvekonColors.lightGold,
      elevation: 6,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: () => _openPanel(context),
        borderRadius: BorderRadius.circular(999),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.science_outlined, size: 18, color: Colors.black87),
              SizedBox(width: 6),
              Text(
                'DEMO vé',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPanel(BuildContext context) {
    final rootContext = sl<AppRouter>().rootNavigatorKey.currentContext;
    if (rootContext == null) return;

    showModalBottomSheet<void>(
      context: rootContext,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _DemoTicketPanel(),
    );
  }
}

class _DemoTicketPanel extends StatefulWidget {
  const _DemoTicketPanel();

  @override
  State<_DemoTicketPanel> createState() => _DemoTicketPanelState();
}

class _DemoTicketPanelState extends State<_DemoTicketPanel> {
  late final MockTicketStore _store;

  @override
  void initState() {
    super.initState();
    _store = sl<MockTicketStore>();
    _store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  void _act(VoidCallback action, String message) {
    action();
    final rootContext = sl<AppRouter>().rootNavigatorKey.currentContext;
    if (rootContext == null) return;
    Navigator.of(rootContext).pop();
    ScaffoldMessenger.of(rootContext).showSnackBar(
      SnackBar(content: Text('$message — mở lại tab Vé để refresh.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticket = _store.ticket;
    final tierName = ticket?.tier?.ticketName ?? '—';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FuvekonColors.darkBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Mock ticket (không gọi API)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: FuvekonColors.darkText,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Trạng thái: ${_store.statusLabel}'
              '${ticket != null ? ' · $tierName · ${ticket.referenceCode}' : ''}',
              style: TextStyle(
                color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.95),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Luồng app: Mua vé → Thanh toán → 「Tôi đã thanh toán」→ Dùng 「BTC duyệt」ở đây.',
              style: TextStyle(
                color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.8),
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            _DemoAction(
              label: 'Xóa vé (bắt đầu lại)',
              icon: Icons.restart_alt,
              onTap: () => _act(_store.reset, 'Đã xóa vé mock'),
            ),
            _DemoAction(
              label: 'Cấp vé Standard · đã duyệt',
              icon: Icons.confirmation_number_outlined,
              onTap: () => _act(
                () => _store.grantApproved(tierId: MockTicketIds.standard),
                'Đã cấp Standard (approved)',
              ),
            ),
            _DemoAction(
              label: 'Cấp vé VIP · đã duyệt',
              icon: Icons.star_outline,
              onTap: () => _act(
                () => _store.grantApproved(tierId: MockTicketIds.vip),
                'Đã cấp VIP (approved)',
              ),
            ),
            _DemoAction(
              label: 'BTC duyệt (sau khi xác nhận TT)',
              icon: Icons.verified_outlined,
              onTap: () => _act(
                _store.simulateAdminApprove,
                'Đã duyệt vé mock',
              ),
            ),
            _DemoAction(
              label: 'Nâng hạng → VIP (vé pending, chờ TT)',
              icon: Icons.trending_up,
              onTap: () => _act(
                () => _store.simulateUpgrade(newTierId: MockTicketIds.vip),
                'Đã nâng hạng mock lên VIP',
              ),
            ),
            _DemoAction(
              label: 'Từ chối vé',
              icon: Icons.block_outlined,
              color: const Color(0xFFF0A0A8),
              onTap: () => _act(_store.deny, 'Vé mock bị từ chối'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoAction extends StatelessWidget {
  const _DemoAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: color ?? FuvekonColors.darkPrimary),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(color: color ?? FuvekonColors.darkText),
          ),
        ),
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          side: BorderSide(color: FuvekonColors.darkBorder.withValues(alpha: 0.6)),
        ),
      ),
    );
  }
}
