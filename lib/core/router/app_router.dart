import 'package:flutter/material.dart';

import 'package:fuvekonmobile/core/auth/user_role.dart';

import 'package:fuvekonmobile/core/di/injection.dart';

import 'package:fuvekonmobile/core/errors/result.dart';

import 'package:fuvekonmobile/core/router/account_routes.dart';

import 'package:fuvekonmobile/core/router/admin_routes.dart';

import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';

import 'package:fuvekonmobile/core/router/guest_routes.dart';

import 'package:fuvekonmobile/core/router/onboarding_routes.dart';
import 'package:fuvekonmobile/core/router/public_routes.dart';

import 'package:fuvekonmobile/core/router/routes.dart';

import 'package:fuvekonmobile/features/profile/domain/usecases/get_me_usecase.dart';

import 'package:get_it/get_it.dart';

import 'package:go_router/go_router.dart';



class AppRouter {

  AppRouter({required AuthSessionNotifier authSessionNotifier})

      : _authSessionNotifier = authSessionNotifier;



  final AuthSessionNotifier _authSessionNotifier;



  final rootNavigatorKey = GlobalKey<NavigatorState>();



  late final GoRouter router = GoRouter(

    navigatorKey: rootNavigatorKey,

    initialLocation: Routes.splash,

    refreshListenable: _authSessionNotifier,

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

      return Routes.account;

    }



    if (Routes.isAdminRoute(location)) {

      if (_authSessionNotifier.isAdmin) {

        return null;

      }



      if (_authSessionNotifier.isStaff &&

          Routes.isStaffAccessibleAdminRoute(location)) {

        return null;

      }



      return _authSessionNotifier.homeRoute;

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

  final _getMeUseCase = sl<GetMeUseCase>();



  @override

  void initState() {

    super.initState();

    _notifier.addListener(_onSessionChanged);

    _syncRole();

  }



  @override

  void dispose() {

    _notifier.removeListener(_onSessionChanged);

    super.dispose();

  }



  void _onSessionChanged() => _syncRole();



  Future<void> _syncRole() async {

    if (!_notifier.isAuthenticated) {

      _notifier.updateRole(null);

      _notifier.updateVerified(null);

      return;

    }



    final result = await _getMeUseCase();

    switch (result) {

      case Success(:final data):

        _notifier.updateRole(UserRole.tryParse(data.role));

        _notifier.updateVerified(data.isVerified);

      case Error():

        _notifier.updateRole(null);

        _notifier.updateVerified(null);

    }

  }



  @override

  Widget build(BuildContext context) => widget.child;

}

