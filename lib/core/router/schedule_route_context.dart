import 'package:flutter/widgets.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:go_router/go_router.dart';

/// Resolves schedule sub-routes for public `/schedule` vs account `/account/schedule`.
abstract final class ScheduleRouteContext {
  static bool isPublic(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return path == Routes.schedule || path.startsWith('${Routes.schedule}/');
  }

  static String list(BuildContext context) =>
      isPublic(context) ? Routes.schedule : Routes.accountSchedule;

  static String map(BuildContext context) =>
      isPublic(context) ? Routes.scheduleMap : Routes.accountScheduleMap;

  static String my(BuildContext context) =>
      isPublic(context) ? Routes.scheduleMy : Routes.accountScheduleMy;

  static String event(BuildContext context, String id) => isPublic(context)
      ? Routes.scheduleEvent(id)
      : Routes.accountScheduleEvent(id);

  static String activity(BuildContext context, String id) => isPublic(context)
      ? Routes.scheduleActivity(id)
      : Routes.accountScheduleActivity(id);

  static String venue(BuildContext context, String id) => isPublic(context)
      ? Routes.scheduleVenue(id)
      : Routes.accountScheduleVenue(id);
}
