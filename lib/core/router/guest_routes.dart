import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:fuvekonmobile/features/auth/presentation/pages/google_register_page.dart';
import 'package:fuvekonmobile/features/auth/presentation/pages/login_page.dart';
import 'package:fuvekonmobile/features/auth/presentation/pages/register_page.dart';
import 'package:fuvekonmobile/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:fuvekonmobile/features/auth/presentation/pages/reset_password_page.dart';
import 'package:go_router/go_router.dart';

abstract final class GuestRoutes {
  static List<RouteBase> routes() => [
    GoRoute(path: Routes.login, builder: (context, state) => const LoginPage()),
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const RegisterPage(),
      routes: [
        GoRoute(
          path: 'google',
          builder: (context, state) {
            final credential = state.extra as String? ?? '';
            if (credential.isEmpty) {
              return const RegisterPage();
            }
            return GoogleRegisterPage(credential: credential);
          },
        ),
        GoRoute(
          path: 'verify-otp',
          builder: (context, state) {
            final email = state.extra as String? ?? '';
            if (email.isEmpty) {
              return const RegisterPage();
            }
            return VerifyOtpPage(email: email);
          },
        ),
      ],
    ),
    GoRoute(
      path: Routes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: Routes.resetPassword,
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        return ResetPasswordPage(token: token);
      },
    ),
  ];
}
