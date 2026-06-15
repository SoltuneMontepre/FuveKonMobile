import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/services/scan_ticket_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/staff_tab_scaffold.dart';
import 'package:fuvekonmobile/shared/services/scan_session_store.dart';
import 'package:fuvekonmobile/shared/widgets/empty_state.dart';
import 'package:intl/intl.dart';

class AdminScanHistoryPage extends StatefulWidget {
  const AdminScanHistoryPage({super.key});

  @override
  State<AdminScanHistoryPage> createState() => _AdminScanHistoryPageState();
}

class _AdminScanHistoryPageState extends State<AdminScanHistoryPage> {
  final _scanService = sl<ScanTicketService>();
  List<ScanRecord> _records = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = await _scanService.getHistory();
    if (!mounted) return;
    setState(() {
      _records = records;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StaffTabScaffold(
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? const EmptyState(
                  title: 'Lịch sử quét vé',
                  subtitle: 'Chưa có lượt quét nào được ghi nhận.',
                  icon: Icons.history_rounded,
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(FuvekonSpacing.page),
                    itemCount: _records.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final record = _records[index];
                      return _HistoryTile(record: record);
                    },
                  ),
                ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.record});

  final ScanRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = DateFormat('HH:mm dd/MM').format(record.scannedAt);
    final color = switch (record.outcome) {
      ScanOutcome.valid => FuvekonColors.available,
      ScanOutcome.reused => const Color(0xFFFBBF24),
      ScanOutcome.rejected => const Color(0xFFF0A0A8),
    };
    final label = switch (record.outcome) {
      ScanOutcome.valid => 'Hợp lệ',
      ScanOutcome.reused => 'Dùng lại',
      ScanOutcome.rejected => 'Từ chối',
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(
            switch (record.outcome) {
              ScanOutcome.valid => Icons.check_rounded,
              ScanOutcome.reused => Icons.history_rounded,
              ScanOutcome.rejected => Icons.close_rounded,
            },
            color: color,
          ),
        ),
        title: Text(
          record.code,
          style: theme.textTheme.titleSmall?.copyWith(
            color: FuvekonColors.darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          [
            if (record.holderName != null) record.holderName!,
            record.message ?? label,
            time,
          ].join(' • '),
          style: theme.textTheme.bodySmall?.copyWith(
            color: FuvekonColors.darkTextSecondary,
          ),
        ),
        trailing: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
