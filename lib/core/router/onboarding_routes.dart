import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/screens/onboarding/onboarding_pages.dart';
import 'package:go_router/go_router.dart';

abstract final class OnboardingRoutes {
  static List<RouteBase> routes() => [
        GoRoute(
          path: Routes.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: Routes.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: Routes.language,
          builder: (context, state) => const LanguageSelectionPage(),
        ),
        GoRoute(
          path: Routes.introduction,
          builder: (context, state) => const IntroductionPage(),
        ),
      ];
}
