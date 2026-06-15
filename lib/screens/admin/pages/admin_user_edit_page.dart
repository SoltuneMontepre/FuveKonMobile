import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_user_service.dart';
import 'package:go_router/go_router.dart';

const _roleOptions = ['User', 'Admin', 'Dealer', 'Staff'];

class AdminUserEditPage extends StatefulWidget {
  const AdminUserEditPage({super.key, required this.userId});

  final String userId;

  @override
  State<AdminUserEditPage> createState() => _AdminUserEditPageState();
}

class _AdminUserEditPageState extends State<AdminUserEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final AdminUserService _service;

  late final TextEditingController _fursonaController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _countryController;
  late final TextEditingController _idCardController;
  late final TextEditingController _avatarController;

  AdminUserItem? _user;
  String? _error;
  bool _loading = true;
  bool _saving = false;
  late String _role;
  late bool _isVerified;

  @override
  void initState() {
    super.initState();
    _service = sl<AdminUserService>();
    _fursonaController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _countryController = TextEditingController();
    _idCardController = TextEditingController();
    _avatarController = TextEditingController();
    _role = 'User';
    _isVerified = false;
    _load();
  }

  @override
  void dispose() {
    _fursonaController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _idCardController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = await _service.getUserById(widget.userId);
      if (!mounted) return;
      _fursonaController.text = user.fursonaName ?? '';
      _firstNameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _countryController.text = user.country ?? '';
      _idCardController.text = user.idCard ?? '';
      _avatarController.text = user.avatar ?? '';
      setState(() {
        _user = user;
        _role = _roleOptions.contains(user.role) ? user.role : 'User';
        _isVerified = user.isVerified;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('ServerException: ', '');
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    try {
      await _service.updateUser(
        widget.userId,
        AdminUpdateUserInput(
          fursonaName: _fursonaController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          country: _countryController.text.trim(),
          idCard: _idCardController.text.trim(),
          avatar: _avatarController.text.trim(),
          role: _role,
          isVerified: _isVerified,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công.')),
      );
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('ServerException: ', 'Lỗi: '),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa người dùng'),
        actions: [
          if (!_loading && _error == null)
            TextButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Lưu'),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _load,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final user = _user!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(FuvekonSpacing.page),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: user.email,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fursonaController,
              enabled: !_saving,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Fursona',
                prefixIcon: Icon(Icons.pets_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _firstNameController,
              enabled: !_saving,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Họ',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              enabled: !_saving,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Tên',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _countryController,
              enabled: !_saving,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Quốc gia',
                prefixIcon: Icon(Icons.public_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _idCardController,
              enabled: !_saving,
              decoration: const InputDecoration(
                labelText: 'CCCD/CMND',
                prefixIcon: Icon(Icons.credit_card_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _avatarController,
              enabled: !_saving,
              decoration: const InputDecoration(
                labelText: 'Ảnh đại diện (URL)',
                prefixIcon: Icon(Icons.image_outlined),
              ),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return null;
                final uri = Uri.tryParse(trimmed);
                if (uri == null || !uri.hasScheme) {
                  return 'URL không hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: ValueKey(_role),
              initialValue: _role,
              decoration: const InputDecoration(
                labelText: 'Vai trò',
                prefixIcon: Icon(Icons.admin_panel_settings_outlined),
              ),
              items: [
                for (final role in _roleOptions)
                  DropdownMenuItem(
                    value: role,
                    child: Text(adminRoleLabel(role)),
                  ),
              ],
              onChanged: _saving
                  ? null
                  : (value) {
                      if (value != null) setState(() => _role = value);
                    },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Đã xác minh'),
              subtitle: const Text('Tài khoản đã được xác minh email'),
              value: _isVerified,
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _isVerified = value),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}
