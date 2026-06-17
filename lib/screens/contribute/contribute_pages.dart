import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/api/conbook_api.dart';
import 'package:fuvekonmobile/core/api/dealer_api.dart';
import 'package:fuvekonmobile/core/api/panel_api.dart';
import 'package:fuvekonmobile/core/api/talent_api.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:go_router/go_router.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi hồ sơ talent')),
        );
        context.go(Routes.accountSubmissions);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.errorMessage ?? response.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể gửi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollPage(
      title: 'Đăng ký Talent',
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
      footer: FuvePillButton(
        label: _isSubmitting ? 'Đang gửi...' : 'Gửi hồ sơ talent',
        onPressed: _isSubmitting ? null : _submit,
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi hồ sơ panel')),
        );
        context.go(Routes.accountSubmissions);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.errorMessage ?? response.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể gửi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollPage(
      title: 'Đăng ký Panel',
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
      footer: FuvePillButton(
        label: _isSubmitting ? 'Đang gửi...' : 'Gửi hồ sơ panel',
        onPressed: _isSubmitting ? null : _submit,
      ),
    );
  }
}

class ArtbookSubmissionPage extends StatefulWidget {
  const ArtbookSubmissionPage({super.key});

  @override
  State<ArtbookSubmissionPage> createState() => _ArtbookSubmissionPageState();
}

class _ArtbookSubmissionPageState extends State<ArtbookSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _handleController = TextEditingController();
  final _descController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _handleController.dispose();
    _descController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    try {
      await sl<ConbookApi>().upload({
        'title': _titleController.text.trim(),
        'handle': _handleController.text.trim(),
        'description': _descController.text.trim(),
        'image_url': _imageUrlController.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi ảnh conbook')),
      );
      context.go(Routes.accountSubmissions);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể gửi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollPage(
      title: 'Gửi Conbook',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppLabeledField(
              label: 'Tiêu đề',
              required: true,
              field: TextFormField(
                controller: _titleController,
                enabled: !_isSubmitting,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nhập tiêu đề' : null,
              ),
            ),
            const SizedBox(height: FuvekonSpacing.field),
            AppLabeledField(
              label: 'Handle / tên nghệ danh',
              required: true,
              field: TextFormField(
                controller: _handleController,
                enabled: !_isSubmitting,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nhập handle' : null,
              ),
            ),
            const SizedBox(height: FuvekonSpacing.field),
            AppLabeledField(
              label: 'Mô tả',
              field: TextFormField(
                controller: _descController,
                enabled: !_isSubmitting,
                maxLines: 3,
              ),
            ),
            const SizedBox(height: FuvekonSpacing.field),
            AppLabeledField(
              label: 'URL ảnh',
              required: true,
              field: TextFormField(
                controller: _imageUrlController,
                enabled: !_isSubmitting,
                keyboardType: TextInputType.url,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Nhập URL ảnh';
                  if (!v.startsWith('http')) return 'URL không hợp lệ';
                  return null;
                },
              ),
            ),
            const SizedBox(height: FuvekonSpacing.field),
            const AppUploadZone(label: 'Hoặc tải ảnh lên (S3 — sắp có)'),
          ],
        ),
      ),
      footer: FuvePillButton(
        label: _isSubmitting ? 'Đang gửi...' : 'Gửi conbook',
        onPressed: _isSubmitting ? null : _submit,
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
  final _priceSheetController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceSheetController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    try {
      final response = await sl<DealerApi>().registerDealer({
        'booth_name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'price_sheets': [_priceSheetController.text.trim()],
      });
      if (!mounted) return;
      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi đăng ký dealer')),
        );
        context.go(Routes.accountDealer);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.errorMessage ?? response.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể gửi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollPage(
      title: 'Đăng ký Dealer',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppLabeledField(
              label: 'Tên gian hàng',
              required: true,
              field: TextFormField(
                controller: _nameController,
                enabled: !_isSubmitting,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nhập tên gian hàng' : null,
              ),
            ),
            const SizedBox(height: FuvekonSpacing.field),
            AppLabeledField(
              label: 'Mô tả',
              required: true,
              field: TextFormField(
                controller: _descController,
                enabled: !_isSubmitting,
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nhập mô tả' : null,
              ),
            ),
            const SizedBox(height: FuvekonSpacing.field),
            AppLabeledField(
              label: 'URL bảng giá',
              required: true,
              field: TextFormField(
                controller: _priceSheetController,
                enabled: !_isSubmitting,
                keyboardType: TextInputType.url,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Nhập URL bảng giá';
                  if (!v.startsWith('http')) return 'URL không hợp lệ';
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      footer: FuvePillButton(
        label: _isSubmitting ? 'Đang gửi...' : 'Gửi đăng ký',
        onPressed: _isSubmitting ? null : _submit,
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
