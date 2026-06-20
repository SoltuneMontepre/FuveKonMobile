import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/screens/contribute/contribute_pages.dart';
import 'package:fuvekonmobile/screens/info/info_pages.dart';
import 'package:fuvekonmobile/screens/public/public_pages.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/explore_tickets_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/ticket_tier_detail_page.dart';
import 'package:fuvekonmobile/features/ticket/presentation/pages/ticket_purchase_page.dart';
import 'package:fuvekonmobile/features/schedule/presentation/pages/activity_detail_page.dart';
import 'package:fuvekonmobile/features/schedule/presentation/pages/event_detail_page.dart';
import 'package:fuvekonmobile/features/schedule/presentation/pages/my_itinerary_page.dart';
import 'package:fuvekonmobile/features/schedule/presentation/pages/schedule_page.dart';
import 'package:fuvekonmobile/features/schedule/presentation/pages/venue_detail_page.dart';
import 'package:fuvekonmobile/features/schedule/presentation/pages/venue_map_page.dart';
import 'package:go_router/go_router.dart';

abstract final class PublicRoutes {
  static List<RouteBase> routes({
    required GlobalKey<NavigatorState> rootNavigatorKey,
  }) => [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const GuestLandingPage(),
    ),
    GoRoute(
      path: Routes.ticket,
      builder: (context, state) => const ExploreTicketsPage(),
      routes: [
        GoRoute(
          path: 'purchase/:id',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final queued = state.extra == true;
            return TicketPurchasePage(tierId: id, queued: queued);
          },
        ),
        GoRoute(
          path: ':id',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) =>
              TicketTierDetailPage(tierId: state.pathParameters['id']!),
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
    GoRoute(path: Routes.about, builder: (context, state) => const AboutPage()),
    GoRoute(path: Routes.faq, builder: (context, state) => const FaqPage()),
    GoRoute(
      path: Routes.tos,
      builder: (context, state) =>
          TosPage(onboarding: state.uri.queryParameters['onboarding'] == '1'),
    ),
    GoRoute(
      path: Routes.schedule,
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
    GoRoute(
      path: Routes.lostFound,
      builder: (context, state) => const LostFoundPage(),
      routes: [
        GoRoute(
          path: 'report',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const LostFoundReportPage(),
        ),
        GoRoute(
          path: 'requests/:id',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return LostFoundRequestPage(requestId: id);
          },
        ),
        GoRoute(
          path: ':id',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return LostFoundDetailPage(itemId: id);
          },
        ),
      ],
    ),
    GoRoute(path: Routes.recap, builder: (context, state) => const RecapPage()),
  ];
}
