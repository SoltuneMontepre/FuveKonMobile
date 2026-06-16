import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_user_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_user_access_widgets.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_user_ticket_widgets.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:go_router/go_router.dart';

class AdminUserDetailPage extends StatefulWidget {
  const AdminUserDetailPage({super.key, required this.userId});

  final String userId;

  @override
  State<AdminUserDetailPage> createState() => _AdminUserDetailPageState();
}

class _AdminUserDetailPageState extends State<AdminUserDetailPage> {
  late final AdminUserService _service;
  AdminUserItem? _user;
  String? _error;
  bool _loading = true;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _service = sl<AdminUserService>();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = await _service.getUserById(widget.userId);
      if (!mounted) return;
      setState(() {
        _user = user;
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

  Future<void> _runAction(Future<void> Function() action) async {
    setState(() => _actionInProgress = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công.')),
      );
      await _load();
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
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa người dùng?'),
        content: const Text(
          'Tài khoản sẽ bị xóa mềm và không thể đăng nhập lại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF0A0A8),
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await _runAction(() async {
      await _service.deleteUser(widget.userId);
      if (mounted) context.pop();
    });
  }

  Future<void> _blacklistUser() async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cấm mua vé'),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Lý do cấm',
            hintText: 'Nhập lý do cấm người dùng...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cấm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final reason = reasonController.text.trim();
    if (reason.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập lý do cấm.')),
      );
      return;
    }

    await _runAction(
      () => _service.blacklistUser(widget.userId, reason: reason),
    );
  }

  Future<void> _openEdit() async {
    final updated = await context.push<bool>(Routes.adminUserEdit(widget.userId));
    if (updated == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = _user != null && !_user!.isDeleted;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết người dùng'),
        actions: [
          if (canEdit)
            IconButton(
              onPressed: _actionInProgress ? null : _openEdit,
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Chỉnh sửa',
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
    final effectivePermissions = isAdminRole(user.role)
        ? adminPermissionCodes
        : user.permissions;

    return ListView(
      padding: const EdgeInsets.all(FuvekonSpacing.page),
      children: [
        AdminUserProfileHeader(
          displayName: user.displayName,
          email: user.email,
          avatarUrl: user.avatar,
          initials: user.initials,
          role: user.role,
        ),
        const SizedBox(height: FuvekonSpacing.section),
        _UserDetailsSection(
          user: user,
          permissionsSummary: formatAdminPermissionsSummary(effectivePermissions),
        ),
        const SizedBox(height: FuvekonSpacing.section),
        AdminUserTicketSection(
          userId: user.id,
          userEmail: user.email,
          isDeleted: user.isDeleted,
          onTicketChanged: _load,
        ),
        const SizedBox(height: 12),
        if (!user.isVerified && !user.isDeleted)
          _ActionButton(
            label: 'Xác minh tài khoản',
            color: FuvekonColors.available,
            loading: _actionInProgress,
            onPressed: () => _runAction(() => _service.verifyUser(user.id)),
          ),
        if (!user.isBlacklisted && !user.isDeleted)
          _ActionButton(
            label: 'Cấm mua vé',
            color: const Color(0xFFFBBF24),
            loading: _actionInProgress,
            onPressed: _blacklistUser,
          ),
        if (user.isBlacklisted)
          _ActionButton(
            label: 'Gỡ cấm mua vé',
            color: FuvekonColors.available,
            loading: _actionInProgress,
            onPressed: () =>
                _runAction(() => _service.unblacklistUser(user.id)),
          ),
        if (!user.isDeleted)
          _ActionButton(
            label: 'Xóa người dùng',
            color: const Color(0xFFF0A0A8),
            loading: _actionInProgress,
            onPressed: _confirmDelete,
          ),
      ],
    );
  }
}

class _UserDetailsSection extends StatelessWidget {
  const _UserDetailsSection({
    required this.user,
    required this.permissionsSummary,
  });

  final AdminUserItem user;
  final String permissionsSummary;

  @override
  Widget build(BuildContext context) {
    final fields = user.details
        .where((field) => field.label != 'Vai trò' && field.label != 'Email')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final field in fields) _DetailField(field: field),
        _DetailField(
          field: AdminDetailField(
            label: 'Vai trò',
            value:
                '${adminRoleTitle(user.role)} (${adminRoleSubtitle(user.role)})',
          ),
        ),
        _DetailField(
          field: AdminDetailField(
            label: 'Quyền',
            value: permissionsSummary,
          ),
        ),
      ],
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({required this.field});

  final AdminDetailField field;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
          ),
          const SizedBox(height: 4),
          if (field.imageUrl != null)
            S3Image(
              imageUrl: field.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.circular(12),
              onTap: () => showS3ImagePreview(context, field.imageUrl!),
            )
          else if (field.value.isNotEmpty)
            Text(
              field.value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FuvekonColors.darkText,
                  ),
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: loading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color,
            foregroundColor: FuvekonColors.darkCardText,
          ),
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(label),
        ),
      ),
    );
  }
}
