import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/widgets/staff_dashboard_colors.dart';

class StaffCheckInCard extends StatelessWidget {
  const StaffCheckInCard({
    super.key,
    required this.onScanPressed,
    this.isReady = true,
  });

  final VoidCallback onScanPressed;
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: StaffDashboardColors.checkInCardBg,
        borderRadius: BorderRadius.circular(FuvekonRadii.card),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isReady ? Icons.check_rounded : Icons.sync_rounded,
                color: StaffDashboardColors.checkInButton,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isReady ? l10n.adminQrReadyCheckIn : l10n.adminQrConnecting,
              style: theme.textTheme.titleLarge?.copyWith(
                color: FuvekonColors.darkCardText,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isReady
                  ? l10n.adminStaffReadyConnected
                  : l10n.adminStaffConnectingHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: FuvekonColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isReady ? onScanPressed : null,
                style: FilledButton.styleFrom(
                  backgroundColor: StaffDashboardColors.checkInButton,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(
                  l10n.adminQrScanNow,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
