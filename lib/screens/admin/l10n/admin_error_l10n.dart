import 'package:fuvekonmobile/l10n/app_localizations.dart';

/// Maps admin service error messages (legacy Vietnamese or machine keys) to l10n.
String formatAdminError(AppLocalizations l10n, Object error) {
  final raw = error.toString().replaceFirst('ServerException: ', '');
  return _mapMessage(l10n, raw);
}

String formatAdminMessage(AppLocalizations l10n, String message) {
  return _mapMessage(l10n, message);
}

String _mapMessage(AppLocalizations l10n, String message) {
  switch (message) {
    case 'admin.error.loadUsers':
      return l10n.adminErrorLoadUsers;
    case 'admin.error.loadBlacklistedUsers':
      return l10n.adminErrorLoadBlacklistedUsers;
    case 'admin.error.loadDealers':
      return l10n.adminErrorLoadDealers;
    case 'admin.error.loadDealer':
      return l10n.adminErrorLoadDealer;
    case 'admin.error.loadPanels':
      return l10n.adminErrorLoadPanels;
    case 'admin.error.loadConbook':
      return l10n.adminErrorLoadConbook;
    case 'admin.error.loadSchedules':
      return l10n.adminErrorLoadSchedules;
    case 'admin.error.loadSchedule':
      return l10n.adminErrorLoadSchedule;
    case 'admin.error.loadTickets':
      return l10n.adminErrorLoadTickets;
    case 'admin.error.loadTiers':
      return l10n.adminErrorLoadTiers;
    case 'admin.error.loadTicket':
      return l10n.adminErrorLoadTicket;
    case 'admin.error.loadTicketStats':
      return l10n.adminErrorLoadTicketStats;
    case 'admin.error.loadLostFound':
      return l10n.adminErrorLoadLostFound;
    case 'admin.error.updateEventSettings':
      return l10n.adminErrorUpdateEventSettings;
    case 'admin.scan.invalidCode':
      return l10n.adminScanInvalidCode;
    case 'admin.scan.notApproved':
      return l10n.adminScanNotApproved;
    case 'admin.scan.alreadyCheckedIn':
      return l10n.adminScanAlreadyCheckedIn;
    case 'admin.scan.confirmBeforeCheckIn':
      return l10n.adminScanConfirmBeforeCheckIn;
    case 'admin.scan.checkInSuccess':
      return l10n.adminScanCheckInSuccess;
    case 'Không thể tải danh sách người dùng.':
      return l10n.adminErrorLoadUsers;
    case 'Không thể tải danh sách người bị cấm.':
      return l10n.adminErrorLoadBlacklistedUsers;
    case 'Không thể tải danh sách dealer.':
      return l10n.adminErrorLoadDealers;
    case 'Không thể tải thông tin gian hàng.':
      return l10n.adminErrorLoadDealer;
    case 'Không thể tải danh sách panel.':
      return l10n.adminErrorLoadPanels;
    case 'Không thể tải danh sách conbook.':
      return l10n.adminErrorLoadConbook;
    case 'Không thể tải danh sách lịch trình.':
      return l10n.adminErrorLoadSchedules;
    case 'Không thể tải lịch trình.':
      return l10n.adminErrorLoadSchedule;
    case 'Không thể tải danh sách vé.':
      return l10n.adminErrorLoadTickets;
    case 'Không thể tải danh sách hạng vé.':
      return l10n.adminErrorLoadTiers;
    case 'Không thể tải thông tin vé.':
      return l10n.adminErrorLoadTicket;
    case 'Không thể tải thống kê vé.':
      return l10n.adminErrorLoadTicketStats;
    case 'Không thể tải danh sách thất lạc.':
      return l10n.adminErrorLoadLostFound;
    case 'Không cập nhật được cài đặt sự kiện':
      return l10n.adminErrorUpdateEventSettings;
    case 'Mã vé không hợp lệ.':
      return l10n.adminScanInvalidCode;
    case 'Vé chưa được duyệt hoặc đã bị từ chối.':
      return l10n.adminScanNotApproved;
    case 'Vé đã được check-in trước đó.':
      return l10n.adminScanAlreadyCheckedIn;
    case 'Xác nhận thông tin vé trước khi check-in.':
      return l10n.adminScanConfirmBeforeCheckIn;
    case 'Check-in thành công.':
      return l10n.adminScanCheckInSuccess;
    default:
      if (message.startsWith('Lỗi: ')) {
        return l10n.adminErrorWithDetail(message.substring(5));
      }
      if (message.startsWith('Error: ')) {
        return l10n.adminErrorWithDetail(message.substring(7));
      }
      return message;
  }
}
