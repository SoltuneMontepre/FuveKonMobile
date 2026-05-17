import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/update_profile_input.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/edit_profile_bloc.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/edit_profile_event.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/edit_profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.account});

  final Account account;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fursonaController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _countryController;
  late final TextEditingController _idCardController;
  late final TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    final account = widget.account;
    _fursonaController = TextEditingController(text: account.fursonaName ?? '');
    _firstNameController = TextEditingController(text: account.firstName ?? '');
    _lastNameController = TextEditingController(text: account.lastName ?? '');
    _countryController = TextEditingController(text: account.country ?? '');
    _idCardController = TextEditingController(text: account.idCard ?? '');
    _dobController = TextEditingController(text: account.dateOfBirth ?? '');
  }

  @override
  void dispose() {
    _fursonaController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _idCardController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<EditProfileBloc>().add(
          EditProfileEvent.submitted(
            UpdateProfileInput(
              fursonaName: _fursonaController.text,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              country: _countryController.text,
              idCard: _idCardController.text,
              dateOfBirth: _dobController.text,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isVerified = widget.account.isVerified == true;

    return BlocProvider(
      create: (_) => sl<EditProfileBloc>(),
      child: BlocListener<EditProfileBloc, EditProfileState>(
        listenWhen: (previous, current) =>
            current is EditProfileSaved || current is EditProfileFailure,
        listener: (context, state) {
          switch (state) {
            case EditProfileSaved():
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated')),
              );
              Navigator.of(context).pop(true);
            case EditProfileFailure(:final message):
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            default:
              break;
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Edit profile')),
          body: BlocBuilder<EditProfileBloc, EditProfileState>(
            builder: (context, state) {
              final isSaving = state is EditProfileSaving;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isVerified)
                        Card(
                          color: Theme.of(context)
                              .colorScheme
                              .errorContainer
                              .withValues(alpha: 0.5),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Verify your email before editing your profile.',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (!isVerified) const SizedBox(height: 16),
                      TextFormField(
                        initialValue: widget.account.email,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _fursonaController,
                        enabled: isVerified && !isSaving,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Nickname',
                          prefixIcon: Icon(Icons.pets_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _firstNameController,
                        enabled: isVerified && !isSaving,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'First name',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lastNameController,
                        enabled: isVerified && !isSaving,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Last name',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _countryController,
                        enabled: isVerified && !isSaving,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          prefixIcon: Icon(Icons.public_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _idCardController,
                        enabled: isVerified && !isSaving,
                        decoration: const InputDecoration(
                          labelText: 'Passport/ID card',
                          prefixIcon: Icon(Icons.credit_card_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dobController,
                        enabled: isVerified && !isSaving,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          labelText: 'Date of birth',
                          prefixIcon: Icon(Icons.cake_outlined),
                          hintText: 'YYYY-MM-DD',
                        ),
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed:
                            isVerified && !isSaving ? () => _submit(context) : null,
                        child: isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Save changes'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
