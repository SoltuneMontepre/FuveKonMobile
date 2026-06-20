import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_user_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_user_access_widgets.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image_upload_field.dart';
import 'package:go_router/go_router.dart';

class AdminUserEditPage extends StatefulWidget {
  const AdminUserEditPage({
    super.key,
    required this.userId,
    this.focusPermissions = false,
  });

  final String userId;
  final bool focusPermissions;

  @override
  State<AdminUserEditPage> createState() => _AdminUserEditPageState();
}

class _AdminUserEditPageState extends State<AdminUserEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _permissionsSectionKey = GlobalKey();
  late final AdminUserService _service;

  late final TextEditingController _fursonaController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _countryController;
  late final TextEditingController _idCardController;

  AdminUserItem? _user;
  String? _avatarUrl;
  String? _error;
  bool _loading = true;
  bool _saving = false;
  late String _role;
  late bool _isVerified;
  late List<String> _permissions;

  @override
  void initState() {
    super.initState();
    _service = sl<AdminUserService>();
    _fursonaController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _countryController = TextEditingController();
    _idCardController = TextEditingController();
    _role = 'User';
    _isVerified = false;
    _permissions = const [];
    _load();
  }

  @override
  void dispose() {
    _fursonaController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _idCardController.dispose();
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
      setState(() {
        _user = user;
        _avatarUrl = user.avatar;
        _role = adminRoleOptions.contains(user.role) ? user.role : 'User';
        _isVerified = user.isVerified;
        _permissions = isAdminRole(_role)
            ? List<String>.from(adminPermissionCodes)
            : List<String>.from(user.permissions);
        _loading = false;
      });
      if (widget.focusPermissions) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToPermissions();
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = formatAdminError(context.l10n, e);
        _loading = false;
      });
    }
  }

  void _selectRole(String role) {
    if (_saving || role == _role) return;
    setState(() {
      _role = role;
      _permissions = List<String>.from(defaultPermissionsForRole(role));
    });
  }

  void _scrollToPermissions() {
    final targetContext = _permissionsSectionKey.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.08,
    );
  }

  void _togglePermission(String code) {
    if (_saving || isAdminRole(_role)) return;

    final next = Set<String>.from(_permissions);
    if (next.contains(code)) {
      next.remove(code);
    } else {
      next.add(code);
    }
    setState(() {
      _permissions = adminPermissionCodes
          .where((item) => next.contains(item))
          .toList();
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = context.l10n;
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
          avatar: _avatarUrl?.trim() ?? '',
          role: _role,
          isVerified: _isVerified,
          permissions: isAdminRole(_role) ? null : _permissions,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.adminUpdateSuccess)));
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(formatAdminError(l10n, e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.focusPermissions
              ? l10n.adminUserEditPermissions
              : l10n.adminUserEditTitle,
        ),
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
                  : Text(l10n.adminSave),
            ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
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
                child: Text(l10n.adminRetry),
              ),
            ],
          ),
        ),
      );
    }

    final user = _user!;
    final effectivePermissions = isAdminRole(_role)
        ? adminPermissionCodes
        : _permissions;
    final inputTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(FuvekonSpacing.page),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdminUserProfileHeader(
              displayName: user.displayName,
              email: user.email,
              avatarUrl: _avatarUrl ?? user.avatar,
              initials: user.initials,
              role: _role,
            ),
            const SizedBox(height: FuvekonSpacing.section),
            AdminUserEditSectionCard(
              title: l10n.adminUserEditPersonalInfo,
              subtitle: l10n.adminUserEditPersonalSubtitle,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: user.email,
                    readOnly: true,
                    style: inputTextStyle,
                    decoration: InputDecoration(
                      labelText: l10n.adminFieldEmail,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _fursonaController,
                    enabled: !_saving,
                    style: inputTextStyle,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l10n.adminFieldFursona,
                      prefixIcon: const Icon(Icons.pets_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          enabled: !_saving,
                          style: inputTextStyle,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: l10n.adminFieldFirstName,
                            prefixIcon: const Icon(Icons.badge_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          enabled: !_saving,
                          style: inputTextStyle,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: l10n.adminFieldLastName,
                            prefixIcon: const Icon(Icons.badge_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _countryController,
                    enabled: !_saving,
                    style: inputTextStyle,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l10n.adminFieldCountry,
                      prefixIcon: const Icon(Icons.public_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _idCardController,
                    enabled: !_saving,
                    style: inputTextStyle,
                    decoration: InputDecoration(
                      labelText: l10n.adminFieldIdCard,
                      prefixIcon: const Icon(Icons.credit_card_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  S3ImageUploadField(
                    imageUrl: _avatarUrl,
                    folder: 'avatars',
                    label: l10n.adminFieldAvatar,
                    enabled: !_saving,
                    onChanged: (url) => setState(() => _avatarUrl = url),
                  ),
                ],
              ),
            ),
            const SizedBox(height: FuvekonSpacing.section),
            AdminUserEditSectionCard(
              title: l10n.adminUserEditAccountStatus,
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.adminUserEditVerified),
                subtitle: Text(l10n.adminUserEditVerifiedSubtitle),
                value: _isVerified,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _isVerified = value),
              ),
            ),
            const SizedBox(height: FuvekonSpacing.section),
            KeyedSubtree(
              key: _permissionsSectionKey,
              child: AdminUserSectionTitle(title: l10n.adminUserEditRoles),
            ),
            const SizedBox(height: 12),
            AdminUserRoleGrid(
              selectedRole: _role,
              enabled: !_saving,
              onRoleSelected: _selectRole,
            ),
            const SizedBox(height: FuvekonSpacing.section),
            AdminUserSectionTitle(title: l10n.adminUserEditPermissionGroup),
            const SizedBox(height: 12),
            AdminUserPermissionGroup(
              permissions: effectivePermissions,
              enabled: !_saving && !isAdminRole(_role),
              onToggle: _togglePermission,
            ),
            if (isAdminRole(_role)) ...[
              const SizedBox(height: 8),
              Text(
                l10n.adminUserEditAdminNote,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              ),
            ],
            const SizedBox(height: FuvekonSpacing.section),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.adminSaveChanges),
            ),
          ],
        ),
      ),
    );
  }
}
