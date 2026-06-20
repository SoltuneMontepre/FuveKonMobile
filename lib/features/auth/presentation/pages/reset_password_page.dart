import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/utils/auth_messages.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/forgot_password_page_layout.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/reset_password_form.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.token});

  final String token;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _resetPasswordUseCase = sl<ResetPasswordUseCase>();
  bool _isLoading = false;

  Future<void> _onSubmit(String newPassword, String confirmPassword) async {
    setState(() => _isLoading = true);

    final result = await _resetPasswordUseCase(
      token: widget.token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case Success():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.resetPasswordSuccessMessage)),
        );
        context.go(Routes.login);
      case Error(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authErrorMessage(
                failure.message,
                fallback: context.l10n.resetPasswordFailureMessage,
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasToken = widget.token.isNotEmpty;

    return ForgotPasswordPageLayout(
      form: ResetPasswordForm(
        isLoading: _isLoading,
        hasToken: hasToken,
        onSubmit: _onSubmit,
      ),
      footer: TextButton(
        onPressed: () => context.go(Routes.login),
        style: TextButton.styleFrom(
          foregroundColor: FuvekonColors.darkButtonText,
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
              l10n.resetPasswordBackToLogin,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
