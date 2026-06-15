import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/utils/auth_messages.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_nav_links.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_page_layout.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/login_form.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthFailure ||
          current is AuthAuthenticated ||
          current is AuthGoogleRegistrationRequired,
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                authErrorMessage(
                  state.message,
                  fallback: state.message,
                ),
              ),
            ),
          );
        }
        if (state is AuthGoogleRegistrationRequired) {
          context.push(Routes.googleRegister, extra: state.credential);
          context.read<AuthBloc>().add(
                const AuthEvent.googleRegistrationNavigated(),
              );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AuthPageLayout(
          heroTitle: 'Welcome back',
          heroSubtitle: 'Sign in to ${AppConfig.appName}',
          footer: const LoginNavLinks(),
          child: LoginForm(
            isLoading: isLoading,
            onSubmit: (email, password) {
              context.read<AuthBloc>().add(
                    AuthEvent.loginSubmitted(
                      email: email,
                      password: password,
                    ),
                  );
            },
            onGoogleSignIn: AppConfig.hasGoogleSignIn
                ? () => context.read<AuthBloc>().add(
                      const AuthEvent.googleSignInRequested(),
                    )
                : null,
          ),
        );
      },
    );
  }
}
