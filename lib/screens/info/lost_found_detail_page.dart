import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/screens/info/lost_found_models.dart';
import 'package:fuvekonmobile/screens/info/lost_found_service.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Màn 35 — found item detail at `/lost-found/:id`.
class LostFoundDetailPage extends StatefulWidget {
  const LostFoundDetailPage({super.key, required this.itemId});

  final String itemId;

  @override
  State<LostFoundDetailPage> createState() => _LostFoundDetailPageState();
}

class _LostFoundDetailPageState extends State<LostFoundDetailPage> {
  late final LostFoundService _service;

  LostFoundPublicItem? _item;
  bool _loading = true;
  bool _claiming = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = sl<LostFoundService>();
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
        _error = e is AppException ? e.message : e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _claimItem() async {
    final item = _item;
    if (item == null || !item.canClaim) return;

    setState(() => _claiming = true);
    try {
      final itemId = await _service.claim(item.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Đã gửi yêu cầu nhận vật phẩm. Nhân viên sẽ xác minh và liên hệ bạn.',
          ),
        ),
      );
      context.pushReplacement(Routes.lostFoundRequest(itemId));
    } catch (e) {
      if (!mounted) return;
      final message = e is AppException ? e.message : e.toString();
      if (message.toLowerCase().contains('ticket')) {
        _showTicketRequiredDialog();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  void _showTicketRequiredDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cần vé hợp lệ'),
        content: const Text(
          'Bạn cần có vé đã được duyệt để xem và nhận đồ thất lạc.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(Routes.accountTicket);
            },
            child: const Text('Xem vé của tôi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Chi tiết vật phẩm',
      illustratedBackground: true,
      padding: const EdgeInsets.all(FuvekonSpacing.page),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      final needsTicket = _error!.toLowerCase().contains('ticket');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              needsTicket
                  ? 'Bạn cần có vé đã được duyệt để xem chi tiết.'
                  : _error!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: FuvekonSpacing.field),
            if (needsTicket)
              FilledButton(
                onPressed: () => context.go(Routes.accountTicket),
                child: const Text('Xem vé của tôi'),
              )
            else
              FilledButton(onPressed: _load, child: const Text('Thử lại')),
          ],
        ),
      );
    }

    final item = _item!;
    final theme = context.fuvekonTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FuveMintCard(
            showGoldAccent: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FuveStatusBadge(
                      label: item.statusLabel,
                      variant: item.isReturned
                          ? FuveStatusBadgeVariant.success
                          : FuveStatusBadgeVariant.pending,
                    ),
                    if (item.userClaimStatusLabel.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      FuveStatusBadge(
                        label: item.userClaimStatusLabel,
                        variant: item.userClaimStatus == 'rejected'
                            ? FuveStatusBadgeVariant.denied
                            : FuveStatusBadgeVariant.neutral,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: FuvekonSpacing.stackGapMd),
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: theme.contentOnCard,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '# ${item.itemCode}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: theme.contentOnCardMuted,
                  ),
                ),
                if (item.imageUrl.isNotEmpty) ...[
                  const SizedBox(height: FuvekonSpacing.stackGapMd),
                  S3Image(
                    imageUrl: item.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
                if (item.description.isNotEmpty) ...[
                  const SizedBox(height: FuvekonSpacing.section),
                  const FuveSectionHeader(title: 'Mô tả'),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: theme.contentOnCardMuted,
                      height: 1.5,
                    ),
                  ),
                ],
                if (item.location.isNotEmpty) ...[
                  const SizedBox(height: FuvekonSpacing.stackGapMd),
                  _DetailRow(
                    icon: Icons.place_outlined,
                    label: 'Vị trí nhặt được',
                    value: item.location,
                  ),
                ],
                if (item.createdAt != null) ...[
                  const SizedBox(height: FuvekonSpacing.stackGapMd),
                  _DetailRow(
                    icon: Icons.schedule_outlined,
                    label: 'Ghi nhận',
                    value: DateFormat(
                      'HH:mm dd/MM/yyyy',
                    ).format(item.createdAt!),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: FuvekonSpacing.section),
          if (item.userHasPendingClaim || item.userClaimStatus == 'approved')
            FuvePillButton(
              label: 'Theo dõi yêu cầu',
              icon: Icons.timeline_outlined,
              variant: FuvePillButtonVariant.secondary,
              onPressed: () => context.push(Routes.lostFoundRequest(item.id)),
            )
          else if (item.canClaim)
            FuvePillButton(
              label: _claiming ? 'Đang gửi...' : 'Đây là của tôi',
              icon: Icons.check_circle_outline,
              onPressed: _claiming ? null : _claimItem,
            )
          else
            FuvePillButton(
              label: 'Quay lại danh sách',
              variant: FuvePillButtonVariant.outline,
              onPressed: () => context.pop(),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = context.fuvekonTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.contentOnCardMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: theme.contentOnCardMuted,
                ),
              ),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: theme.contentOnCard),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
