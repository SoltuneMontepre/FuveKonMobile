import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:fuvekonmobile/shared/services/google_sign_in_service.dart';
import 'package:go_router/go_router.dart';

abstract final class _LoginFormColors {
  static const label = Colors.white;
  static const bodyMuted = Color(0xD9FFFFFF);

  static const inputText = FuvekonColors.onSageGreen;
  static const inputFill = Color(0xFFF8FCFA);
  static const inputHint = FuvekonColors.textSecondary;
  static const inputIcon = FuvekonColors.sageGreenContainer;

  static const buttonBg = FuvekonColors.sageGreen;
  static const buttonFg = FuvekonColors.onSageGreen;
  static const link = FuvekonColors.darkPrimary;
  static const forgotGold = FuvekonColors.lightGold;
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    this.onGoogleSignIn,
  });

  final bool isLoading;
  final void Function(String email, String password) onSubmit;
  final VoidCallback? onGoogleSignIn;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmit(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _LoginFormColors.inputHint),
      filled: true,
      fillColor: _LoginFormColors.inputFill,
      prefixIcon: Icon(prefixIcon, color: _LoginFormColors.inputIcon),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _LoginFormColors.inputText.withValues(alpha: 0.12),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _LoginFormColors.link.withValues(alpha: 0.85),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD64550)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD64550)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final googleConfigured = AppConfig.hasGoogleSignIn;
    final googleSupported = GoogleSignInService.isPlatformSupported;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FieldLabel(text: l10n.loginEmailLabel),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            style: const TextStyle(color: _LoginFormColors.inputText),
            decoration: _inputDecoration(
              hint: l10n.loginEmailHint,
              prefixIcon: Icons.mail_outline,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.validationEmailRequired;
              }
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
              if (!emailRegex.hasMatch(value.trim())) {
                return l10n.validationEmailInvalid;
              }
              return null;
            },
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _FieldLabel(text: l10n.loginPasswordLabel)),
              TextButton(
                onPressed: widget.isLoading
                    ? null
                    : () => context.push(Routes.forgotPassword),
                style: TextButton.styleFrom(
                  foregroundColor: _LoginFormColors.forgotGold,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.loginForgotPassword,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            autofillHints: const [AutofillHints.password],
            style: const TextStyle(color: _LoginFormColors.inputText),
            decoration: _inputDecoration(
              hint: '••••••••',
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _LoginFormColors.inputIcon,
                ),
                onPressed: widget.isLoading
                    ? null
                    : () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.validationPasswordRequired;
              }
              if (value.length < 6) {
                return l10n.validationPasswordMin;
              }
              return null;
            },
            enabled: !widget.isLoading,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: widget.isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: _LoginFormColors.buttonBg,
              foregroundColor: _LoginFormColors.buttonFg,
              disabledBackgroundColor:
                  _LoginFormColors.buttonBg.withValues(alpha: 0.35),
              disabledForegroundColor:
                  _LoginFormColors.buttonFg.withValues(alpha: 0.55),
              minimumSize: const Size.fromHeight(52),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: widget.isLoading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _LoginFormColors.buttonFg,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.loginSubmit,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.login_rounded, size: 20),
                    ],
                  ),
          ),
          if (widget.onGoogleSignIn != null) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    l10n.loginOrDivider,
                    style: TextStyle(
                      color: _LoginFormColors.bodyMuted,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GoogleSignInButton(
              isLoading: widget.isLoading,
              onPressed: widget.onGoogleSignIn,
              label: l10n.loginGoogle,
              lightStyle: true,
            ),
            if (googleConfigured && !googleSupported) ...[
              const SizedBox(height: 10),
              Text(
                l10n.authGoogleUnsupportedPlatform,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _LoginFormColors.bodyMuted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: _LoginFormColors.label,
        fontWeight: FontWeight.w600,
        fontSize: 13.5,
      ),
    );
  }
}
