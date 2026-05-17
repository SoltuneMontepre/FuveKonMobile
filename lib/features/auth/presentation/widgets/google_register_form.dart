import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/utils/validators.dart';
import 'package:intl/intl.dart';

class GoogleRegisterForm extends StatefulWidget {
  const GoogleRegisterForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  final bool isLoading;
  final void Function({
    required String fullName,
    required String nickname,
    required String dateOfBirth,
    required String country,
  }) onSubmit;

  @override
  State<GoogleRegisterForm> createState() => _GoogleRegisterFormState();
}

class _GoogleRegisterFormState extends State<GoogleRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _countryController = TextEditingController();

  DateTime? _dateOfBirth;
  String? _dateOfBirthError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicknameController.dispose();
    _countryController.dispose();
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

    widget.onSubmit(
      fullName: _fullNameController.text.trim(),
      nickname: _nicknameController.text.trim(),
      dateOfBirth: DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
      country: _countryController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _dateOfBirth == null
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
            decoration: const InputDecoration(labelText: 'Nickname / fursona'),
            validator: (value) =>
                Validators.requiredField(value, label: 'Nickname'),
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: widget.isLoading ? null : _pickDateOfBirth,
            borderRadius: BorderRadius.circular(4),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Date of birth',
                errorText: _dateOfBirthError,
              ),
              child: Text(
                dateLabel,
                style: TextStyle(
                  color: _dateOfBirth == null
                      ? Theme.of(context).hintColor
                      : null,
                ),
              ),
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
          const SizedBox(height: 24),
          FilledButton(
            onPressed: widget.isLoading ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Complete registration'),
          ),
        ],
      ),
    );
  }
}
