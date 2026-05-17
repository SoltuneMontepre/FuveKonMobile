import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/utils/validators.dart';
import 'package:intl/intl.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  final bool isLoading;
  final void Function({
    required String fullName,
    required String nickname,
    required String email,
    required String dateOfBirth,
    required String country,
    required String password,
    required String confirmPassword,
  }) onSubmit;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _countryController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _dateOfBirth;
  String? _dateOfBirthError;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
        _dateOfBirthError = null;
      });
    }
  }

  void _submit() {
    setState(() {
      _dateOfBirthError =
          _dateOfBirth == null ? 'Date of birth is required' : null;
    });
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_dateOfBirthError != null) return;
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms to continue')),
      );
      return;
    }

    widget.onSubmit(
      fullName: _fullNameController.text.trim(),
      nickname: _nicknameController.text.trim(),
      email: _emailController.text.trim(),
      dateOfBirth: DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
      country: _countryController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dobLabel = _dateOfBirth == null
        ? 'Select date of birth'
        : DateFormat.yMMMd().format(_dateOfBirth!);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _fullNameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Full name'),
            validator: Validators.fullName,
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nicknameController,
            decoration: const InputDecoration(labelText: 'Fursona / nickname'),
            validator: (v) => Validators.requiredField(v, label: 'Nickname'),
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(labelText: 'Email'),
            validator: Validators.email,
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: widget.isLoading ? null : _pickDateOfBirth,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Date of birth',
                errorText: _dateOfBirthError,
              ),
              child: Text(dobLabel),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _countryController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Country'),
            validator: Validators.country,
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            autofillHints: const [AutofillHints.newPassword],
            decoration: const InputDecoration(labelText: 'Password'),
            validator: Validators.strongPassword,
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            autofillHints: const [AutofillHints.newPassword],
            decoration: const InputDecoration(labelText: 'Confirm password'),
            validator: (v) =>
                Validators.confirmPassword(v, _passwordController.text),
            enabled: !widget.isLoading,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _termsAccepted,
            onChanged: widget.isLoading
                ? null
                : (value) => setState(() => _termsAccepted = value ?? false),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('I agree to the Terms of Service'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: widget.isLoading || !_termsAccepted ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create account'),
          ),
        ],
      ),
    );
  }
}
