import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/l10n/l10n_extensions.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/l10n/admin_error_l10n.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_user_access_widgets.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';

/// A full-screen review page for a panel or talent performance application.
///
/// Panels and talents share the same submission workflow (pending →
/// approved / require changes / denied), so this single screen is reused by
/// both [AdminPanelDetailPage] and [AdminTalentDetailPage] instead of
/// duplicating the layout.
class AdminPerformanceApplicationDetailPage extends StatefulWidget {
  const AdminPerformanceApplicationDetailPage({
    super.key,
    required this.appBarTitle,
    required this.title,
    required this.nickname,
    required this.representativeUrl,
    required this.performanceGenre,
    required this.durationMinutes,
    required this.participantCount,
    required this.slotLabel,
    required this.introduction,
    required this.status,
    required this.createdAt,
    required this.approveLabel,
    required this.denyLabel,
    required this.onApprove,
    required this.onRequireChanges,
    required this.onDeny,
    required this.onMarkPending,
  });

  final String appBarTitle;
  final String title;
  final String nickname;
  final String? representativeUrl;
  final String performanceGenre;
  final int durationMinutes;
  final int participantCount;
  final String? slotLabel;
  final String? introduction;
  final String status;
  final DateTime? createdAt;
  final String approveLabel;
  final String denyLabel;
  final Future<String> Function() onApprove;
  final Future<String> Function() onRequireChanges;
  final Future<String> Function() onDeny;
  final Future<String> Function() onMarkPending;

  @override
  State<AdminPerformanceApplicationDetailPage> createState() =>
      _AdminPerformanceApplicationDetailPageState();
}

class _AdminPerformanceApplicationDetailPageState
    extends State<AdminPerformanceApplicationDetailPage> {
  bool _actionInProgress = false;

  bool get _isPending => widget.status == 'pending';

  Future<void> _runAction(Future<String> Function() action) async {
    final l10n = context.l10n;
    setState(() => _actionInProgress = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.adminUpdateSuccess)));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(formatAdminError(l10n, e))));
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      appBar: AppBar(
        backgroundColor: FuvekonColors.darkBg,
        foregroundColor: FuvekonColors.darkText,
        title: Text(
          widget.title.isNotEmpty ? widget.title : widget.appBarTitle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          FuvekonSpacing.page,
          8,
          FuvekonSpacing.page,
          FuvekonSpacing.page,
        ),
        children: [
          _HeaderCard(
            title: widget.title,
            nickname: widget.nickname,
            performanceGenre: widget.performanceGenre,
            representativeUrl: widget.representativeUrl,
            status: widget.status,
          ),
          const SizedBox(height: FuvekonSpacing.section),
          _ApprovalActions(
            isPending: _isPending,
            loading: _actionInProgress,
            approveLabel: widget.approveLabel,
            denyLabel: widget.denyLabel,
            onApprove: () => _runAction(widget.onApprove),
            onRequireChanges: () => _runAction(widget.onRequireChanges),
            onDeny: () => _runAction(widget.onDeny),
            onMarkPending: () => _runAction(widget.onMarkPending),
          ),
          const SizedBox(height: FuvekonSpacing.section),
          AdminUserSectionTitle(title: l10n.adminApplicationInfo),
          const SizedBox(height: 12),
          _InfoCard(
            children: [
              _InfoRow(
                label: l10n.adminFieldParticipantCount,
                value: widget.participantCount.toString(),
              ),
              _InfoRow(
                label: l10n.adminFieldDuration,
                value: l10n.adminDurationMinutes(widget.durationMinutes),
              ),
              if (widget.slotLabel?.isNotEmpty == true)
                _InfoRow(
                  label: l10n.adminFieldTimeSlot,
                  value: widget.slotLabel!,
                ),
              _InfoRow(
                label: l10n.adminFieldSubmittedAt,
                value: formatAdminDate(widget.createdAt),
              ),
            ],
          ),
          if (widget.introduction?.isNotEmpty == true) ...[
            const SizedBox(height: FuvekonSpacing.section),
            AdminUserSectionTitle(title: l10n.adminFieldIntroduction),
            const SizedBox(height: 12),
            _InfoCard(
              children: [
                Text(
                  widget.introduction!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FuvekonColors.darkText,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.title,
    required this.nickname,
    required this.performanceGenre,
    required this.representativeUrl,
    required this.status,
  });

  final String title;
  final String nickname;
  final String performanceGenre;
  final String? representativeUrl;
  final String status;

  (FuveStatusBadgeVariant, String) _statusPresentation(BuildContext context) {
    final l10n = context.l10n;
    return switch (status) {
      'approved' => (FuveStatusBadgeVariant.success, l10n.adminStatusApproved),
      'require_changes' => (
        FuveStatusBadgeVariant.neutral,
        l10n.adminStatusRequireChanges,
      ),
      'denied' => (FuveStatusBadgeVariant.denied, l10n.adminStatusDenied),
      _ => (FuveStatusBadgeVariant.pending, l10n.adminStatusPending),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (variant, statusLabel) = _statusPresentation(context);
    final subtitle = [
      if (nickname.isNotEmpty) nickname,
      if (performanceGenre.isNotEmpty) performanceGenre,
    ].join(' • ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FuvekonColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(48),
            child: SizedBox(
              width: 88,
              height: 88,
              child: representativeUrl?.isNotEmpty == true
                  ? S3Image(
                      imageUrl: representativeUrl,
                      width: 88,
                      height: 88,
                      onTap: () =>
                          showS3ImagePreview(context, representativeUrl!),
                    )
                  : Container(
                      color: FuvekonColors.darkBorder,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.theater_comedy_outlined,
                        color: FuvekonColors.darkText,
                        size: 36,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: FuvekonColors.darkText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          FuveStatusBadge(label: statusLabel, variant: variant),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: FuvekonColors.darkTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ApprovalActions extends StatelessWidget {
  const _ApprovalActions({
    required this.isPending,
    required this.loading,
    required this.approveLabel,
    required this.denyLabel,
    required this.onApprove,
    required this.onRequireChanges,
    required this.onDeny,
    required this.onMarkPending,
  });

  final bool isPending;
  final bool loading;
  final String approveLabel;
  final String denyLabel;
  final VoidCallback onApprove;
  final VoidCallback onRequireChanges;
  final VoidCallback onDeny;
  final VoidCallback onMarkPending;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdminUserSectionTitle(title: l10n.adminDealerActions),
        const SizedBox(height: 12),
        if (isPending) ...[
          _ActionButton(
            label: approveLabel,
            color: FuvekonColors.available,
            loading: loading,
            onPressed: onApprove,
          ),
          const SizedBox(height: 8),
          _ActionButton(
            label: l10n.adminRequireChanges,
            color: const Color(0xFFFBBF24),
            loading: loading,
            onPressed: onRequireChanges,
          ),
          const SizedBox(height: 8),
          _ActionButton(
            label: denyLabel,
            color: const Color(0xFFF0A0A8),
            loading: loading,
            onPressed: onDeny,
          ),
        ] else
          _ActionButton(
            label: l10n.adminMarkPendingReturn,
            color: const Color(0xFFFBBF24),
            loading: loading,
            onPressed: onMarkPending,
          ),
      ],
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
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: FuvekonColors.darkCardText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FuvekonRadii.input),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

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
