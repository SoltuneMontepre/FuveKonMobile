import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/utils/auth_messages.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/forgot_password_form.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/forgot_password_page_layout.dart';
import 'package:go_router/go_router.dart';

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
          SnackBar(content: Text(context.l10n.forgotPasswordSuccessMessage)),
        );
      case Error(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authErrorMessage(
                failure.message,
                fallback: context.l10n.forgotPasswordFailureMessage,
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ForgotPasswordPageLayout(
      form: ForgotPasswordForm(
        isLoading: _isLoading,
        emailSent: _emailSent,
        onSubmit: _onSubmit,
      ),
      footer: TextButton(
        onPressed: () => context.go(Routes.login),
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF0A2E1F),
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back, size: 18),
            const SizedBox(width: 6),
            Text(
              l10n.forgotPasswordBackToLogin,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
