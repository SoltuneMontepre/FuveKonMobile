import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_submission_l10n.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_lost_found_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_lost_found_form_sheet.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_user_access_widgets.dart';
import 'package:fuvekonmobile/screens/info/lost_found_models.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:go_router/go_router.dart';

class AdminLostFoundDetailPage extends StatefulWidget {
  const AdminLostFoundDetailPage({super.key, required this.itemId});

  final String itemId;

  @override
  State<AdminLostFoundDetailPage> createState() =>
      _AdminLostFoundDetailPageState();
}

class _AdminLostFoundDetailPageState extends State<AdminLostFoundDetailPage> {
  late final AdminLostFoundService _service;
  AdminLostFoundItem? _item;
  String? _error;
  bool _loading = true;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _service = sl<AdminLostFoundService>();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final item = await _service.getById(widget.itemId);
      if (!mounted) return;
      setState(() {
        _item = item;
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

  Future<void> _runAction(Future<void> Function() action) async {
    final l10n = context.l10n;
    setState(() => _actionInProgress = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.adminUpdateSuccess)));
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(formatAdminError(l10n, e))));
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _openReturn() async {
    final confirmed = await context.push<bool>(
      Routes.adminLostFoundReturn(widget.itemId),
    );
    if (confirmed == true && mounted) {
      context.pop(true);
    }
  }

  void _openEdit(AdminLostFoundItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FuvekonColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AdminLostFoundFormSheet(
        item: item,
        onSubmit: (input) => _service.update(
          item.id,
          UpdateLostFoundInput(
            itemType: input.itemType,
            title: input.title,
            description: input.description,
            location: input.location,
            imageUrl: input.imageUrl,
            contactInfo: input.contactInfo,
            staffNotes: input.staffNotes,
          ),
        ),
      ),
    ).then((_) {
      if (mounted) _load();
    });
  }

  Future<void> _confirmDelete() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.adminLostFoundDeleteTitle),
        content: Text(l10n.adminCannotUndo),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.adminCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.adminDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _runAction(() => _service.delete(widget.itemId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final item = _item;
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      appBar: AppBar(
        backgroundColor: FuvekonColors.darkBg,
        foregroundColor: FuvekonColors.darkText,
        title: Text(item?.title ?? l10n.adminLostFoundDetailTitle),
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

    final item = _item!;
    final claim = item.activeClaim;
    final claimer = claim?.claimedBy;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        FuvekonSpacing.page,
        8,
        FuvekonSpacing.page,
        FuvekonSpacing.page,
      ),
      children: [
        _HeaderCard(item: item),
        if (claim != null && claimer != null) ...[
          const SizedBox(height: FuvekonSpacing.section),
          AdminUserSectionTitle(title: l10n.adminLostFoundRecipientClaimed),
          const SizedBox(height: 12),
          _ClaimCard(l10n: l10n, claim: claim, claimer: claimer),
        ] else if (item.itemType == 'found' && item.status == 'open') ...[
          const SizedBox(height: FuvekonSpacing.section),
          Text(
            l10n.adminLostFoundNoClaim,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: FuvekonColors.darkTextSecondary,
            ),
          ),
        ],
        const SizedBox(height: FuvekonSpacing.section),
        AdminUserSectionTitle(title: l10n.adminLostFoundItemInfo),
        const SizedBox(height: 12),
        _InfoCard(
          children: [
            for (final field in item.localizedDetails(l10n))
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
        if (item.canConfirmReturn)
          _ActionButton(
            label: l10n.adminLostFoundConfirmReturn,
            color: FuvekonColors.available,
            loading: _actionInProgress,
            onPressed: _openReturn,
          )
        else if (item.itemType == 'lost' && item.status != 'resolved')
          _ActionButton(
            label: l10n.adminLostFoundMarkResolved,
            color: FuvekonColors.available,
            loading: _actionInProgress,
            onPressed: () =>
                _runAction(() => _service.updateStatus(item.id, 'resolved')),
          ),
        _ActionButton(
          label: l10n.adminEdit,
          color: FuvekonColors.darkPrimary,
          onPressed: () => _openEdit(item),
        ),
        _ActionButton(
          label: l10n.adminDelete,
          color: const Color(0xFFF0A0A8),
          loading: _actionInProgress,
          onPressed: _confirmDelete,
        ),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.item});

  final AdminLostFoundItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
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
          if (item.previewImageUrl != null) ...[
            S3Image(
              imageUrl: item.previewImageUrl,
              width: 64,
              height: 64,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: FuvekonColors.darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.itemCode,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FuvekonColors.darkTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${lostFoundTypeLabel(l10n, item.itemType)} • ${lostFoundStatusLabel(l10n, item.status)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: FuvekonColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _StatusChip(status: item.status),
        ],
      ),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  const _ClaimCard({
    required this.l10n,
    required this.claim,
    required this.claimer,
  });

  final AppLocalizations l10n;
  final AdminLostFoundClaim claim;
  final AdminLostFoundClaimUser claimer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FuvekonColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FuvekonColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            claimer.displayName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: FuvekonColors.darkCardText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.adminFieldIdCard}: ${AdminLostFoundClaimUser.maskSensitive(claimer.idCard)}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: FuvekonColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.adminFieldEmail}: ${AdminLostFoundClaimUser.maskSensitive(claimer.email)}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: FuvekonColors.textSecondary),
          ),
          if (claim.message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              claim.message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: FuvekonColors.darkCardText,
              ),
            ),
          ],
        ],
      ),
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = lostFoundStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        lostFoundStatusLabel(l10n, status),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
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
