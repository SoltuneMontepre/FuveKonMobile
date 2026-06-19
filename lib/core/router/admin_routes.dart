import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/screens/admin/admin_shell.dart';
import 'package:fuvekonmobile/screens/admin/pages/admin_pages.dart';
import 'package:fuvekonmobile/screens/admin/pages/operations_home_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AdminRoutes {
  static StatefulShellRoute shell({
    required GlobalKey<NavigatorState> rootNavigatorKey,
  }) {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AdminShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.admin,
              builder: (context, state) => const OperationsHomePage(),
              routes: [
                GoRoute(
                  path: 'tickets',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AdminTicketsPage(),
                ),
                GoRoute(
                  path: 'art-submit',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AdminArtSubmitPage(),
                ),
                GoRoute(
                  path: 'panels',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AdminPanelsPage(),
                ),
                GoRoute(
                  path: 'talents',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AdminTalentsPage(),
                ),
                GoRoute(
                  path: 'dealers',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AdminDealersPage(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) {
                        final dealerId = state.pathParameters['id']!;
                        return AdminDealerDetailPage(dealerId: dealerId);
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'schedules',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AdminSchedulesPage(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) {
                        final scheduleId = state.pathParameters['id']!;
                        return AdminScheduleDetailPage(scheduleId: scheduleId);
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'users',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AdminUsersPage(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) {
                        final userId = state.pathParameters['id']!;
                        return AdminUserDetailPage(userId: userId);
                      },
                      routes: [
                        GoRoute(
                          path: 'edit',
                          parentNavigatorKey: rootNavigatorKey,
                          builder: (context, state) {
                            final userId = state.pathParameters['id']!;
                            return AdminUserEditPage(userId: userId);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.adminDashboard,
              builder: (context, state) => const AdminDashboardPage(),
              routes: [
                GoRoute(
                  path: 'users',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const AdminDashboardUsersPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.adminScanTicket,
              builder: (context, state) => const AdminScanTicketPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.adminHistory,
              builder: (context, state) => const AdminScanHistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.adminLostFound,
              builder: (context, state) => const AdminLostFoundPage(),
              routes: [
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final itemId = state.pathParameters['id']!;
                    return AdminLostFoundDetailPage(itemId: itemId);
                  },
                  routes: [
                    GoRoute(
                      path: 'return',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) {
                        final itemId = state.pathParameters['id']!;
                        return AdminLostFoundReturnPage(itemId: itemId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.adminSystem,
              builder: (context, state) => const AdminSystemPage(),
            ),
          ],
        ),
      ],
    );
  }
}
