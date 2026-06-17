import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/update_profile_input.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/edit_profile_bloc.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/edit_profile_event.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/edit_profile_state.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';

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

  InputDecoration _decoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: FuvekonColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FuvekonRadii.input),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVerified = widget.account.isVerified == true;
    final ext = context.fuvekonTheme;

    return BlocProvider(
      create: (_) => sl<EditProfileBloc>(),
      child: BlocListener<EditProfileBloc, EditProfileState>(
        listenWhen: (previous, current) =>
            current is EditProfileSaved || current is EditProfileFailure,
        listener: (context, state) {
          switch (state) {
            case EditProfileSaved():
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã cập nhật hồ sơ')),
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
        child: AppPageScaffold(
          title: 'Chỉnh sửa hồ sơ',
          body: BlocBuilder<EditProfileBloc, EditProfileState>(
            builder: (context, state) {
              final isSaving = state is EditProfileSaving;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: FuveMintCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!isVerified) ...[
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: ext.notesSurface,
                                    borderRadius:
                                        BorderRadius.circular(FuvekonRadii.notes),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            color: ext.infoAccent, size: 20),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Xác minh email trước khi chỉnh sửa hồ sơ.',
                                            style: TextStyle(
                                              color: ext.contentOnCardMuted,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: FuvekonSpacing.field),
                              ],
                              TextFormField(
                                initialValue: widget.account.email,
                                readOnly: true,
                                decoration: _decoration(
                                  'Email',
                                  icon: Icons.email_outlined,
                                ),
                              ),
                              const SizedBox(height: FuvekonSpacing.field),
                              TextFormField(
                                controller: _fursonaController,
                                enabled: isVerified && !isSaving,
                                textCapitalization: TextCapitalization.words,
                                decoration: _decoration(
                                  'Nickname',
                                  icon: Icons.pets_outlined,
                                ),
                              ),
                              const SizedBox(height: FuvekonSpacing.field),
                              TextFormField(
                                controller: _firstNameController,
                                enabled: isVerified && !isSaving,
                                textCapitalization: TextCapitalization.words,
                                decoration: _decoration(
                                  'Họ',
                                  icon: Icons.badge_outlined,
                                ),
                              ),
                              const SizedBox(height: FuvekonSpacing.field),
                              TextFormField(
                                controller: _lastNameController,
                                enabled: isVerified && !isSaving,
                                textCapitalization: TextCapitalization.words,
                                decoration: _decoration(
                                  'Tên',
                                  icon: Icons.badge_outlined,
                                ),
                              ),
                              const SizedBox(height: FuvekonSpacing.field),
                              TextFormField(
                                controller: _countryController,
                                enabled: isVerified && !isSaving,
                                textCapitalization: TextCapitalization.words,
                                decoration: _decoration(
                                  'Quốc gia',
                                  icon: Icons.public_outlined,
                                ),
                              ),
                              const SizedBox(height: FuvekonSpacing.field),
                              TextFormField(
                                controller: _idCardController,
                                enabled: isVerified && !isSaving,
                                decoration: _decoration(
                                  'CMND/Hộ chiếu',
                                  icon: Icons.credit_card_outlined,
                                ),
                              ),
                              const SizedBox(height: FuvekonSpacing.field),
                              TextFormField(
                                controller: _dobController,
                                enabled: isVerified && !isSaving,
                                keyboardType: TextInputType.datetime,
                                decoration: _decoration(
                                  'Ngày sinh',
                                  icon: Icons.cake_outlined,
                                ).copyWith(hintText: 'YYYY-MM-DD'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: FuvekonSpacing.stackGapMd),
                  FuvePillButton(
                    label: isSaving ? 'Đang lưu...' : 'Lưu thay đổi',
                    icon: Icons.save_outlined,
                    onPressed:
                        isVerified && !isSaving ? () => _submit(context) : null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
