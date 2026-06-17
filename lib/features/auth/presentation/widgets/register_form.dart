import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

abstract final class _RegisterFormColors {
  static const textDark = FuvekonColors.darkButtonText;
  static const inputFill = Color(0xFFF8FCFA);
  static const inputHint = FuvekonColors.textSecondary;
  static const iconMuted = FuvekonColors.sageGreenContainer;
  static const accentGreen = FuvekonColors.sageGreenContainer;
  static const linkGreen = FuvekonColors.darkButtonText;
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  final bool isLoading;
  final void Function({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) onSubmit;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.validationTermsRequired)),
      );
      return;
    }

    widget.onSubmit(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _RegisterFormColors.inputHint),
      filled: true,
      fillColor: _RegisterFormColors.inputFill,
      prefixIcon: Icon(prefixIcon, color: _RegisterFormColors.iconMuted),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _RegisterFormColors.textDark.withValues(alpha: 0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _RegisterFormColors.accentGreen.withValues(alpha: 0.65),
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
          _FieldLabel(text: l10n.registerFullNameLabel),
          const SizedBox(height: 8),
          TextFormField(
            controller: _fullNameController,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(color: _RegisterFormColors.textDark),
            decoration: _inputDecoration(
              hint: l10n.registerFullNameHint,
              prefixIcon: Icons.person_outline,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.validationFullNameRequired;
              }
              if (value.trim().length < 2) {
                return l10n.validationFullNameMin;
              }
              return null;
            },
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 16),
          _FieldLabel(text: l10n.registerEmailLabel),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            style: const TextStyle(color: _RegisterFormColors.textDark),
            decoration: _inputDecoration(
              hint: l10n.registerEmailHint,
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
          const SizedBox(height: 16),
          _FieldLabel(text: l10n.registerPhoneLabel),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            style: const TextStyle(color: _RegisterFormColors.textDark),
            decoration: _inputDecoration(
              hint: l10n.registerPhoneHint,
              prefixIcon: Icons.phone_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.validationPhoneRequired;
              }
              final digits = value.replaceAll(RegExp(r'\D'), '');
              if (digits.length < 9 || digits.length > 11) {
                return l10n.validationPhoneInvalid;
              }
              return null;
            },
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 16),
          _FieldLabel(text: l10n.registerPasswordLabel),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            autofillHints: const [AutofillHints.newPassword],
            style: const TextStyle(color: _RegisterFormColors.textDark),
            decoration: _inputDecoration(
              hint: l10n.registerPasswordHint,
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _RegisterFormColors.iconMuted,
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
          ),
          const SizedBox(height: 16),
          _FieldLabel(text: l10n.registerConfirmPasswordLabel),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            autofillHints: const [AutofillHints.newPassword],
            style: const TextStyle(color: _RegisterFormColors.textDark),
            decoration: _inputDecoration(
              hint: l10n.registerConfirmPasswordHint,
              prefixIcon: Icons.lock_reset_outlined,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _RegisterFormColors.iconMuted,
                ),
                onPressed: widget.isLoading
                    ? null
                    : () => setState(
                          () => _obscureConfirmPassword = !_obscureConfirmPassword,
                        ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.validationConfirmPasswordRequired;
              }
              if (value != _passwordController.text) {
                return l10n.validationPasswordMismatch;
              }
              return null;
            },
            enabled: !widget.isLoading,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _termsAccepted,
                  onChanged: widget.isLoading
                      ? null
                      : (value) => setState(() => _termsAccepted = value ?? false),
                  activeColor: _RegisterFormColors.accentGreen,
                  side: BorderSide(
                    color: _RegisterFormColors.textDark.withValues(alpha: 0.35),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _TermsText(isLoading: widget.isLoading)),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: widget.isLoading || !_termsAccepted ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: _RegisterFormColors.accentGreen,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  _RegisterFormColors.accentGreen.withValues(alpha: 0.45),
              minimumSize: const Size.fromHeight(52),
              elevation: 2,
              shadowColor: _RegisterFormColors.accentGreen.withValues(alpha: 0.35),
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
                      Text(
                        l10n.registerSubmit,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
          ),
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
        color: _RegisterFormColors.textDark,
        fontWeight: FontWeight.w600,
        fontSize: 13.5,
      ),
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final baseStyle = TextStyle(
      color: _RegisterFormColors.textDark.withValues(alpha: 0.78),
      fontSize: 12.5,
      height: 1.45,
    );
    final linkStyle = baseStyle.copyWith(
      color: _RegisterFormColors.linkGreen,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
      decorationColor: _RegisterFormColors.linkGreen.withValues(alpha: 0.5),
    );

    return Text.rich(
      TextSpan(
        text: l10n.registerTermsPrefix,
        style: baseStyle,
        children: [
          TextSpan(
            text: l10n.registerTermsTos,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = isLoading ? null : () => context.push(Routes.tos),
          ),
          TextSpan(text: l10n.registerTermsAnd, style: baseStyle),
          TextSpan(
            text: l10n.registerTermsPrivacy,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = isLoading ? null : () => context.push(Routes.tos),
          ),
          TextSpan(text: l10n.registerTermsSuffix, style: baseStyle),
        ],
      ),
    );
  }
}
