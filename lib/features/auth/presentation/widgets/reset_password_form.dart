import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';

abstract final class _ResetFormColors {
  static const textDark = FuvekonColors.darkButtonText;
  static const inputFill = Color(0xFFF8FCFA);
  static const inputHint = FuvekonColors.textSecondary;
  static const accentGreen = FuvekonColors.sageGreenContainer;
  static const iconCircle = FuvekonColors.surface;
}

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({
    super.key,
    required this.isLoading,
    required this.hasToken,
    required this.onSubmit,
  });

  final bool isLoading;
  final bool hasToken;
  final void Function(String newPassword, String confirmPassword) onSubmit;

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!widget.hasToken) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmit(_newController.text, _confirmController.text);
  }

  InputDecoration _inputDecoration({
    required String hint,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _ResetFormColors.inputHint),
      filled: true,
      fillColor: _ResetFormColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _ResetFormColors.textDark.withValues(alpha: 0.08),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _ResetFormColors.accentGreen.withValues(alpha: 0.65),
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
                color: _ResetFormColors.iconCircle,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.password_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.resetPasswordTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ResetFormColors.textDark,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.resetPasswordSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _ResetFormColors.textDark.withValues(alpha: 0.72),
              fontSize: 13.5,
              height: 1.45,
            ),
          ),
          if (!widget.hasToken) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFD64550).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD64550).withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                l10n.resetPasswordInvalidLink,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _ResetFormColors.textDark,
                  fontSize: 13,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            l10n.resetPasswordNewLabel,
            style: const TextStyle(
              color: _ResetFormColors.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _newController,
            obscureText: _obscureNew,
            enabled: widget.hasToken && !widget.isLoading,
            style: const TextStyle(color: _ResetFormColors.textDark),
            decoration: _inputDecoration(
              hint: l10n.resetPasswordNewHint,
              suffix: IconButton(
                icon: Icon(
                  _obscureNew ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),
            validator: (value) {
              if (value == null || value.length < 8) {
                return l10n.resetPasswordMinLength;
              }
              return null;
            },
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.resetPasswordConfirmLabel,
            style: const TextStyle(
              color: _ResetFormColors.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmController,
            obscureText: _obscureConfirm,
            enabled: widget.hasToken && !widget.isLoading,
            style: const TextStyle(color: _ResetFormColors.textDark),
            decoration: _inputDecoration(
              hint: l10n.resetPasswordConfirmHint,
              suffix: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (value) {
              if (value != _newController.text) {
                return l10n.resetPasswordMismatch;
              }
              return null;
            },
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: widget.hasToken && !widget.isLoading ? _submit : null,
            style: FilledButton.styleFrom(
              backgroundColor: _ResetFormColors.accentGreen,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  _ResetFormColors.accentGreen.withValues(alpha: 0.45),
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
                      const Icon(Icons.lock_reset_rounded, size: 20),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          l10n.resetPasswordSubmit,
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
