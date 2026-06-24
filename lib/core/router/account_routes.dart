import 'package:flutter/material.dart';

import 'package:fuvekonmobile/core/router/routes.dart';

import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';

import 'package:fuvekonmobile/features/profile/presentation/pages/edit_profile_page.dart';

import 'package:fuvekonmobile/features/profile/presentation/pages/profile_page.dart';

import 'package:fuvekonmobile/features/ticket/presentation/models/my_ticket_list_item.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/e_ticket_detail_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/my_ticket_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/ticket_upgrade_page.dart';

import 'package:fuvekonmobile/screens/account/account_pages.dart';

import 'package:fuvekonmobile/screens/account/account_shell.dart';

import 'package:fuvekonmobile/screens/account/pages/authenticated_home_page.dart';

import 'package:fuvekonmobile/features/notification/presentation/pages/notification_detail_page.dart';

import 'package:fuvekonmobile/features/notification/presentation/pages/notifications_page.dart';

import 'package:fuvekonmobile/features/schedule/presentation/pages/activity_detail_page.dart';

import 'package:fuvekonmobile/features/schedule/presentation/pages/event_detail_page.dart';

import 'package:fuvekonmobile/features/schedule/presentation/pages/my_itinerary_page.dart';

import 'package:fuvekonmobile/features/schedule/presentation/pages/schedule_page.dart';

import 'package:fuvekonmobile/features/schedule/presentation/pages/venue_detail_page.dart';

import 'package:fuvekonmobile/features/schedule/presentation/pages/venue_map_page.dart';

import 'package:fuvekonmobile/screens/account/services/account_dealer_service.dart';

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

              routes: [
                GoRoute(
                  path: 'activity/:id',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) {
                    final id = state.pathParameters['id']!;

                    return ActivityDetailPage(activityId: id);
                  },
                ),

                GoRoute(
                  path: 'event/:id',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) {
                    final id = state.pathParameters['id']!;

                    return EventDetailPage(eventId: id);
                  },
                ),

                GoRoute(
                  path: 'map',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) => const VenueMapPage(),
                ),

                GoRoute(
                  path: 'venue/:id',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) {
                    final id = state.pathParameters['id']!;

                    return VenueDetailPage(venueId: id);
                  },
                ),

                GoRoute(
                  path: 'my',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) => const MyItineraryPage(),
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.accountTicket,

              builder: (context, state) => const MyTicketPage(),

              routes: [
                GoRoute(
                  path: 'upgrade',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) => const TicketUpgradePage(),
                ),

                GoRoute(
                  path: ':id',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) {
                    final args = state.extra as ETicketDetailArgs;

                    return ETicketDetailPage(args: args);
                  },
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.accountNotifications,

              builder: (context, state) => const NotificationsPage(),

              routes: [
                GoRoute(
                  path: ':id',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) {
                    final id = state.pathParameters['id']!;

                    return NotificationDetailPage(notificationId: id);
                  },
                ),
              ],
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
                  path: 'settings',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) => const SettingsPage(),
                ),

                GoRoute(
                  path: 'verify-identity',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) => const VerifyIdentityPage(),
                ),

                GoRoute(
                  path: 'submissions',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) => const SubmissionsHubPage(),
                ),

                GoRoute(
                  path: 'change-password',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) => const ChangePasswordPage(),
                ),

                GoRoute(
                  path: 'conbook',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) => const AccountConbookPage(),

                  routes: [
                    GoRoute(
                      path: 'submit',

                      parentNavigatorKey: rootNavigatorKey,

                      builder: (context, state) =>
                          const AccountConbookSubmitPage(),
                    ),

                    GoRoute(
                      path: ':id',

                      parentNavigatorKey: rootNavigatorKey,

                      builder: (context, state) {
                        final id = state.pathParameters['id']!;

                        return AccountConbookDetailPage(conbookId: id);
                      },

                      routes: [
                        GoRoute(
                          path: 'edit',

                          parentNavigatorKey: rootNavigatorKey,

                          builder: (context, state) {
                            final id = state.pathParameters['id']!;

                            return AccountConbookEditPage(conbookId: id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                GoRoute(
                  path: 'talent',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) => const AccountTalentPage(),

                  routes: [
                    GoRoute(
                      path: ':id',

                      parentNavigatorKey: rootNavigatorKey,

                      builder: (context, state) {
                        final id = state.pathParameters['id']!;

                        return AccountTalentDetailPage(talentId: id);
                      },

                      routes: [
                        GoRoute(
                          path: 'edit',

                          parentNavigatorKey: rootNavigatorKey,

                          builder: (context, state) {
                            final id = state.pathParameters['id']!;

                            return AccountTalentEditPage(talentId: id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                GoRoute(
                  path: 'panel',

                  parentNavigatorKey: rootNavigatorKey,

                  builder: (context, state) => const AccountPanelPage(),

                  routes: [
                    GoRoute(
                      path: ':id',

                      parentNavigatorKey: rootNavigatorKey,

                      builder: (context, state) {
                        final id = state.pathParameters['id']!;

                        return AccountPanelDetailPage(panelId: id);
                      },
                    ),
                  ],
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

                    GoRoute(
                      path: 'staff',

                      parentNavigatorKey: rootNavigatorKey,

                      builder: (context, state) {
                        final booth = state.extra as DealerBoothInfo;

                        return AccountDealerStaffPage(booth: booth);
                      },
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
