/// Paths for `https://api.fuve.vn/api/general/v1` (Fuvekon web `axios.general`).
abstract final class ApiConstants {
  // —— Auth ——
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String googleAuth = '/auth/google';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String resetPasswordConfirm = '/auth/reset-password/confirm';

  // —— Users (account) ——
  static const String usersMe = '/users/me';
  static const String usersMeAvatar = '/users/me/avatar';
  static const String usersMePermissions = '/users/me/permissions';

  // —— Tickets (user) ——
  static const String ticketTiers = '/tickets/tiers';
  static String ticketTier(String tierId) => '/tickets/tiers/$tierId';
  static const String ticketMe = '/tickets/me';
  static const String ticketPurchase = '/tickets/purchase';
  static const String ticketMeConfirm = '/tickets/me/confirm';
  static const String ticketMeBadge = '/tickets/me/badge';
  static const String ticketMeTshirtSize = '/tickets/me/tshirt-size';
  static const String ticketMeUpgrade = '/tickets/me/upgrade';
  static const String ticketMeCancel = '/tickets/me/cancel';

  // —— Tickets (admin) ——
  static const String adminTickets = '/admin/tickets';
  static const String adminTicketStatistics = '/admin/tickets/statistics';
  static const String adminTicketSalesTimeline =
      '/admin/tickets/statistics/timeline';
  static const String adminTicketRevenue = '/admin/tickets/statistics/revenue';
  static String adminTicket(String ticketId) => '/admin/tickets/$ticketId';
  static String adminTicketApprove(String ticketId) =>
      '/admin/tickets/$ticketId/approve';
  static String adminTicketDeny(String ticketId) =>
      '/admin/tickets/$ticketId/deny';
  static String adminTicketResendQr(String ticketId) =>
      '/admin/tickets/$ticketId/resend-qr';
  static String adminTicketCheckIn(String ticketIdOrRef) =>
      '/admin/tickets/${Uri.encodeComponent(ticketIdOrRef)}/check-in';
  static const String adminTicketTiers = '/admin/tickets/tiers';
  static String adminTicketTier(String tierId) =>
      '/admin/tickets/tiers/$tierId';
  static String adminTicketTierActivate(String tierId) =>
      '/admin/tickets/tiers/$tierId/activate';
  static String adminTicketTierDeactivate(String tierId) =>
      '/admin/tickets/tiers/$tierId/deactivate';
  static String adminTicketTierVisibility(String tierId, bool visible) =>
      '/admin/tickets/tiers/$tierId/visibility?visible=$visible';

  // —— Users (admin) ——
  static const String adminUsers = '/admin/users';
  static String adminUser(String userId) => '/admin/users/$userId';
  static String adminUserVerify(String userId) =>
      '/admin/users/$userId/verify';
  static const String adminUsersCountByCountry =
      '/admin/users/statistics/count-by-country';
  static const String adminUsersCountByAgeRange =
      '/admin/users/statistics/count-by-age-range';
  static const String adminUsersBlacklisted = '/admin/users/blacklisted';
  static String adminUserBlacklist(String userId) =>
      '/admin/users/$userId/blacklist';
  static String adminUserUnblacklist(String userId) =>
      '/admin/users/$userId/unblacklist';

  // —— Analytics ——
  static const String adminAnalyticsDashboard = '/admin/analytics/dashboard';
  static const String adminHealth = '/admin/health';

  // —— Event controls (admin) ——
  static const String adminEventSettings = '/admin/event/settings';
  static const String adminEventTicketSalesOpen = '/admin/event/ticket-sales/open';
  static const String adminEventTicketSalesClose =
      '/admin/event/ticket-sales/close';
  static const String adminEventPanelRegistrationOpen =
      '/admin/event/panel-registration/open';
  static const String adminEventPanelRegistrationClose =
      '/admin/event/panel-registration/close';
  static const String adminEventTalentRegistrationOpen =
      '/admin/event/talent-registration/open';
  static const String adminEventTalentRegistrationClose =
      '/admin/event/talent-registration/close';
  static const String adminEventDealerRegistrationOpen =
      '/admin/event/dealer-registration/open';
  static const String adminEventDealerRegistrationClose =
      '/admin/event/dealer-registration/close';

  // —— Dealers ——
  static const String dealerRegister = '/dealer/register';
  static const String dealerJoin = '/dealer/join';
  static const String dealerStaffRemove = '/dealer/staff/remove';
  static const String dealerLeave = '/dealer/leave';
  static const String dealerMe = '/dealer/me';
  static String dealer(String id) => '/dealer/$id';

