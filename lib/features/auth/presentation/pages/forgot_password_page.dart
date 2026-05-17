import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/utils/auth_messages.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_nav_links.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_page_layout.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/forgot_password_form.dart';
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _forgotPasswordUseCase = sl<ForgotPasswordUseCase>();
  bool _isLoading = false;
  bool _emailSent = false;

  Future<void> _onSubmit(String email) async {
    setState(() {
      _isLoading = true;
      _emailSent = false;
    });

    final result = await _forgotPasswordUseCase(email: email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case Success():
        setState(() => _emailSent = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'If an account exists, a reset link has been sent to your email.',
            ),
          ),
        );
      case Error(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authErrorMessage(
                failure.message,
                fallback: 'Could not send reset email. Please try again.',
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      heroTitle: 'Forgot password',
      heroSubtitle: 'We will email you a reset link',
      footer: const AuthNavLinks(
        leading: AuthNavLink(label: 'Sign in', route: Routes.login),
        trailing: AuthNavLink(label: 'Create account', route: Routes.register),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_emailSent)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Check your inbox for the reset link. You can return to sign in.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ForgotPasswordForm(isLoading: _isLoading, onSubmit: _onSubmit),
        ],
      ),
    );
  }
}
