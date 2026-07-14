import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_submission_l10n.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_ticket_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_user_access_widgets.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_user_ticket_widgets.dart';
import 'package:fuvekonmobile/shared/widgets/s3_avatar.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:go_router/go_router.dart';

class AdminTicketDetailPage extends StatefulWidget {
  const AdminTicketDetailPage({super.key, required this.ticketId});

  final String ticketId;

  @override
  State<AdminTicketDetailPage> createState() => _AdminTicketDetailPageState();
}

class _AdminTicketDetailPageState extends State<AdminTicketDetailPage> {
  late final AdminTicketService _service;

  AdminTicketItem? _ticket;
  String? _error;
  bool _loading = true;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _service = sl<AdminTicketService>();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final ticket = await _service.getTicketById(widget.ticketId);
      if (!mounted) return;
      setState(() {
        _ticket = ticket;
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
    bool popOnSuccess = true,
  }) async {
    final l10n = context.l10n;
    setState(() => _actionInProgress = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
      if (popOnSuccess) {
        context.pop(true);
      } else {
        await _load();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(formatAdminError(l10n, e))));
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
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

  void _openUser(AdminTicketItem ticket) {
    final userId = ticket.userId;
    if (userId == null || userId.isEmpty) return;
    context.push(Routes.adminUserDetail(userId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ticket = _ticket;

    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      appBar: AppBar(
        backgroundColor: FuvekonColors.darkBg,
        foregroundColor: FuvekonColors.darkText,
        title: Text(ticket?.referenceCode ?? l10n.adminTicketsTitle),
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
              FilledButton(onPressed: _load, child: Text(l10n.adminRetry)),
            ],
          ),
        ),
      );
    }

    final ticket = _ticket!;
    final userInfo = ticket.localizedListUserInfo(l10n);
    final initials = ticket.holderName.isNotEmpty
        ? ticket.holderName[0].toUpperCase()
        : '?';

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        FuvekonSpacing.page,
        8,
        FuvekonSpacing.page,
        FuvekonSpacing.page,
      ),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: FuvekonColors.darkSurfaceElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: FuvekonColors.darkBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              S3Avatar(
                imageUrl: ticket.userAvatar,
                initials: initials,
                radius: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: FuvekonColors.darkText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (userInfo.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        userInfo,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: FuvekonColors.darkTextSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        AdminTicketStatusChip(status: ticket.status),
                        if (ticket.isUpgrade) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: FuvekonColors.lightGold.withValues(
                                alpha: 0.18,
                              ),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: FuvekonColors.lightGold.withValues(
                                  alpha: 0.55,
                                ),
                              ),
                            ),
                            child: Text(
                              l10n.adminTicketUpgradeBadge,
                              style: const TextStyle(
                                color: FuvekonColors.lightGold,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: FuvekonSpacing.section),
        _InfoCard(
          children: [
            for (final field in ticket.localizedDetails(l10n))
              _InfoField(
                label: field.label,
                value: field.value,
                imageUrl: field.imageUrl,
              ),
          ],
        ),
        const SizedBox(height: FuvekonSpacing.section),
        AdminUserSectionTitle(title: l10n.adminDealerActions),
        const SizedBox(height: 12),
        if (ticket.canApprove)
          _ActionButton(
            label: ticket.isUpgrade
                ? l10n.adminUserTicketsApproveUpgrade
                : l10n.adminUserTicketsApprove,
            color: FuvekonColors.available,
            loading: _actionInProgress,
            onPressed: () => _runAction(
              () => _service.approveTicket(ticket.id),
              successMessage: l10n.adminUserTicketsApproveSuccess,
            ),
          ),
        if (ticket.canDeny)
          _ActionButton(
            label: ticket.isUpgrade
                ? l10n.adminUserTicketsDenyUpgrade
                : l10n.adminUserTicketsDeny,
            color: const Color(0xFFF0A0A8),
            loading: _actionInProgress,
            onPressed: () async {
              final reason = await _promptDenyReason();
              if (!mounted || reason == null) return;
              await _runAction(
                () => _service.denyTicket(ticket.id, reason: reason),
                successMessage: ticket.isUpgrade
                    ? l10n.adminUserTicketsDenyUpgradeSuccess
                    : l10n.adminUserTicketsDenySuccess,
              );
            },
          ),
        if (ticket.canResendQr)
          _ActionButton(
            label: l10n.adminUserTicketsResendQr,
            color: const Color(0xFF60A5FA),
            loading: _actionInProgress,
            onPressed: () => _runAction(
              () => _service.resendQrEmail(ticket.id),
              successMessage: l10n.adminUserTicketsResendQrSuccess,
              popOnSuccess: false,
            ),
          ),
        if (ticket.userId?.isNotEmpty == true)
          _ActionButton(
            label: l10n.adminTicketsViewUser,
            color: const Color(0xFF94A3B8),
            onPressed: () => _openUser(ticket),
          ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FuvekonColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value, this.imageUrl});

  final String label;
  final String value;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: FuvekonColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          if (imageUrl != null)
            S3Image(
              imageUrl: imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.circular(12),
              onTap: () => showS3ImagePreview(context, imageUrl!),
            )
          else if (value.isNotEmpty)
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: FuvekonColors.darkText),
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
