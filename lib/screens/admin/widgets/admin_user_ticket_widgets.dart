import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_submission_l10n.dart';
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
        _error = formatAdminError(context.l10n, e);
        _loading = false;
      });
    }
  }

  Future<void> _runAction(
    Future<void> Function() action, {
    required String successMessage,
  }) async {
    final l10n = context.l10n;
    setState(() => _actionInProgress = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
      await _load();
      widget.onTicketChanged?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(formatAdminError(l10n, e))));
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _grantTicket() async {
    final l10n = context.l10n;
    if (_tiers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.adminUserTicketsNoTiers)));
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
      successMessage: l10n.adminUserTicketsGrantSuccess,
    );
  }

  Future<String?> _promptDenyReason() async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.adminDenyReason),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.adminDenyReasonHint),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.adminCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.adminDeny),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteTicket(AdminTicketItem ticket) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.adminUserTicketsDeleteTitle),
        content: Text(l10n.adminUserTicketsDeleteBody(ticket.referenceCode)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.adminCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF0A0A8),
            ),
            child: Text(l10n.adminDelete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await _runAction(
      () => _ticketService.deleteTicket(ticket.id),
      successMessage: l10n.adminUserTicketsDeleted,
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
    final l10n = context.l10n;
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
                          style: Theme.of(context).textTheme.titleLarge
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
                        for (final field in ticket.localizedDetails(l10n))
                          _TicketDetailField(field: field),
                      ],
                    ),
                  ),
                  if (!widget.isDeleted) ...[
                    if (ticket.canApprove)
                      _TicketActionButton(
                        label: l10n.adminUserTicketsApprove,
                        color: FuvekonColors.available,
                        loading: _actionInProgress,
                        onPressed: () async {
                          Navigator.pop(context);
                          await _runAction(
                            () => _ticketService.approveTicket(ticket.id),
                            successMessage: l10n.adminUserTicketsApproveSuccess,
                          );
                        },
                      ),
                    if (ticket.canDeny)
                      _TicketActionButton(
                        label: l10n.adminUserTicketsDeny,
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
                            successMessage: l10n.adminUserTicketsDenySuccess,
                          );
                        },
                      ),
                    if (ticket.canResendQr)
                      _TicketActionButton(
                        label: l10n.adminUserTicketsResendQr,
                        color: const Color(0xFF60A5FA),
                        loading: _actionInProgress,
                        onPressed: () async {
                          Navigator.pop(context);
                          await _runAction(
                            () => _ticketService.resendQrEmail(ticket.id),
                            successMessage:
                                l10n.adminUserTicketsResendQrSuccess,
                          );
                        },
                      ),
                    _TicketActionButton(
                      label: l10n.adminUserTicketsEdit,
                      color: FuvekonColors.primary,
                      loading: _actionInProgress,
                      onPressed: () {
                        Navigator.pop(context);
                        _openEditTicket(ticket);
                      },
                    ),
                    _TicketActionButton(
                      label: l10n.adminUserTicketsDelete,
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
    final l10n = context.l10n;
    return AdminUserEditSectionCard(
      title: l10n.adminUserTicketsTitle,
      subtitle: l10n.adminUserTicketsSubtitle,
      child: _buildContent(l10n),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
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
          FilledButton(onPressed: _load, child: Text(l10n.adminRetry)),
        ],
      );
    }

    if (_ticket == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.adminUserTicketsEmpty,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: FuvekonColors.darkTextSecondary,
            ),
          ),
          if (!widget.isDeleted) ...[
            const SizedBox(height: 12),
            _TicketActionButton(
              label: l10n.adminUserTicketsGrant,
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
          label: l10n.adminFieldTicketCode,
          value: ticket.referenceCode,
        ),
        if (ticket.tierName?.isNotEmpty == true)
          _TicketSummaryRow(
            label: l10n.adminFieldTier,
            value: ticket.tierName!,
          ),
        _TicketSummaryRow(
          label: l10n.adminFieldStatus,
          value: ticketStatusLabel(l10n, ticket.status),
        ),
        _TicketSummaryRow(
          label: l10n.adminFieldCheckIn,
          value: ticket.isCheckedIn
              ? l10n.adminCheckedIn
              : l10n.adminNotCheckedIn,
        ),
        const SizedBox(height: 12),
        _TicketActionButton(
          label: l10n.adminUserTicketsManage,
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
    final l10n = context.l10n;
    final color = ticketStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        ticketStatusLabel(l10n, status),
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: FuvekonColors.darkText),
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: FuvekonColors.darkText),
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
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.adminUserTicketsGrantDialog),
      content: DropdownButtonFormField<String>(
        initialValue: _selectedTierId,
        decoration: InputDecoration(labelText: l10n.adminUserTicketsTierLabel),
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
          child: Text(l10n.adminCancel),
        ),
        FilledButton(
          onPressed: _selectedTierId == null
              ? null
              : () => Navigator.pop(context, _selectedTierId),
          child: Text(l10n.adminUserTicketsGrant),
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
    _badgeNameController = TextEditingController(
      text: ticket.conBadgeName ?? '',
    );
    _denialReasonController = TextEditingController(
      text: ticket.denialReason ?? '',
    );
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
    final l10n = context.l10n;
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(formatAdminError(l10n, e))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              l10n.adminUserTicketsEditTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: FuvekonColors.darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TicketStatus>(
              initialValue: _editableStatuses.contains(_status)
                  ? _status
                  : TicketStatus.approved,
              decoration: InputDecoration(labelText: l10n.adminFieldStatus),
              items: [
                for (final status in _editableStatuses)
                  DropdownMenuItem(
                    value: status,
                    child: Text(ticketStatusLabel(l10n, status)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: 12),
            if (widget.tiers.isNotEmpty)
              DropdownButtonFormField<String>(
                initialValue: _tierId,
                decoration: InputDecoration(
                  labelText: l10n.adminUserTicketsTierLabel,
                ),
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
              decoration: InputDecoration(labelText: l10n.adminFieldBadgeName),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: _tshirtSize,
              decoration: InputDecoration(labelText: l10n.adminFieldTshirtSize),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.adminUserTicketsNotSelected),
                ),
                for (final size in _tshirtSizes)
                  DropdownMenuItem(value: size, child: Text(size)),
              ],
              onChanged: (value) => setState(() => _tshirtSize = value),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.adminFieldFursuiter),
              value: _isFursuiter,
              onChanged: (value) => setState(() => _isFursuiter = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.adminFieldFursuitStaff),
              value: _isFursuitStaff,
              onChanged: (value) => setState(() => _isFursuitStaff = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.adminCheckedIn),
              value: _isCheckedIn,
              onChanged: (value) => setState(() => _isCheckedIn = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _denialReasonController,
              decoration: InputDecoration(labelText: l10n.adminDenyReason),
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
                  : Text(l10n.adminSaveChanges),
            ),
          ],
        ),
      ),
    );
  }
}
