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
import 'package:intl/intl.dart';

class AdminUserDetailPage extends StatefulWidget {
  const AdminUserDetailPage({super.key, required this.userId});

  final String userId;

  @override
  State<AdminUserDetailPage> createState() => _AdminUserDetailPageState();
}

class _AdminUserDetailPageState extends State<AdminUserDetailPage> {
  late final AdminUserService _service;
  final _ticketSectionKey = GlobalKey();
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

  void _scrollToTickets() {
    final ticketContext = _ticketSectionKey.currentContext;
    if (ticketContext == null) return;
    Scrollable.ensureVisible(
      ticketContext,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      alignment: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = _user != null && !_user!.isDeleted;
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      appBar: AppBar(
        backgroundColor: FuvekonColors.darkBg,
        foregroundColor: FuvekonColors.darkText,
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
      padding: const EdgeInsets.fromLTRB(
        FuvekonSpacing.page,
        8,
        FuvekonSpacing.page,
        FuvekonSpacing.page,
      ),
      children: [
        AdminUserProfileHeader(
          detailStyle: true,
          displayName: user.displayName,
          email: user.email,
          avatarUrl: user.avatar,
          initials: user.initials,
          role: user.role,
          isVerified: user.isVerified,
          isBlacklisted: user.isBlacklisted,
          isDeleted: user.isDeleted,
          country: user.country,
        ),
        const SizedBox(height: FuvekonSpacing.section),
        if (!user.isDeleted) ...[
          _QuickActionsSection(
            loading: _actionInProgress,
            isVerified: user.isVerified,
            isBlacklisted: user.isBlacklisted,
            onEdit: _openEdit,
            onViewTickets: _scrollToTickets,
            onVerify: () => _runAction(() => _service.verifyUser(user.id)),
            onBlacklist: _blacklistUser,
            onUnblacklist: () =>
                _runAction(() => _service.unblacklistUser(user.id)),
            onDelete: _confirmDelete,
          ),
          const SizedBox(height: FuvekonSpacing.section),
        ],
        _UserActivitySection(user: user),
        const SizedBox(height: FuvekonSpacing.section),
        _UserDetailsSection(
          user: user,
          permissionsSummary: formatAdminPermissionsSummary(effectivePermissions),
        ),
        const SizedBox(height: FuvekonSpacing.section),
        KeyedSubtree(
          key: _ticketSectionKey,
          child: AdminUserTicketSection(
            userId: user.id,
            userEmail: user.email,
            isDeleted: user.isDeleted,
            onTicketChanged: _load,
          ),
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection({
    required this.loading,
    required this.isVerified,
    required this.isBlacklisted,
    required this.onEdit,
    required this.onViewTickets,
    required this.onVerify,
    required this.onBlacklist,
    required this.onUnblacklist,
    required this.onDelete,
  });

  final bool loading;
  final bool isVerified;
  final bool isBlacklisted;
  final VoidCallback onEdit;
  final VoidCallback onViewTickets;
  final VoidCallback onVerify;
  final VoidCallback onBlacklist;
  final VoidCallback onUnblacklist;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AdminUserSectionTitle(title: 'Thao tác nhanh'),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.55,
          children: [
            _QuickActionCard(
              icon: Icons.confirmation_number_outlined,
              label: 'Xem vé',
              variant: _QuickActionVariant.primary,
              onTap: loading ? null : onViewTickets,
            ),
            if (!isVerified)
              _QuickActionCard(
                icon: Icons.verified_outlined,
                label: 'Xác minh',
                variant: _QuickActionVariant.primary,
                onTap: loading ? null : onVerify,
              )
            else
              _QuickActionCard(
                icon: Icons.edit_outlined,
                label: 'Chỉnh sửa',
                variant: _QuickActionVariant.primary,
                onTap: loading ? null : onEdit,
              ),
            _QuickActionCard(
              icon: Icons.admin_panel_settings_outlined,
              label: 'Phân quyền',
              variant: _QuickActionVariant.secondary,
              onTap: loading ? null : onEdit,
            ),
            if (isBlacklisted)
              _QuickActionCard(
                icon: Icons.lock_open_rounded,
                label: 'Gỡ cấm',
                variant: _QuickActionVariant.secondary,
                onTap: loading ? null : onUnblacklist,
              )
            else
              _QuickActionCard(
                icon: Icons.lock_outline_rounded,
                label: 'Cấm mua vé',
                variant: _QuickActionVariant.destructive,
                onTap: loading ? null : onBlacklist,
              ),
          ],
        ),
        const SizedBox(height: 10),
        _QuickActionCard(
          icon: Icons.delete_outline_rounded,
          label: 'Xóa người dùng',
          variant: _QuickActionVariant.destructive,
          fullWidth: true,
          onTap: loading ? null : onDelete,
        ),
      ],
    );
  }
}

enum _QuickActionVariant { primary, secondary, destructive }

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.variant,
    this.onTap,
    this.fullWidth = false,
  });

  final IconData icon;
  final String label;
  final _QuickActionVariant variant;
  final VoidCallback? onTap;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrimary = variant == _QuickActionVariant.primary;
    final isDestructive = variant == _QuickActionVariant.destructive;

    final bg = isPrimary
        ? FuvekonColors.darkCard
        : FuvekonColors.darkSurfaceElevated;
    final fg = isDestructive
        ? const Color(0xFFF0A0A8)
        : isPrimary
            ? FuvekonColors.darkCardText
            : FuvekonColors.darkText;

    final card = Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            if (isPrimary)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(12),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: FuvekonColors.tier3.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                      right: BorderSide(
                        color: FuvekonColors.tier3.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: fullWidth ? 16 : 14,
                vertical: fullWidth ? 14 : 16,
              ),
              child: fullWidth
                  ? Row(
                      children: [
                        Icon(icon, color: fg, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          label,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: fg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, color: fg, size: 24),
                        const Spacer(),
                        Text(
                          label,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: fg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );

    if (fullWidth) return card;
    return card;
  }
}

