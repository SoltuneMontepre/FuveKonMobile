abstract final class Routes {
  // —— Onboarding ——
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const language = '/language';
  static const introduction = '/introduction';

  static const onboardingRoutes = {splash, onboarding, language, introduction};

  // —— Public ——
  static const home = '/';

  // —— Auth (guest) ——
  static const login = '/login';
  static const register = '/register';
  static const googleRegister = '/register/google';
  static const verifyOtp = '/register/verify-otp';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  static const guestRoutes = {
    login,
    register,
    googleRegister,
    verifyOtp,
    forgotPassword,
    resetPassword,
  };

  // —— Tickets ——
  static const ticket = '/ticket';
  static String ticketDetail(String id) => '/ticket/$id';
  static const ticketPurchase = '/ticket/purchase';
  static String ticketPurchaseStep(String id) => '/ticket/purchase/$id';

  // —— Account (authenticated user dashboard) ——
  static const account = '/account';
  static const accountSchedule = '/account/schedule';
  static String accountScheduleActivity(String id) =>
      '/account/schedule/activity/$id';
  static String accountScheduleEvent(String id) =>
      '/account/schedule/event/$id';
  static const accountScheduleMap = '/account/schedule/map';
  static String accountScheduleVenue(String id) =>
      '/account/schedule/venue/$id';
  static const accountScheduleMy = '/account/schedule/my';
  static const accountTicket = '/account/ticket';
  static String accountTicketDetail(String id) => '/account/ticket/$id';
  static const accountTicketUpgrade = '/account/ticket/upgrade';
  static const accountNotifications = '/account/notifications';
  static String accountNotificationDetail(String id) =>
      '/account/notifications/$id';
  static const accountProfile = '/account/profile';
  static const accountChangePassword = '/account/profile/change-password';
  static const accountSettings = '/account/profile/settings';
  static const accountVerifyIdentity = '/account/profile/verify-identity';
  static const accountSubmissions = '/account/profile/submissions';
  static const accountConbook = '/account/profile/conbook';
  static String accountConbookDetail(String id) =>
      '/account/profile/conbook/$id';
  static const accountTalent = '/account/profile/talent';
  static String accountTalentDetail(String id) => '/account/profile/talent/$id';
  static const accountPanel = '/account/profile/panel';
  static String accountPanelDetail(String id) => '/account/profile/panel/$id';
  static const accountDealer = '/account/profile/dealer';
  static const accountDealerRegister = '/account/profile/dealer/register';
  static const accountDealerStaff = '/account/profile/dealer/staff';
  static const accountEdit = '/account/profile/edit';

  static const unverifiedAccountRoutes = {
    accountProfile,
    accountChangePassword,
    accountSettings,
  };

  // —— Contribute / registration (public) ——
  static const talent = '/talent';
  static const panel = '/panel';
  static const artbook = '/artbook';
  static const artbookSubmit = '/artbook/submit';
  static const dealer = '/dealer';
  static const volunteer = '/volunteer';

  // —— Info ——
  static const about = '/about';
  static const faq = '/faq';
  static const tos = '/tos';
  static String get tosOnboarding => '$tos?onboarding=1';
  static const schedule = '/schedule';
  static String scheduleActivity(String id) => '/schedule/activity/$id';
  static String scheduleEvent(String id) => '/schedule/event/$id';
  static const scheduleMap = '/schedule/map';
  static String scheduleVenue(String id) => '/schedule/venue/$id';
  static const scheduleMy = '/schedule/my';
  static const lostFound = '/lost-found';
  static const lostFoundReport = '/lost-found/report';
  static String lostFoundDetail(String id) => '/lost-found/$id';
  static String lostFoundRequest(String id) => '/lost-found/requests/$id';
  static const recap = '/recap';

  // —— Admin / staff ——
  static const admin = '/admin';
  static const adminDashboard = '/admin/dashboard';
  static const adminDashboardUsers = '/admin/dashboard/users';
  static const adminTickets = '/admin/tickets';
  static const adminScanTicket = '/admin/scan-ticket';
  static const adminHistory = '/admin/history';
  static const adminLostFound = '/admin/lost-found';
  static String adminLostFoundDetail(String id) => '/admin/lost-found/$id';
  static String adminLostFoundReturn(String id) =>
      '/admin/lost-found/$id/return';
  static const adminSystem = '/admin/system';
  static const adminAccount = '/admin/account';
  static const adminArtSubmit = '/admin/art-submit';
  static const adminPanels = '/admin/panels';
  static const adminTalents = '/admin/talents';
  static const adminDealers = '/admin/dealers';
  static String adminDealerDetail(String id) => '/admin/dealers/$id';
  static const adminSchedules = '/admin/schedules';
  static String adminScheduleDetail(String id) => '/admin/schedules/$id';
  static const adminUsers = '/admin/users';
  static String adminUserDetail(String id) => '/admin/users/$id';
  static String adminUserEdit(String id, {String? section}) {
    final path = '/admin/users/$id/edit';
    if (section == null || section.isEmpty) return path;
    return '$path?section=$section';
  }

  static const adminNotifications = '/admin/notifications';
  static const adminNotificationCreate = '/admin/notifications/create';
  static const adminNotificationBroadcast = '/admin/notifications/broadcast';
  static String adminNotificationCreateForUser({String? userId}) {
    if (userId == null || userId.isEmpty) return adminNotificationCreate;
    return '$adminNotificationCreate?user_id=${Uri.encodeComponent(userId)}';
  }

  static const publicRoutes = {
    home,
    ticket,
    ticketPurchase,
    talent,
    panel,
    artbook,
    artbookSubmit,
    dealer,
    volunteer,
    about,
    faq,
    tos,
    schedule,
    lostFound,
    recap,
    ...guestRoutes,
  };

  static bool isOnboardingRoute(String location) =>
      onboardingRoutes.contains(location);

  static bool isGuestRoute(String location) => guestRoutes.contains(location);

  static bool isPublicRoute(String location) {
    if (publicRoutes.contains(location)) return true;
    if (location.startsWith('$schedule/')) return true;
    if (location == ticketPurchase || location.startsWith('$ticketPurchase/')) {
      return true;
    }
    if (location.startsWith('$ticket/') &&
        !location.startsWith(ticketPurchase)) {
      return true;
    }
    if (location.startsWith('$artbook/')) return true;
    if (location == lostFoundReport) return true;
    if (location.startsWith('$lostFound/')) return true;
    return false;
  }

  static bool isAccountRoute(String location) =>
      location == account || location.startsWith('$account/');

  static bool isUnverifiedAccountRoute(String location) =>
      unverifiedAccountRoutes.contains(location);

  static bool isAdminRoute(String location) =>
      location == admin || location.startsWith('$admin/');

  static bool isStaffRoute(String location) => isAdminRoute(location);
}
