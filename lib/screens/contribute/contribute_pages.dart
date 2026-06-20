import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/api/dealer_api.dart';
import 'package:fuvekonmobile/core/api/panel_api.dart';
import 'package:fuvekonmobile/core/api/talent_api.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/account/widgets/dealer_registration_form_fields.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:go_router/go_router.dart';

export 'artbook_page.dart';
export 'artbook_submit_page.dart';

/// Màn 46–48 — performance registration forms with mint card styling.
class TalentRegistrationPage extends StatefulWidget {
  const TalentRegistrationPage({super.key});

  @override
  State<TalentRegistrationPage> createState() => _TalentRegistrationPageState();
}

class _TalentRegistrationPageState extends State<TalentRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _genreController = TextEditingController();
  final _introController = TextEditingController();
  final _driveController = TextEditingController();
  final _repUrlController = TextEditingController();
  final _memberNameController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _nicknameController.dispose();
    _genreController.dispose();
    _introController.dispose();
    _driveController.dispose();
    _repUrlController.dispose();
    _memberNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    try {
      final response = await sl<TalentApi>().createTalent({
        'title': _titleController.text.trim(),
        'nickname': _nicknameController.text.trim(),
        'representative_url': _repUrlController.text.trim(),
        'participant_count': 1,
        'performance_genre': _genreController.text.trim(),
        'introduction': _introController.text.trim(),
        'duration_minutes': 15,
        'materials_drive_url': _driveController.text.trim(),
        'equipment_notes': '',
        'members': [
          {'name': _memberNameController.text.trim(), 'detail': ''},
        ],
      });
      if (!mounted) return;
      if (response.isSuccess) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã gửi hồ sơ talent')));
        context.go(Routes.accountSubmissions);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.errorMessage ?? response.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Không thể gửi: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollPage(
      title: 'Đăng ký Talent',
      illustratedBackground: true,
      footer: FuvePillButton(
        label: _isSubmitting ? 'Đang gửi...' : 'Gửi hồ sơ talent',
        onPressed: _isSubmitting ? null : _submit,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _PerformanceFormFields(
              titleController: _titleController,
              nicknameController: _nicknameController,
              genreController: _genreController,
              introController: _introController,
              driveController: _driveController,
              repUrlController: _repUrlController,
              memberNameController: _memberNameController,
              enabled: !_isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}

class PanelRegistrationPage extends StatefulWidget {
  const PanelRegistrationPage({super.key});

  @override
  State<PanelRegistrationPage> createState() => _PanelRegistrationPageState();
}

class _PanelRegistrationPageState extends State<PanelRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _genreController = TextEditingController();
  final _introController = TextEditingController();
  final _driveController = TextEditingController();
  final _repUrlController = TextEditingController();
  final _memberNameController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _nicknameController.dispose();
    _genreController.dispose();
    _introController.dispose();
    _driveController.dispose();
    _repUrlController.dispose();
    _memberNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    try {
      final response = await sl<PanelApi>().createPanel({
        'title': _titleController.text.trim(),
        'nickname': _nicknameController.text.trim(),
        'representative_url': _repUrlController.text.trim(),
        'participant_count': 1,
        'performance_genre': _genreController.text.trim(),
        'introduction': _introController.text.trim(),
        'duration_minutes': 30,
        'materials_drive_url': _driveController.text.trim(),
        'equipment_notes': '',
        'members': [
          {'name': _memberNameController.text.trim(), 'detail': ''},
        ],
      });
      if (!mounted) return;
      if (response.isSuccess) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã gửi hồ sơ panel')));
        context.go(Routes.accountSubmissions);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.errorMessage ?? response.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Không thể gửi: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollPage(
      title: 'Đăng ký Panel',
      illustratedBackground: true,
      footer: FuvePillButton(
        label: _isSubmitting ? 'Đang gửi...' : 'Gửi hồ sơ panel',
        onPressed: _isSubmitting ? null : _submit,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _PerformanceFormFields(
              titleController: _titleController,
              nicknameController: _nicknameController,
              genreController: _genreController,
              introController: _introController,
              driveController: _driveController,
              repUrlController: _repUrlController,
              memberNameController: _memberNameController,
              enabled: !_isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}

class DealerRegistrationPage extends StatefulWidget {
  const DealerRegistrationPage({super.key});

  @override
  State<DealerRegistrationPage> createState() => _DealerRegistrationPageState();
}

class _DealerRegistrationPageState extends State<DealerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceSheetUrls = <String>[];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (sl<AuthSessionNotifier>().isAuthenticated) {
        context.go(Routes.accountDealerRegister);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!sl<AuthSessionNotifier>().isAuthenticated) {
      context.go(Routes.login);
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final priceSheetError = validateDealerPriceSheets(_priceSheetUrls);
    if (priceSheetError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(priceSheetError)),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final response = await sl<DealerApi>().registerDealer({
        'booth_name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'price_sheets': List.of(_priceSheetUrls),
      });
      if (!mounted) return;
      if (response.isSuccess) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã gửi đăng ký dealer')));
        context.go(Routes.accountDealer);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.errorMessage ?? response.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Không thể gửi: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollPage(
      title: 'Đăng ký Dealer',
      illustratedBackground: true,
      footer: FuvePillButton(
        label: _isSubmitting ? 'Đang gửi...' : 'Gửi đăng ký',
        onPressed: _isSubmitting ? null : _submit,
      ),
      child: Form(
        key: _formKey,
        child: DealerRegistrationFormFields(
          nameController: _nameController,
          descController: _descController,
          priceSheetUrls: _priceSheetUrls,
          onPriceSheetsChanged: (urls) => setState(() {
            _priceSheetUrls
              ..clear()
              ..addAll(urls);
          }),
          enabled: !_isSubmitting,
        ),
      ),
    );
  }
}

class VolunteerPage extends StatelessWidget {
  const VolunteerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Tình nguyện viên',
      illustratedBackground: true,
      body: AppInfoSection(
        title: 'Đăng ký tình nguyện viên',
        items: const [
          'Thông tin đăng ký tình nguyện viên sẽ được cập nhật sớm.',
          'Theo dõi kênh thông báo chính thức của FUVEKON.',
        ],
      ),
    );
  }
}

class _PerformanceFormFields extends StatelessWidget {
  const _PerformanceFormFields({
    required this.titleController,
    required this.nicknameController,
    required this.genreController,
    required this.introController,
    required this.driveController,
    required this.repUrlController,
    required this.memberNameController,
    required this.enabled,
  });

  final TextEditingController titleController;
  final TextEditingController nicknameController;
  final TextEditingController genreController;
  final TextEditingController introController;
  final TextEditingController driveController;
  final TextEditingController repUrlController;
  final TextEditingController memberNameController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppLabeledField(
          label: 'Tiêu đề tiết mục',
          required: true,
          field: TextFormField(
            controller: titleController,
            enabled: enabled,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập tiêu đề' : null,
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'Nickname',
          required: true,
          field: TextFormField(
            controller: nicknameController,
            enabled: enabled,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập nickname' : null,
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'Thể loại',
          required: true,
          field: TextFormField(
            controller: genreController,
            enabled: enabled,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập thể loại' : null,
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'Giới thiệu',
          required: true,
          field: TextFormField(
            controller: introController,
            enabled: enabled,
            maxLines: 4,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập giới thiệu' : null,
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'URL ảnh đại diện',
          required: true,
          field: TextFormField(
            controller: repUrlController,
            enabled: enabled,
            keyboardType: TextInputType.url,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Nhập URL ảnh';
              if (!v.startsWith('http')) return 'URL không hợp lệ';
              return null;
            },
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'Link tài liệu (Google Drive)',
          required: true,
          field: TextFormField(
            controller: driveController,
            enabled: enabled,
            keyboardType: TextInputType.url,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Nhập link tài liệu';
              if (!v.startsWith('http')) return 'URL không hợp lệ';
              return null;
            },
          ),
        ),
        const SizedBox(height: FuvekonSpacing.field),
        AppLabeledField(
          label: 'Tên thành viên',
          required: true,
          field: TextFormField(
            controller: memberNameController,
            enabled: enabled,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập tên thành viên' : null,
          ),
        ),
      ],
    );
  }
}
