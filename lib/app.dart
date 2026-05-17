import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
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
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const AuthEvent.started()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (_, state) => sl<AuthSessionNotifier>().update(state),
        child: MaterialApp.router(
          title: AppConfig.appName,
          theme: AppTheme.light,
          routerConfig: sl<AppRouter>().router,
        ),
      ),
    );
  }
}
