import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/features/auth/presentation/pages/login_page.dart';
import 'package:fuvekonmobile/features/event/presentation/pages/events_page.dart';
import 'package:fuvekonmobile/features/notification/presentation/pages/notifications_page.dart';
import 'package:fuvekonmobile/features/profile/presentation/pages/profile_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/tickets_page.dart';
import 'package:fuvekonmobile/shared/widgets/home_shell.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({required AuthSessionNotifier authSessionNotifier})
      : _authSessionNotifier = authSessionNotifier;

  final AuthSessionNotifier _authSessionNotifier;

  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.login,
    refreshListenable: _authSessionNotifier,
    redirect: (context, state) {
      final isAuthenticated = _authSessionNotifier.isAuthenticated;
      final isLoggingIn = state.matchedLocation == Routes.login;

      if (!isAuthenticated && !isLoggingIn) {
        return Routes.login;
      }
      if (isAuthenticated && isLoggingIn) {
        return Routes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const EventsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.tickets,
                builder: (context, state) => const TicketsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.notifications,
                builder: (context, state) => const NotificationsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static GoRouter get instance => GetIt.I<AppRouter>().router;
}
