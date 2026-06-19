import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_dealer_service.dart';
import 'package:fuvekonmobile/screens/admin/widgets/admin_user_access_widgets.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:go_router/go_router.dart';

class AdminDealerDetailPage extends StatefulWidget {
  const AdminDealerDetailPage({super.key, required this.dealerId});

  final String dealerId;

  @override
  State<AdminDealerDetailPage> createState() => _AdminDealerDetailPageState();
}

class _AdminDealerDetailPageState extends State<AdminDealerDetailPage> {
  late final AdminDealerService _service;
  AdminDealerItem? _dealer;
  String? _error;
  bool _loading = true;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _service = sl<AdminDealerService>();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final dealer = await _service.getDealerById(widget.dealerId);
      if (!mounted) return;
      setState(() {
        _dealer = dealer;
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
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dealer = _dealer;
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      appBar: AppBar(
        backgroundColor: FuvekonColors.darkBg,
        foregroundColor: FuvekonColors.darkText,
        title: Text(dealer?.boothName ?? 'Chi tiết gian hàng'),
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

    final dealer = _dealer!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        FuvekonSpacing.page,
        8,
        FuvekonSpacing.page,
        FuvekonSpacing.page,
      ),
      children: [
        _DealerHeaderCard(dealer: dealer),
        if (!dealer.isVerified) ...[
          const SizedBox(height: FuvekonSpacing.section),
          _ApprovalActions(
            loading: _actionInProgress,
            onApprove: () => _runAction(() => _service.verifyDealer(dealer.id)),
            onDeny: () => _runAction(() => _service.denyDealer(dealer.id)),
          ),
        ],
        const SizedBox(height: FuvekonSpacing.section),
        const AdminUserSectionTitle(title: 'Thông tin gian hàng'),
        const SizedBox(height: 12),
        _InfoCard(
          children: [
            if (dealer.boothNumber?.isNotEmpty == true)
              _InfoRow(
                label: 'Mã gian',
                value: dealer.boothNumber!,
              ),
            if (dealer.description.isNotEmpty)
              _InfoRow(
                label: 'Mô tả',
                value: dealer.description,
              ),
            _InfoRow(
              label: 'Ngày đăng ký',
              value: formatAdminDate(dealer.createdAt),
            ),
            if (dealer.modifiedAt != null)
              _InfoRow(
                label: 'Cập nhật lần cuối',
                value: formatAdminDate(dealer.modifiedAt),
              ),
          ],
        ),
        if (dealer.priceSheets.isNotEmpty) ...[
          const SizedBox(height: FuvekonSpacing.section),
          AdminUserSectionTitle(
            title: dealer.priceSheets.length == 1
                ? 'Bảng giá'
                : 'Bảng giá (${dealer.priceSheets.length})',
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < dealer.priceSheets.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            S3Image(
              imageUrl: dealer.priceSheets[i],
              width: double.infinity,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.circular(12),
              onTap: () => showS3ImagePreview(
                context,
                dealer.priceSheets[i],
              ),
            ),
          ],
        ],
        const SizedBox(height: FuvekonSpacing.section),
        AdminUserSectionTitle(
          title: 'Nhân viên gian hàng (${dealer.staff.length})',
        ),
        const SizedBox(height: 12),
        if (dealer.staff.isEmpty)
          _InfoCard(
            children: [
              Text(
                'Chưa có nhân viên nào.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
              ),
            ],
          )
        else
          _InfoCard(
            children: [
              for (var i = 0; i < dealer.staff.length; i++) ...[
                if (i > 0)
                  const Divider(height: 24, color: FuvekonColors.darkBorder),
                _StaffRow(member: dealer.staff[i]),
              ],
            ],
          ),
      ],
    );
  }
}

class _DealerHeaderCard extends StatelessWidget {
  const _DealerHeaderCard({required this.dealer});

  final AdminDealerItem dealer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FuvekonColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  dealer.boothName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: FuvekonColors.darkText,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              FuveStatusBadge(
                label: dealer.isVerified ? 'Đã duyệt' : 'Chờ duyệt',
                variant: dealer.isVerified
                    ? FuveStatusBadgeVariant.success
                    : FuveStatusBadgeVariant.pending,
              ),
            ],
          ),
          if (dealer.boothNumber?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              'Mã gian: ${dealer.boothNumber}',
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
    required this.loading,
    required this.onApprove,
    required this.onDeny,
  });

  final bool loading;
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AdminUserSectionTitle(title: 'Thao tác'),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: loading ? null : onApprove,
          style: FilledButton.styleFrom(
            backgroundColor: FuvekonColors.available,
            foregroundColor: FuvekonColors.darkCardText,
          ),
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Duyệt gian hàng'),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: loading ? null : onDeny,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFF0A0A8),
            foregroundColor: FuvekonColors.darkCardText,
          ),
          child: const Text('Từ chối đăng ký'),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: FuvekonColors.darkText,
                ),
          ),
        ],
      ),
    );
  }
}

class _StaffRow extends StatelessWidget {
  const _StaffRow({required this.member});

  final AdminDealerStaffMember member;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: FuvekonColors.darkBorder,
          child: Text(
            member.userName.isNotEmpty
                ? member.userName[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: FuvekonColors.darkText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      member.userName.isNotEmpty
                          ? member.userName
                          : member.userEmail,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: FuvekonColors.darkText,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  if (member.isOwner)
                    const FuveStatusBadge(
                      label: 'Chủ gian',
                      variant: FuveStatusBadgeVariant.success,
                    ),
                ],
              ),
              if (member.userEmail.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  member.userEmail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: FuvekonColors.darkTextSecondary,
                      ),
                ),
              ],
              if (member.createdAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Tham gia: ${formatAdminDate(member.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: FuvekonColors.darkTextSecondary,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
