import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_ticket_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_user_access_widgets.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';

const _tshirtSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL'];

class AdminUserTicketSection extends StatefulWidget {
  const AdminUserTicketSection({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.isDeleted,
    this.onTicketChanged,
  });

  final String userId;
  final String userEmail;
  final bool isDeleted;
  final VoidCallback? onTicketChanged;

  @override
  State<AdminUserTicketSection> createState() => _AdminUserTicketSectionState();
}

class _AdminUserTicketSectionState extends State<AdminUserTicketSection> {
  late final AdminTicketService _ticketService;

  AdminTicketItem? _ticket;
  List<AdminTicketTierItem> _tiers = const [];
  bool _loading = true;
  String? _error;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _ticketService = sl<AdminTicketService>();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _ticketService.findActiveUserTicket(
          userId: widget.userId,
          email: widget.userEmail,
        ),
        _ticketService.getTiers(),
      ]);
      if (!mounted) return;
      setState(() {
        _ticket = results[0] as AdminTicketItem?;
        _tiers = results[1] as List<AdminTicketTierItem>;
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

  Future<void> _runAction(
    Future<void> Function() action, {
    required String successMessage,
  }) async {
    setState(() => _actionInProgress = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
      await _load();
      widget.onTicketChanged?.call();
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

  Future<void> _grantTicket() async {
    if (_tiers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có hạng vé để cấp.')),
      );
      return;
    }

    final tierId = await showDialog<String>(
      context: context,
      builder: (context) => _GrantTicketDialog(tiers: _tiers),
    );
    if (tierId == null || !mounted) return;

    await _runAction(
      () => _ticketService.createTicketForUser(
        userId: widget.userId,
        tierId: tierId,
      ),
      successMessage: 'Đã cấp vé cho người dùng.',
    );
  }

  Future<String?> _promptDenyReason() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lý do từ chối'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nhập lý do từ chối vé...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Từ chối'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteTicket(AdminTicketItem ticket) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa vé?'),
        content: Text(
          'Xóa vé ${ticket.referenceCode}? Hành động không thể hoàn tác.',
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
    await _runAction(
      () => _ticketService.deleteTicket(ticket.id),
      successMessage: 'Đã xóa vé.',
    );
  }

  Future<void> _openEditTicket(AdminTicketItem ticket) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _EditTicketSheet(
        ticket: ticket,
        tiers: _tiers,
        onSave: (input) => _ticketService.updateTicket(ticket.id, input),
      ),
    );
    if (saved == true) {
      await _load();
      widget.onTicketChanged?.call();
    }
  }

  void _showTicketDetail(AdminTicketItem ticket) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.35,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: FuvekonColors.darkBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ticket.referenceCode,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: FuvekonColors.darkText,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      AdminTicketStatusChip(status: ticket.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        for (final field in ticket.details)
                          _TicketDetailField(field: field),
                      ],
                    ),
                  ),
                  if (!widget.isDeleted) ...[
                    if (ticket.canApprove)
                      _TicketActionButton(
                        label: 'Duyệt vé',
                        color: FuvekonColors.available,
                        loading: _actionInProgress,
                        onPressed: () async {
                          Navigator.pop(context);
                          await _runAction(
                            () => _ticketService.approveTicket(ticket.id),
                            successMessage: 'Đã duyệt vé.',
                          );
                        },
                      ),
                    if (ticket.canDeny)
                      _TicketActionButton(
                        label: 'Từ chối vé',
                        color: const Color(0xFFF0A0A8),
                        loading: _actionInProgress,
                        onPressed: () async {
                          final reason = await _promptDenyReason();
                          if (!context.mounted || reason == null) return;
                          Navigator.pop(context);
                          await _runAction(
                            () => _ticketService.denyTicket(
                              ticket.id,
                              reason: reason,
                            ),
                            successMessage: 'Đã từ chối vé.',
                          );
                        },
                      ),
                    if (ticket.canResendQr)
                      _TicketActionButton(
                        label: 'Gửi lại email QR',
                        color: const Color(0xFF60A5FA),
                        loading: _actionInProgress,
                        onPressed: () async {
                          Navigator.pop(context);
                          await _runAction(
                            () => _ticketService.resendQrEmail(ticket.id),
                            successMessage: 'Đã gửi lại email QR.',
                          );
                        },
                      ),
                    _TicketActionButton(
                      label: 'Chỉnh sửa vé',
                      color: FuvekonColors.primary,
                      loading: _actionInProgress,
                      onPressed: () {
                        Navigator.pop(context);
                        _openEditTicket(ticket);
                      },
                    ),
                    _TicketActionButton(
                      label: 'Xóa vé',
                      color: const Color(0xFFDC2626),
                      loading: _actionInProgress,
                      onPressed: () {
                        Navigator.pop(context);
                        _confirmDeleteTicket(ticket);
                      },
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminUserEditSectionCard(
      title: 'Vé của người dùng',
      subtitle: 'Cấp, duyệt, chỉnh sửa hoặc xóa vé',
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Column(
        children: [
          Text(
            _error!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _load,
            child: const Text('Thử lại'),
          ),
        ],
      );
    }

    if (_ticket == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Người dùng chưa có vé.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
          ),
          if (!widget.isDeleted) ...[
            const SizedBox(height: 12),
            _TicketActionButton(
              label: 'Cấp vé',
              color: FuvekonColors.available,
              loading: _actionInProgress,
              onPressed: _grantTicket,
            ),
          ],
        ],
      );
    }

    final ticket = _ticket!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TicketSummaryRow(
          label: 'Mã vé',
          value: ticket.referenceCode,
        ),
        if (ticket.tierName?.isNotEmpty == true)
          _TicketSummaryRow(label: 'Hạng vé', value: ticket.tierName!),
        _TicketSummaryRow(
          label: 'Trạng thái',
          value: ticketStatusLabelVi(ticket.status),
        ),
        _TicketSummaryRow(
          label: 'Check-in',
          value: ticket.isCheckedIn ? 'Đã check-in' : 'Chưa check-in',
        ),
        const SizedBox(height: 12),
        _TicketActionButton(
          label: 'Quản lý vé',
          color: FuvekonColors.primary,
          loading: _actionInProgress,
          onPressed: () => _showTicketDetail(ticket),
        ),
      ],
    );
  }
}

