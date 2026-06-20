import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/utils/auth_messages.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/register_input.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_nav_links.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/register_form.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/register_page_layout.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerUseCase = sl<RegisterUseCase>();
  bool _isLoading = false;

  String _deriveNickname(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isNotEmpty) {
      final firstWord = trimmed.split(RegExp(r'\s+')).first;
      final slug = firstWord.replaceAll(RegExp(r'[^\w]'), '');
      if (slug.isNotEmpty) return slug;
    }
    return 'user${DateTime.now().millisecondsSinceEpoch % 10000}';
  }

  Future<void> _onSubmit({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    setState(() => _isLoading = true);

    final result = await _registerUseCase(
      RegisterInput(
        fullName: fullName,
        nickname: _deriveNickname(fullName),
        email: email,
        dateOfBirth: '2000-01-01',
        country: 'Vietnam',
        password: password,
        confirmPassword: confirmPassword,
      ),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case Success():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.registerSuccessMessage)),
        );
        context.go(Routes.verifyOtp, extra: email);
      case Error(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authErrorMessage(
                failure.message,
                fallback: context.l10n.registerFailureMessage,
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RegisterPageLayout(
      footer: const RegisterNavLinks(),
      form: RegisterForm(isLoading: _isLoading, onSubmit: _onSubmit),
    );
  }
}
