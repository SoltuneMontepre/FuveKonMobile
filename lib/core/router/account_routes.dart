import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:fuvekonmobile/features/profile/presentation/pages/profile_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/my_ticket_page.dart';
import 'package:fuvekonmobile/screens/account/account_pages.dart';
import 'package:fuvekonmobile/screens/account/account_shell.dart';
import 'package:fuvekonmobile/screens/account/pages/authenticated_home_page.dart';
import 'package:fuvekonmobile/screens/account/pages/notifications_page.dart';
import 'package:fuvekonmobile/screens/info/info_pages.dart';
import 'package:go_router/go_router.dart';

abstract final class AccountRoutes {
  static StatefulShellRoute shell({
    required GlobalKey<NavigatorState> rootNavigatorKey,
  }) {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AccountShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.account,
              builder: (context, state) => const AuthenticatedHomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.accountSchedule,
              builder: (context, state) => const SchedulePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.accountTicket,
              builder: (context, state) => const MyTicketPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.accountNotifications,
              builder: (context, state) => const NotificationsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.accountProfile,
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: 'change-password',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const ChangePasswordPage(),
                ),
                GoRoute(
                  path: 'conbook',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AccountConbookPage(),
                ),
                GoRoute(
                  path: 'talent',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AccountTalentPage(),
                ),
                GoRoute(
                  path: 'panel',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AccountPanelPage(),
                ),
                GoRoute(
                  path: 'dealer',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AccountDealerPage(),
                  routes: [
                    GoRoute(
                      path: 'register',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) =>
                          const AccountDealerRegisterPage(),
                    ),
                  ],
                ),
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
    );
  }
}
