import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';

abstract final class _ForgotFormColors {
  static const textDark = FuvekonColors.darkButtonText;
  static const inputFill = Color(0xFFF8FCFA);
  static const inputHint = FuvekonColors.textSecondary;
  static const accentGreen = FuvekonColors.sageGreenContainer;
  static const iconCircle = FuvekonColors.surface;
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    this.emailSent = false,
  });

  final bool isLoading;
  final bool emailSent;
  final void Function(String email) onSubmit;

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmit(_emailController.text.trim());
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _ForgotFormColors.inputHint),
      filled: true,
      fillColor: _ForgotFormColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _ForgotFormColors.textDark.withValues(alpha: 0.08),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _ForgotFormColors.accentGreen.withValues(alpha: 0.65),
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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: _ForgotFormColors.iconCircle,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.forgotPasswordTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ForgotFormColors.textDark,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.forgotPasswordSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _ForgotFormColors.textDark.withValues(alpha: 0.72),
              fontSize: 13.5,
              height: 1.45,
            ),
          ),
          if (widget.emailSent) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _ForgotFormColors.accentGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _ForgotFormColors.accentGreen.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.forgotPasswordSuccessMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _ForgotFormColors.textDark,
                      fontSize: 13,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.forgotPasswordSentHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _ForgotFormColors.textDark.withValues(alpha: 0.7),
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            l10n.loginEmailLabel,
            style: const TextStyle(
              color: _ForgotFormColors.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            style: const TextStyle(color: _ForgotFormColors.textDark),
            decoration: _inputDecoration(hint: l10n.forgotPasswordEmailHint),
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
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: widget.isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: _ForgotFormColors.accentGreen,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  _ForgotFormColors.accentGreen.withValues(alpha: 0.45),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.send_rounded, size: 20),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          l10n.forgotPasswordSubmit,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
