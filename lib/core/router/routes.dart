abstract final class Routes {
  // —— Onboarding ——
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const language = '/language';

  static const onboardingRoutes = {
    splash,
    onboarding,
    language,
  };

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
  static const ticketPurchase = '/ticket/purchase';
  static String ticketPurchaseStep(String id) => '/ticket/purchase/$id';

  // —— Account (authenticated user dashboard) ——
  static const account = '/account';
  static const accountChangePassword = '/account/change-password';
  static const accountTicket = '/account/ticket';
  static const accountConbook = '/account/conbook';
  static const accountTalent = '/account/talent';
  static const accountPanel = '/account/panel';
  static const accountDealer = '/account/dealer';
  static const accountDealerRegister = '/account/dealer/register';

  /// Profile edit (not listed in web routes; kept for existing flow).
  static const accountEdit = '/account/edit';

  static const unverifiedAccountRoutes = {
    account,
    accountChangePassword,
  };

  // —— Contribute / registration (public) ——
  static const talent = '/talent';
  static const panel = '/panel';
  static const artbook = '/artbook';
  static const dealer = '/dealer';
  static const volunteer = '/volunteer';

  // —— Info ——
  static const about = '/about';
  static const faq = '/faq';
  static const tos = '/tos';
  static const schedule = '/schedule';
  static const recap = '/recap';

  // —— Admin / staff ——
  static const admin = '/admin';
  static const adminDashboard = '/admin/dashboard';
  static const adminDashboardUsers = '/admin/dashboard/users';
  static const adminTickets = '/admin/tickets';
  static const adminScanTicket = '/admin/scan-ticket';
  static const adminHistory = '/admin/history';
  static const adminLostFound = '/admin/lost-found';
  static const adminAccount = '/admin/account';
  static const adminArtSubmit = '/admin/art-submit';
  static const adminPanels = '/admin/panels';
  static const adminTalents = '/admin/talents';
  static const adminDealers = '/admin/dealers';
  static const adminUsers = '/admin/users';
  static String adminUserDetail(String id) => '/admin/users/$id';

  static const publicRoutes = {
    home,
    ticket,
    ticketPurchase,
    talent,
    panel,
    artbook,
    dealer,
    volunteer,
    about,
    faq,
    tos,
    schedule,
    recap,
    ...guestRoutes,
  };

  static bool isOnboardingRoute(String location) =>
      onboardingRoutes.contains(location);

  static bool isGuestRoute(String location) => guestRoutes.contains(location);

  static bool isPublicRoute(String location) {
    if (publicRoutes.contains(location)) return true;
    if (location.startsWith('$ticketPurchase/')) return true;
    return false;
  }

  static bool isAccountRoute(String location) =>
      location == account || location.startsWith('$account/');

  static bool isUnverifiedAccountRoute(String location) =>
      unverifiedAccountRoutes.contains(location);

  static bool isAdminRoute(String location) =>
      location == admin || location.startsWith('$admin/');

  static bool isStaffRoute(String location) => isAdminRoute(location);

  static const staffShellRoutes = {
    admin,
    adminScanTicket,
    adminHistory,
    adminLostFound,
    adminAccount,
  };

  static bool isStaffAccessibleAdminRoute(String location) =>
      staffShellRoutes.contains(location);
}
