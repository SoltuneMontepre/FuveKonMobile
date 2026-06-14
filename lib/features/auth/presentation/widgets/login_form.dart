import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/utils/validators.dart';
import 'package:fuvekonmobile/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppLabeledField(
            label: 'Email',
            required: true,
            field: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(hintText: 'you@example.com'),
              validator: Validators.email,
              enabled: !widget.isLoading,
            ),
          ),
          const SizedBox(height: 16),
          AppLabeledField(
            label: 'Password',
            required: true,
            field: TextFormField(
              controller: _passwordController,
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              decoration: const InputDecoration(hintText: '••••••••'),
              validator: Validators.password,
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
                : const Icon(Icons.login_rounded),
            label: Text(widget.isLoading ? 'Signing in…' : 'Sign in'),
          ),
          if (AppConfig.hasGoogleSignIn && widget.onGoogleSignIn != null) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            GoogleSignInButton(
              isLoading: widget.isLoading,
              onPressed: widget.onGoogleSignIn,
            ),
          ],
        ],
      ),
    );
  }
}
