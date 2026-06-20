import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/core/utils/validators.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
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
  })
  onSubmit;

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
      _dateOfBirthError = _dateOfBirth == null
          ? 'Date of birth is required'
          : null;
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
    final ext = context.fuvekonTheme;
    final dateLabel = _dateOfBirth == null
        ? 'Select date of birth'
        : DateFormat.yMMMd().format(_dateOfBirth!);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppLabeledField(
            label: 'Full name',
            required: true,
            field: TextFormField(
              controller: _fullNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Your legal name'),
              validator: Validators.fullName,
              enabled: !widget.isLoading,
            ),
          ),
          const SizedBox(height: 16),
          AppLabeledField(
            label: 'Nickname / fursona',
            required: true,
            field: TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(hintText: 'Display name'),
              validator: (value) =>
                  Validators.requiredField(value, label: 'Nickname'),
              enabled: !widget.isLoading,
            ),
          ),
          const SizedBox(height: 16),
          AppLabeledField(
            label: 'Date of birth',
            required: true,
            field: InkWell(
              onTap: widget.isLoading ? null : _pickDateOfBirth,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: 'Select date of birth',
                  errorText: _dateOfBirthError,
                ),
                child: Text(
                  dateLabel,
                  style: TextStyle(
                    color: _dateOfBirth == null
                        ? ext.contentOnCardMuted.withValues(alpha: 0.65)
                        : ext.contentOnCard,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppLabeledField(
            label: 'Country',
            required: true,
            field: TextFormField(
              controller: _countryController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Your country'),
              validator: Validators.country,
              enabled: !widget.isLoading,
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
                : const Icon(Icons.send_rounded),
            label: Text(widget.isLoading ? 'Saving…' : 'Complete registration'),
          ),
        ],
      ),
    );
  }
}
