import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/auth/auth_session_controller.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/locale/locale_notifier.dart';
import 'package:fuvekonmobile/core/router/app_router.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/theme/app_theme.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';

class FuvekonApp extends StatelessWidget {
  const FuvekonApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeNotifier = sl<LocaleNotifier>();

    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const AuthEvent.started()),
      child: _AuthSessionWire(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (_, state) => sl<AuthSessionNotifier>().update(state),
          child: RoleSessionSync(
            child: ListenableBuilder(
              listenable: localeNotifier,
              builder: (context, _) {
                return MaterialApp.router(
                  title: AppConfig.appName,
                  theme: AppTheme.dark,
                  themeMode: ThemeMode.dark,
                  locale: localeNotifier.locale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  routerConfig: sl<AppRouter>().router,
                  builder: (context, child) =>
                      child ?? const SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthSessionWire extends StatefulWidget {
  const _AuthSessionWire({required this.child});

  final Widget child;

  @override
  State<_AuthSessionWire> createState() => _AuthSessionWireState();
}

class _AuthSessionWireState extends State<_AuthSessionWire> {
  @override
  void initState() {
    super.initState();
    sl<AuthSessionController>().onSessionExpired = _onSessionExpired;
  }

  @override
  void dispose() {
    sl<AuthSessionController>().onSessionExpired = null;
    super.dispose();
  }

  void _onSessionExpired() {
    if (!mounted) return;
    context.read<AuthBloc>().add(const AuthEvent.sessionExpired());
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