class AdminTicketStatusChip extends StatelessWidget {
  const AdminTicketStatusChip({super.key, required this.status});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    final color = ticketStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        ticketStatusLabelVi(status),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _TicketSummaryRow extends StatelessWidget {
  const _TicketSummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
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

class _TicketDetailField extends StatelessWidget {
  const _TicketDetailField({required this.field});

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

class _TicketActionButton extends StatelessWidget {
  const _TicketActionButton({
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

class _GrantTicketDialog extends StatefulWidget {
  const _GrantTicketDialog({required this.tiers});

  final List<AdminTicketTierItem> tiers;

  @override
  State<_GrantTicketDialog> createState() => _GrantTicketDialogState();
}

class _GrantTicketDialogState extends State<_GrantTicketDialog> {
  String? _selectedTierId;

  @override
  void initState() {
    super.initState();
    if (widget.tiers.isNotEmpty) {
      _selectedTierId = widget.tiers.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cấp vé'),
      content: DropdownButtonFormField<String>(
        value: _selectedTierId,
        decoration: const InputDecoration(labelText: 'Hạng vé'),
        items: [
          for (final tier in widget.tiers)
            DropdownMenuItem(
              value: tier.id,
              child: Text('${tier.ticketName} (${tier.tierCode})'),
            ),
        ],
        onChanged: (value) => setState(() => _selectedTierId = value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: _selectedTierId == null
              ? null
              : () => Navigator.pop(context, _selectedTierId),
          child: const Text('Cấp vé'),
        ),
      ],
    );
  }
}

class _EditTicketSheet extends StatefulWidget {
  const _EditTicketSheet({
    required this.ticket,
    required this.tiers,
    required this.onSave,
  });

  final AdminTicketItem ticket;
  final List<AdminTicketTierItem> tiers;
  final Future<AdminTicketItem> Function(AdminTicketUpdateInput input) onSave;

  @override
  State<_EditTicketSheet> createState() => _EditTicketSheetState();
}

class _EditTicketSheetState extends State<_EditTicketSheet> {
  late TicketStatus _status;
  String? _tierId;
  late TextEditingController _badgeNameController;
  late TextEditingController _denialReasonController;
  late bool _isFursuiter;
  late bool _isFursuitStaff;
  late bool _isCheckedIn;
  String? _tshirtSize;
  bool _saving = false;

  static const _editableStatuses = [
    TicketStatus.pending,
    TicketStatus.selfConfirmed,
    TicketStatus.approved,
    TicketStatus.denied,
  ];

  @override
  void initState() {
    super.initState();
    final ticket = widget.ticket;
    _status = ticket.status;
    _tierId = ticket.tierId;
    _badgeNameController = TextEditingController(text: ticket.conBadgeName ?? '');
    _denialReasonController =
        TextEditingController(text: ticket.denialReason ?? '');
    _isFursuiter = ticket.isFursuiter;
    _isFursuitStaff = ticket.isFursuitStaff;
    _isCheckedIn = ticket.isCheckedIn;
    _tshirtSize = ticket.tshirtSize?.isNotEmpty == true
        ? ticket.tshirtSize
        : null;
  }

  @override
  void dispose() {
    _badgeNameController.dispose();
    _denialReasonController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.onSave(
        AdminTicketUpdateInput(
          status: _status.apiValue,
          tierId: _tierId,
          conBadgeName: _badgeNameController.text.trim(),
          isFursuiter: _isFursuiter,
          isFursuitStaff: _isFursuitStaff,
          isCheckedIn: _isCheckedIn,
          tshirtSize: _tshirtSize,
          denialReason: _denialReasonController.text.trim(),
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, true);
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
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FuvekonColors.darkBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Chỉnh sửa vé',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: FuvekonColors.darkText,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TicketStatus>(
              value: _editableStatuses.contains(_status)
                  ? _status
                  : TicketStatus.approved,
              decoration: const InputDecoration(labelText: 'Trạng thái'),
              items: [
                for (final status in _editableStatuses)
                  DropdownMenuItem(
                    value: status,
                    child: Text(ticketStatusLabelVi(status)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: 12),
            if (widget.tiers.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _tierId,
                decoration: const InputDecoration(labelText: 'Hạng vé'),
                items: [
                  for (final tier in widget.tiers)
                    DropdownMenuItem(
                      value: tier.id,
                      child: Text('${tier.ticketName} (${tier.tierCode})'),
                    ),
                ],
                onChanged: (value) => setState(() => _tierId = value),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _badgeNameController,
              decoration: const InputDecoration(labelText: 'Tên badge'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              value: _tshirtSize,
              decoration: const InputDecoration(labelText: 'Size áo'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Chưa chọn')),
                for (final size in _tshirtSizes)
                  DropdownMenuItem(value: size, child: Text(size)),
              ],
              onChanged: (value) => setState(() => _tshirtSize = value),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fursuiter'),
              value: _isFursuiter,
              onChanged: (value) => setState(() => _isFursuiter = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fursuit staff'),
              value: _isFursuitStaff,
              onChanged: (value) => setState(() => _isFursuitStaff = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Đã check-in'),
              value: _isCheckedIn,
              onChanged: (value) => setState(() => _isCheckedIn = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _denialReasonController,
              decoration: const InputDecoration(labelText: 'Lý do từ chối'),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
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