class _UserActivitySection extends StatelessWidget {
  const _UserActivitySection({required this.user});

  final AdminUserItem user;

  @override
  Widget build(BuildContext context) {
    final events = _buildEvents();
    if (events.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: AdminUserSectionTitle(title: 'Lịch sử gần đây'),
            ),
            Text(
              '${events.length} sự kiện',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: FuvekonColors.darkTextSecondary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: FuvekonColors.darkSurfaceElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: FuvekonColors.darkBorder.withValues(alpha: 0.6),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (var i = 0; i < events.length; i++)
                  _ActivityTimelineTile(
                    event: events[i],
                    isLast: i == events.length - 1,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<_ActivityEvent> _buildEvents() {
    final events = <_ActivityEvent>[];

    if (user.blacklistedAt != null) {
      events.add(
        _ActivityEvent(
          at: user.blacklistedAt!,
          title: 'Bị cấm mua vé',
          subtitle: user.blacklistReason?.isNotEmpty == true
              ? user.blacklistReason!
              : 'Tài khoản bị hạn chế mua vé.',
          tag: 'CẤM',
          dotColor: const Color(0xFFFBBF24),
        ),
      );
    }

    if (user.isHasTicket) {
      events.add(
        _ActivityEvent(
          at: user.createdAt ?? DateTime.now(),
          title: 'Có vé sự kiện',
          subtitle: 'Người dùng đã đăng ký hoặc được cấp vé.',
          tag: 'VÉ',
          dotColor: FuvekonColors.available,
        ),
      );
    }

    if (user.isVerified) {
      events.add(
        _ActivityEvent(
          at: user.createdAt ?? DateTime.now(),
          title: 'Đã xác minh',
          subtitle: 'Tài khoản đã được xác minh danh tính.',
          tag: 'XÁC MINH',
          dotColor: FuvekonColors.available,
        ),
      );
    }

    if (user.createdAt != null) {
      events.add(
        _ActivityEvent(
          at: user.createdAt!,
          title: 'Tạo tài khoản',
          subtitle: 'Đăng ký tài khoản trên hệ thống.',
          tag: 'MỚI',
          dotColor: FuvekonColors.darkTextSecondary,
        ),
      );
    }

    events.sort((a, b) => b.at.compareTo(a.at));
    return events.take(4).toList();
  }
}

class _ActivityEvent {
  const _ActivityEvent({
    required this.at,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.dotColor,
  });

  final DateTime at;
  final String title;
  final String subtitle;
  final String tag;
  final Color dotColor;
}

class _ActivityTimelineTile extends StatelessWidget {
  const _ActivityTimelineTile({
    required this.event,
    required this.isLast,
  });

  final _ActivityEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFmt = DateFormat('HH:mm');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: event.dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: FuvekonColors.darkBorder,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: FuvekonColors.darkText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        timeFmt.format(event.at),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: FuvekonColors.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: FuvekonColors.darkBg.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: FuvekonColors.darkBorder.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Text(
                      event.tag,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: FuvekonColors.darkTextSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
        .where(
          (field) =>
              field.label != 'Vai trò' &&
              field.label != 'Email' &&
              field.label != 'Tên hiển thị' &&
              field.label != 'Xác minh' &&
              field.label != 'Ảnh đại diện',
        )
        .toList();

    return AdminUserEditSectionCard(
      title: 'Thông tin chi tiết',
      subtitle: 'Hồ sơ, quyền hạn và trạng thái tài khoản',
      child: Column(
        children: [
          _DetailInfoRow(
            label: 'Vai trò',
            value:
                '${adminRoleTitle(user.role)} · ${adminRoleSubtitle(user.role)}',
          ),
          _DetailInfoRow(label: 'Quyền', value: permissionsSummary),
          for (var i = 0; i < fields.length; i++) ...[
            if (i == 0 || fields[i - 1].label != fields[i].label)
              _DetailField(field: fields[i]),
          ],
          if (user.avatar?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ảnh đại diện',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            S3Image(
              imageUrl: user.avatar,
              height: 160,
              width: 160,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(16),
              onTap: () => showS3ImagePreview(context, user.avatar!),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  const _DetailInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: FuvekonColors.darkTextSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FuvekonColors.darkText,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({required this.field});

  final AdminDetailField field;

  @override
  Widget build(BuildContext context) {
    if (field.imageUrl != null) return const SizedBox.shrink();

    return _DetailInfoRow(
      label: field.label,
      value: field.value.isNotEmpty ? field.value : '—',
    );
  }
}
