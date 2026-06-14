import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/locale/locale_notifier.dart';
import 'package:fuvekonmobile/core/router/app_router.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/theme/app_theme.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';

class FuvekonApp extends StatelessWidget {
  const FuvekonApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeNotifier = sl<LocaleNotifier>();

    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const AuthEvent.started()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (_, state) => sl<AuthSessionNotifier>().update(state),
        child: RoleSessionSync(
          child: ListenableBuilder(
            listenable: localeNotifier,
            builder: (context, _) {
              return MaterialApp.router(
                title: AppConfig.appName,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: ThemeMode.dark,
                locale: localeNotifier.locale,
                supportedLocales: const [
                  Locale('vi'),
                  Locale('en'),
                ],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: sl<AppRouter>().router,
              );
            },
          ),
        ),
      ),
    );
  }
}
