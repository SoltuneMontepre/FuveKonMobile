abstract final class Routes {
  static const login = '/login';
  static const register = '/register';
  static const googleRegister = '/register/google';
  static const verifyOtp = '/register/verify-otp';
  static const forgotPassword = '/forgot-password';
  static const home = '/';
  static const events = '/events';
  static const tickets = '/tickets';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';

  static const myTicket = '/my-ticket';

  static String ticketPurchase(String tierId) => '/tickets/purchase/$tierId';
}
