import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/features/auth/presentation/pages/login_page.dart';
import 'package:fuvekonmobile/features/event/presentation/pages/events_page.dart';
import 'package:fuvekonmobile/features/notification/presentation/pages/notifications_page.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:fuvekonmobile/features/profile/presentation/pages/profile_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/my_ticket_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/ticket_purchase_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/tickets_page.dart';
import 'package:fuvekonmobile/shared/widgets/home_shell.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({required AuthSessionNotifier authSessionNotifier})
      : _authSessionNotifier = authSessionNotifier;

  final AuthSessionNotifier _authSessionNotifier;

  final rootNavigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
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
                routes: [
                  GoRoute(
                    path: 'purchase/:tierId',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final tierId = state.pathParameters['tierId']!;
                      final queued = state.extra == true;
                      return TicketPurchasePage(
                        tierId: tierId,
                        queued: queued,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.myTicket,
                builder: (context, state) => const MyTicketPage(),
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
                routes: [
                  GoRoute(
                    path: 'edit',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final account = state.extra as Account;
                      return EditProfilePage(account: account);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static GoRouter get instance => GetIt.I<AppRouter>().router;
}
