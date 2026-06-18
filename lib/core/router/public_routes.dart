import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/screens/contribute/contribute_pages.dart';
import 'package:fuvekonmobile/screens/info/info_pages.dart';
import 'package:fuvekonmobile/screens/public/public_pages.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/explore_tickets_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/ticket_tier_detail_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/ticket_purchase_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/tickets_page.dart';
import 'package:go_router/go_router.dart';

abstract final class PublicRoutes {
  static List<RouteBase> routes({
    required GlobalKey<NavigatorState> rootNavigatorKey,
  }) =>
      [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const GuestLandingPage(),
        ),
        GoRoute(
          path: Routes.ticket,
          builder: (context, state) => const ExploreTicketsPage(),
          routes: [
            GoRoute(
              path: 'purchase',
              builder: (context, state) => const TicketsPage(),
              routes: [
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    final queued = state.extra == true;
                    return TicketPurchasePage(
                      tierId: id,
                      queued: queued,
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => TicketTierDetailPage(
                tierId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: Routes.talent,
          builder: (context, state) => const TalentRegistrationPage(),
        ),
        GoRoute(
          path: Routes.panel,
          builder: (context, state) => const PanelRegistrationPage(),
        ),
        GoRoute(
          path: Routes.artbook,
          builder: (context, state) => const ArtbookPage(),
          routes: [
            GoRoute(
              path: 'submit',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const ArtbookSubmitPage(),
            ),
          ],
        ),
        GoRoute(
          path: Routes.dealer,
          builder: (context, state) => const DealerRegistrationPage(),
        ),
        GoRoute(
          path: Routes.volunteer,
          builder: (context, state) => const VolunteerPage(),
        ),
        GoRoute(
          path: Routes.about,
          builder: (context, state) => const AboutPage(),
        ),
        GoRoute(
          path: Routes.faq,
          builder: (context, state) => const FaqPage(),
        ),
        GoRoute(
          path: Routes.tos,
          builder: (context, state) => TosPage(
            onboarding: state.uri.queryParameters['onboarding'] == '1',
          ),
        ),
        GoRoute(
          path: Routes.schedule,
          builder: (context, state) => const SchedulePage(),
        ),
        GoRoute(
          path: Routes.lostFound,
          builder: (context, state) => const LostFoundPage(),
        ),
        GoRoute(
          path: Routes.recap,
          builder: (context, state) => const RecapPage(),
        ),
      ];
}
