import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/utils/auth_messages.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_nav_links.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_page_layout.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/google_register_form.dart';
class GoogleRegisterPage extends StatelessWidget {
  const GoogleRegisterPage({super.key, required this.credential});

  final String credential;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthFailure || current is AuthAuthenticated,
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
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AuthPageLayout(
          heroTitle: 'Almost there',
          heroSubtitle: 'Fill in the remaining details to finish Google sign-up',
          footer: const AuthNavLinks(
            leading: AuthNavLink(label: 'Sign in', route: Routes.login),
          ),
          child: GoogleRegisterForm(
            isLoading: isLoading,
            onSubmit: ({
              required fullName,
              required nickname,
              required dateOfBirth,
              required country,
            }) {
              context.read<AuthBloc>().add(
                    AuthEvent.googleRegisterSubmitted(
                      credential: credential,
                      fullName: fullName,
                      nickname: nickname,
                      dateOfBirth: dateOfBirth,
                      country: country,
                    ),
                  );
            },
          ),
        );
      },
    );
  }
}
