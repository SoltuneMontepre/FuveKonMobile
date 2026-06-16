import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/models/admin_submission_models.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_lost_found_service.dart';
import 'package:fuvekonmobile/screens/info/lost_found_models.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:go_router/go_router.dart';

class AdminLostFoundReturnPage extends StatefulWidget {
  const AdminLostFoundReturnPage({super.key, required this.itemId});

  final String itemId;

  @override
  State<AdminLostFoundReturnPage> createState() =>
      _AdminLostFoundReturnPageState();
}

class _AdminLostFoundReturnPageState extends State<AdminLostFoundReturnPage> {
  late final AdminLostFoundService _service;

  AdminLostFoundItem? _item;
  bool _loading = true;
  bool _submitting = false;
  String? _error;
  bool _verifiedDescription = false;
  bool _verifiedOwnership = false;
  bool _verifiedIdentity = false;

  bool get _allVerified =>
      _verifiedDescription && _verifiedOwnership && _verifiedIdentity;

  AdminLostFoundClaimUser? get _claimer => _item?.activeClaim?.claimedBy;

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
      if (!item.canConfirmReturn) {
        setState(() {
          _item = item;
          _loading = false;
          _error = item.activeClaim == null
              ? 'Chưa có người dùng nào nhận vật phẩm này.'
              : 'Vật phẩm này không thể hoàn trả.';
        });
        return;
      }
      setState(() {
        _item = item;
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

  Future<void> _submit() async {
    if (!_allVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng hoàn tất checklist xác minh trước khi xác nhận.',
          ),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await _service.confirmReturn(
        widget.itemId,
        ConfirmLostFoundReturnInput(
          verifiedDescription: _verifiedDescription,
          verifiedOwnership: _verifiedOwnership,
          verifiedIdentity: _verifiedIdentity,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xác nhận hoàn trả thành công.')),
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
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      appBar: AppBar(
        backgroundColor: FuvekonColors.darkBg,
        foregroundColor: FuvekonColors.darkText,
        elevation: 0,
        title: Text(
          'Xác nhận hoàn trả',
          style: theme.textTheme.titleLarge?.copyWith(
            color: FuvekonColors.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null || _item == null || _claimer == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(FuvekonSpacing.page),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error ?? 'Không tìm thấy thông tin người nhận.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Quay lại'),
              ),
            ],
          ),
        ),
      );
    }

    final item = _item!;
    final claimer = _claimer!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        FuvekonSpacing.page,
        8,
        FuvekonSpacing.page,
        32,
      ),
      children: [
        _SectionTitle(
          icon: Icons.inventory_2_outlined,
          title: 'Thông tin vật phẩm',
        ),
        const SizedBox(height: 12),
        _LostFoundLightCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.imageUrl.isNotEmpty)
                S3Image(
                  imageUrl: item.imageUrl,
                  width: 72,
                  height: 72,
                  borderRadius: BorderRadius.circular(12),
                )
              else
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: FuvekonColors.darkSurfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: FuvekonColors.textSecondary,
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: FuvekonColors.darkCardText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: FuvekonColors.darkSurfaceElevated
                            .withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '# ${item.itemCode}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: FuvekonColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _SectionTitle(
          icon: Icons.person_outline_rounded,
          title: 'Thông tin người nhận',
        ),
        const SizedBox(height: 8),
        Text(
          'Người dùng đã xác nhận đây là vật phẩm của họ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: FuvekonColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: 12),
        _LostFoundLightCard(
          child: Column(
            children: [
              _ReadOnlyField(label: 'Họ và tên', value: claimer.displayName),
              const SizedBox(height: 12),
              _ReadOnlyField(
                label: 'CCCD',
                value: AdminLostFoundClaimUser.maskSensitive(claimer.idCard),
              ),
              const SizedBox(height: 12),
              _ReadOnlyField(
                label: 'Email',
                value: AdminLostFoundClaimUser.maskSensitive(claimer.email),
              ),
              if (item.activeClaim?.message.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                _ReadOnlyField(
                  label: 'Ghi chú từ người dùng',
                  value: item.activeClaim!.message,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        _SectionTitle(
          icon: Icons.checklist_rounded,
          title: 'Checklist xác minh',
        ),
        const SizedBox(height: 12),
        _VerificationChecklist(
          verifiedDescription: _verifiedDescription,
          verifiedOwnership: _verifiedOwnership,
          verifiedIdentity: _verifiedIdentity,
          onDescriptionChanged: (value) =>
              setState(() => _verifiedDescription = value),
          onOwnershipChanged: (value) =>
              setState(() => _verifiedOwnership = value),
          onIdentityChanged: (value) =>
              setState(() => _verifiedIdentity = value),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: _submitting || !_allVerified ? null : _submit,
          style: FilledButton.styleFrom(
            backgroundColor: FuvekonColors.darkPrimary,
            foregroundColor: FuvekonColors.darkButtonText,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: _submitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Xác nhận hoàn trả'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _submitting ? null : () => context.pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: FuvekonColors.darkText,
            side: const BorderSide(color: FuvekonColors.darkBorder),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: const Text('Quay lại'),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: FuvekonColors.darkTextSecondary.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Hành động này sẽ được ghi vào nhật ký hệ thống',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: FuvekonColors.darkTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: FuvekonColors.darkAppBarTitle),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: FuvekonColors.darkAppBarTitle,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _LostFoundLightCard extends StatelessWidget {
  const _LostFoundLightCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkCard,
        borderRadius: BorderRadius.circular(FuvekonRadii.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: FuvekonColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value.isNotEmpty ? value : '—',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: FuvekonColors.darkCardText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _VerificationChecklist extends StatelessWidget {
  const _VerificationChecklist({
    required this.verifiedDescription,
    required this.verifiedOwnership,
    required this.verifiedIdentity,
    required this.onDescriptionChanged,
    required this.onOwnershipChanged,
    required this.onIdentityChanged,
  });

  final bool verifiedDescription;
  final bool verifiedOwnership;
  final bool verifiedIdentity;
  final ValueChanged<bool> onDescriptionChanged;
  final ValueChanged<bool> onOwnershipChanged;
  final ValueChanged<bool> onIdentityChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FuvekonColors.darkBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            _ChecklistTile(
              label: 'Mô tả đúng vật phẩm',
              value: verifiedDescription,
              onChanged: onDescriptionChanged,
            ),
            const Divider(height: 1, color: FuvekonColors.darkBorder),
            _ChecklistTile(
              label: 'Có bằng chứng sở hữu',
              value: verifiedOwnership,
              onChanged: onOwnershipChanged,
            ),
            const Divider(height: 1, color: FuvekonColors.darkBorder),
            _ChecklistTile(
              label: 'Đã xác minh danh tính',
              value: verifiedIdentity,
              onChanged: onIdentityChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: (checked) => onChanged(checked ?? false),
      activeColor: const Color(0xFF3B82F6),
      checkColor: Colors.white,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: FuvekonColors.darkText,
            ),
      ),
    );
  }
}
