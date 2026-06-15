import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/screens/admin/services/scan_ticket_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/ticket_qr_scanner_page.dart';

/// Quét mã tab — camera scanner only.
class AdminScanTicketPage extends StatelessWidget {
  const AdminScanTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scanService = sl<ScanTicketService>();

    return TicketQrScannerPage(
      embeddedInTab: true,
      onLookup: scanService.lookupCode,
      onCheckIn: scanService.checkInCode,
    );
  }
}
