import 'package:flutter/material.dart';

import 'package:fuvekonmobile/core/auth/session_hydration_service.dart';

import 'package:fuvekonmobile/core/di/injection.dart';

import 'package:fuvekonmobile/core/router/account_routes.dart';

import 'package:fuvekonmobile/core/router/admin_routes.dart';

import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';

import 'package:fuvekonmobile/core/router/guest_routes.dart';

import 'package:fuvekonmobile/core/router/onboarding_routes.dart';
import 'package:fuvekonmobile/core/router/public_routes.dart';

import 'package:fuvekonmobile/core/router/routes.dart';

import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';

import 'package:get_it/get_it.dart';

import 'package:go_router/go_router.dart';



class AppRouter {

  AppRouter({required AuthSessionNotifier authSessionNotifier})

      : _authSessionNotifier = authSessionNotifier,

        _routerRefresh = RouterRefreshNotifier(authSessionNotifier);



  final AuthSessionNotifier _authSessionNotifier;

  final RouterRefreshNotifier _routerRefresh;



  final rootNavigatorKey = GlobalKey<NavigatorState>();



  late final GoRouter router = GoRouter(

    navigatorKey: rootNavigatorKey,

    initialLocation: Routes.splash,

    refreshListenable: _routerRefresh,

    redirect: _redirect,

    routes: [

      ...OnboardingRoutes.routes(),

      ...PublicRoutes.routes(rootNavigatorKey: rootNavigatorKey),

      ...GuestRoutes.routes(),

      AccountRoutes.shell(rootNavigatorKey: rootNavigatorKey),

      AdminRoutes.shell(rootNavigatorKey: rootNavigatorKey),

    ],

  );



  String? _redirect(BuildContext context, GoRouterState state) {

    final isAuthenticated = _authSessionNotifier.isAuthenticated;

    final location = state.matchedLocation;

    final isGuestRoute = Routes.isGuestRoute(location);

    final isPublicRoute = Routes.isPublicRoute(location);

    final isOnboardingRoute = Routes.isOnboardingRoute(location);



    if (isAuthenticated && isOnboardingRoute) {

      return _authSessionNotifier.homeRoute;

    }



    if (!isAuthenticated) {

      if (isGuestRoute || isPublicRoute || isOnboardingRoute) return null;

      return Routes.login;

    }



    if (isGuestRoute) {

      return _authSessionNotifier.homeRoute;

    }



    if (Routes.isAccountRoute(location) &&

        _authSessionNotifier.isVerified == false &&

        !Routes.isUnverifiedAccountRoute(location)) {

      return Routes.accountProfile;

    }



    if (Routes.isAdminRoute(location)) {
      final role = _authSessionNotifier.role;
      final hydration = _authSessionNotifier.hydrationStatus;
      if (role == null &&
          (hydration == SessionHydrationStatus.idle ||
              hydration == SessionHydrationStatus.loading)) {
        return null;
      }
      if (role == null || !role.isPrivileged) {
        return _authSessionNotifier.homeRoute;
      }

      if (_authSessionNotifier.canAccessAdminRoute(location)) {
        return null;
      }

      return Routes.admin;
    }



    final roleHome = _authSessionNotifier.homeRoute;

    if (location == Routes.home && roleHome != Routes.home) {

      return roleHome;

    }



    return null;

  }



  static GoRouter get instance => GetIt.I<AppRouter>().router;

}



/// Loads the signed-in account role and keeps [AuthSessionNotifier] in sync.

class RoleSessionSync extends StatefulWidget {

  const RoleSessionSync({super.key, required this.child});



  final Widget child;



  @override

  State<RoleSessionSync> createState() => _RoleSessionSyncState();

}



class _RoleSessionSyncState extends State<RoleSessionSync> {

  final _notifier = sl<AuthSessionNotifier>();

  final _hydrationService = sl<SessionHydrationService>();

  late AuthState _lastAuthState;



  @override

  void initState() {

    super.initState();

    _lastAuthState = _notifier.state;

    _notifier.addListener(_onSessionChanged);

    _hydrateIfNeeded();

  }



  @override

  void dispose() {

    _notifier.removeListener(_onSessionChanged);

    super.dispose();

  }



  void _onSessionChanged() {

    final current = _notifier.state;

    if (current == _lastAuthState) return;

    _lastAuthState = current;

    _hydrateIfNeeded();

  }



  Future<void> _hydrateIfNeeded() => _hydrationService.hydrate();



  @override

  Widget build(BuildContext context) => widget.child;

}