  // —— Dealers (admin) ——
  static const String adminDealers = '/admin/dealers';
  static String adminDealer(String dealerId) => '/admin/dealers/$dealerId';
  static String adminDealerVerify(String dealerId) =>
      '/admin/dealers/$dealerId/verify';
  static String adminDealerDeny(String dealerId) =>
      '/admin/dealers/$dealerId/deny';

  // —— Talents ——
  static const String talents = '/talents';
  static String talent(String id) => '/talents/$id';
  static const String adminTalentsPending = '/admin/talents/pending';
  static const String adminTalentsApproved = '/admin/talents/approved';
  static const String adminTalentsDenied = '/admin/talents/denied';
  static String adminTalentApprove(String id) => '/admin/talents/$id/approve';
  static String adminTalentDeny(String id) => '/admin/talents/$id/deny';
  static String adminTalentPending(String id) => '/admin/talents/$id/pending';
  static String adminTalentSchedule(String id) => '/admin/talents/$id/schedule';

  // —— Panels ——
  static const String panels = '/panels';
  static String panel(String id) => '/panels/$id';
  static const String adminPanelsPending = '/admin/panels/pending';
  static const String adminPanelsApproved = '/admin/panels/approved';
  static const String adminPanelsRequireChanges = '/admin/panels/require-changes';
  static const String adminPanelsDenied = '/admin/panels/denied';
  static String adminPanelApprove(String id) => '/admin/panels/$id/approve';
  static String adminPanelRequireChanges(String id) =>
      '/admin/panels/$id/require-changes';
  static String adminPanelDeny(String id) => '/admin/panels/$id/deny';
  static String adminPanelPending(String id) => '/admin/panels/$id/pending';
  static String adminPanelSchedule(String id) => '/admin/panels/$id/schedule';

  // —— Conbooks ——
  static const String conbooksUpload = '/conbooks/upload';
  static const String conbooks = '/conbooks';
  static String conbook(String id) => '/conbooks/$id';
  static String adminConbooks(String status) => '/admin/conbooks/$status';
  static String adminConbookApprove(String id) => '/admin/conbooks/$id/approve';
  static String adminConbookRequireChanges(String id) =>
      '/admin/conbooks/$id/require-changes';
  static String adminConbookDeny(String id) => '/admin/conbooks/$id/deny';
  static String adminConbookPending(String id) => '/admin/conbooks/$id/pending';

  // —— Schedules ——
  static const String schedules = '/schedules';
  static String schedule(String id) => '/schedules/$id';
  static const String adminSchedules = '/admin/schedules';
  static String adminSchedule(String id) => '/admin/schedules/$id';
  static String adminScheduleTimeline(String scheduleId) =>
      '/admin/schedules/$scheduleId/timeline';
  static String adminScheduleTimelineItem(String scheduleId, String itemId) =>
      '/admin/schedules/$scheduleId/timeline/$itemId';

  // —— Venues (admin, global) ——
  static const String adminVenues = '/admin/venues';
  static String adminVenue(String venueId) => '/admin/venues/$venueId';
  static String adminVenueLocations(String venueId) =>
      '/admin/venues/$venueId/locations';

  // —— Lost & Found (admin) ——
  static const String adminLostFound = '/admin/lost-found';
  static String adminLostFoundItem(String id) => '/admin/lost-found/$id';
  static String adminLostFoundStatus(String id) =>
      '/admin/lost-found/$id/status';
  static String adminLostFoundReturn(String id) =>
      '/admin/lost-found/$id/return';

  // —— Lost & Found (user) ——
  static const String lostFound = '/lost-found';
  static const String lostFoundReport = '/lost-found/report';
  static String lostFoundItem(String id) => '/lost-found/$id';
  static String lostFoundClaim(String id) => '/lost-found/$id/claim';
  static String lostFoundRequest(String id) => '/lost-found/requests/$id';

  // —— Notifications (user) ——
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String notificationsReadAll = '/notifications/read-all';
  static String notification(String id) => '/notifications/$id';

  // —— Notifications (admin) ——
  static const String adminNotifications = '/admin/notifications';
  static const String adminNotificationsBroadcast =
      '/admin/notifications/broadcast';

  // —— Devices (FCM push) ——
  static const String devicesFcmToken = '/devices/fcm-token';
}
