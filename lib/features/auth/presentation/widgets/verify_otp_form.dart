import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/core/utils/validators.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';

class VerifyOtpForm extends StatefulWidget {
  const VerifyOtpForm({
    super.key,
    required this.email,
    required this.isLoading,
    required this.isResending,
    required this.onSubmit,
    required this.onResend,
  });

  final String email;
  final bool isLoading;
  final bool isResending;
  final void Function(String otp) onSubmit;
  final VoidCallback onResend;

  @override
  State<VerifyOtpForm> createState() => _VerifyOtpFormState();
}

class _VerifyOtpFormState extends State<VerifyOtpForm> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmit(_otpController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'We sent a verification code to ${widget.email}. Enter it below.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ext.contentOnCardMuted,
                ),
          ),
          const SizedBox(height: 20),
          AppLabeledField(
            label: 'Verification code',
            required: true,
            field: TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: '000000'),
              validator: (v) => Validators.requiredField(v, label: 'Code'),
              enabled: !widget.isLoading,
              onFieldSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: widget.isLoading ? null : _submit,
            icon: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.verified_outlined),
            label: Text(widget.isLoading ? 'Verifying…' : 'Verify email'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: widget.isResending || widget.isLoading
                ? null
                : widget.onResend,
            child: widget.isResending
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Resend code'),
          ),
        ],
      ),
    );
  }
}
