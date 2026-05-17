import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/utils/auth_messages.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_nav_links.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/auth_page_layout.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/verify_otp_form.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key, required this.email});

  final String email;

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _verifyOtpUseCase = sl<VerifyOtpUseCase>();
  final _resendOtpUseCase = sl<ResendOtpUseCase>();
  bool _isLoading = false;
  bool _isResending = false;

  Future<void> _onSubmit(String otp) async {
    setState(() => _isLoading = true);

    final result = await _verifyOtpUseCase(email: widget.email, otp: otp);

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case Success():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email verified. You can sign in now.')),
        );
        context.go(Routes.login);
      case Error(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authErrorMessage(
                failure.message,
                fallback: 'Invalid or expired code. Please try again.',
              ),
            ),
          ),
        );
    }
  }

  Future<void> _onResend() async {
    setState(() => _isResending = true);

    final result = await _resendOtpUseCase(email: widget.email);

    if (!mounted) return;
    setState(() => _isResending = false);

    switch (result) {
      case Success():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A new code has been sent.')),
        );
      case Error(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authErrorMessage(
                failure.message,
                fallback: 'Could not resend code. Please try again.',
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      heroTitle: 'Verify email',
      heroSubtitle: 'Enter the code we sent you',
      footer: const AuthNavLinks(
        leading: AuthNavLink(label: 'Sign in', route: Routes.login),
      ),
      child: VerifyOtpForm(
        email: widget.email,
        isLoading: _isLoading,
        isResending: _isResending,
        onSubmit: _onSubmit,
        onResend: _onResend,
      ),
    );
  }
}
