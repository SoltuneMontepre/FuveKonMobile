import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/utils/auth_messages.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/register_input.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_nav_links.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_page_layout.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/register_form.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerUseCase = sl<RegisterUseCase>();
  bool _isLoading = false;

  Future<void> _onSubmit({
    required String fullName,
    required String nickname,
    required String email,
    required String dateOfBirth,
    required String country,
    required String password,
    required String confirmPassword,
  }) async {
    setState(() => _isLoading = true);

    final result = await _registerUseCase(
      RegisterInput(
        fullName: fullName,
        nickname: nickname,
        email: email,
        dateOfBirth: dateOfBirth,
        country: country,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case Success():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created. Check your email for a code.'),
          ),
        );
        context.go(Routes.verifyOtp, extra: email);
      case Error(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authErrorMessage(
                failure.message,
                fallback: 'Registration failed. Please try again.',
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      heroTitle: 'Create account',
      heroSubtitle: 'Join Fuvekon to get started',
      footer: const AuthNavLinks(
        leading: AuthNavLink(label: 'Sign in', route: Routes.login),
        trailing: AuthNavLink(
          label: 'Forgot password?',
          route: Routes.forgotPassword,
        ),
      ),
      child: RegisterForm(isLoading: _isLoading, onSubmit: _onSubmit),
    );
  }
}
