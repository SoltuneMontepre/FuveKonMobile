import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/screens/info/lost_found_models.dart';
import 'package:fuvekonmobile/screens/info/lost_found_service.dart';
import 'package:fuvekonmobile/shared/widgets/app_page_layout.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_section_header.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
import 'package:fuvekonmobile/shared/widgets/s3_image.dart';
import 'package:intl/intl.dart';

/// Màn 37 — claim / lost report tracking at `/lost-found/requests/:id`.
class LostFoundRequestPage extends StatefulWidget {
  const LostFoundRequestPage({super.key, required this.requestId});

  final String requestId;

  @override
  State<LostFoundRequestPage> createState() => _LostFoundRequestPageState();
}

class _LostFoundRequestPageState extends State<LostFoundRequestPage> {
  late final LostFoundService _service;

  LostFoundPublicItem? _item;
  bool _loading = true;
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
      final item = await _service.getRequest(widget.requestId);
      if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Theo dõi yêu cầu',
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: FuvekonSpacing.field),
            FilledButton(onPressed: _load, child: const Text('Thử lại')),
          ],
        ),
      );
    }

    final item = _item!;
    final theme = context.fuvekonTheme;
    final steps = _buildSteps(item);

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        children: [
          FuveMintCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: theme.contentOnCard,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    FuveStatusBadge(
                      label: _overallStatusLabel(item),
                      variant: _overallStatusVariant(item),
                    ),
                  ],
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
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
                if (item.location.isNotEmpty) ...[
                  const SizedBox(height: FuvekonSpacing.stackGapMd),
                  Text(
                    item.location,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: theme.contentOnCardMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: FuvekonSpacing.section),
          const FuveSectionHeader(title: 'Tiến trình xử lý'),
          const SizedBox(height: FuvekonSpacing.field),
          FuveMintCard(
            padding: const EdgeInsets.symmetric(
              horizontal: FuvekonSpacing.card,
              vertical: FuvekonSpacing.stackGapMd,
            ),
            child: Column(
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  _TimelineStep(
                    title: steps[i].title,
                    subtitle: steps[i].subtitle,
                    isComplete: steps[i].isComplete,
                    isActive: steps[i].isActive,
                    isLast: i == steps.length - 1,
                  ),
                ],
              ],
            ),
          ),
          if (item.modifiedAt != null) ...[
            const SizedBox(height: FuvekonSpacing.field),
            Text(
              'Cập nhật lần cuối: ${DateFormat('HH:mm dd/MM/yyyy').format(item.modifiedAt!)}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: FuvekonColors.darkTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelineStepData {
  const _TimelineStepData({
    required this.title,
    this.subtitle = '',
    required this.isComplete,
    required this.isActive,
  });

  final String title;
  final String subtitle;
  final bool isComplete;
  final bool isActive;
}

List<_TimelineStepData> _buildSteps(LostFoundPublicItem item) {
  if (item.isLostReport) {
    final submitted = true;
    final reviewing = item.status != 'open' || item.userHasPendingClaim;
    final matched = item.status == 'claimed' || item.status == 'resolved';
    final returned = item.isReturned;

    return [
      _TimelineStepData(
        title: 'Đã gửi báo mất',
        subtitle: 'Ban tổ chức đã nhận thông tin của bạn',
        isComplete: submitted,
        isActive: submitted && !reviewing,
      ),
      _TimelineStepData(
        title: 'Đang đối chiếu',
        subtitle: 'Staff đang so khớp với đồ nhặt được',
        isComplete: reviewing || matched || returned,
        isActive: reviewing && !matched,
      ),
      _TimelineStepData(
        title: 'Đã khớp vật phẩm',
        subtitle: 'Liên hệ quầy Lost & Found để nhận lại',
        isComplete: matched || returned,
        isActive: matched && !returned,
      ),
      _TimelineStepData(
        title: 'Đã trả đồ',
        subtitle: 'Quy trình hoàn tất',
        isComplete: returned,
        isActive: returned,
      ),
    ];
  }

  final claimPending = item.userClaimStatus == 'pending';
  final claimApproved = item.userClaimStatus == 'approved';
  final claimRejected = item.userClaimStatus == 'rejected';
  final returned = item.isReturned;

  return [
    _TimelineStepData(
      title: 'Đã gửi yêu cầu nhận',
      subtitle: 'Yêu cầu của bạn đã được ghi nhận',
      isComplete: true,
      isActive: claimPending,
    ),
    _TimelineStepData(
      title: 'Staff xác minh',
      subtitle: claimRejected
          ? 'Yêu cầu không được chấp nhận'
          : 'Đang đối chiếu mô tả và giấy tờ',
      isComplete: claimApproved || claimRejected || returned,
      isActive: claimPending,
    ),
    _TimelineStepData(
      title: claimRejected ? 'Từ chối' : 'Đã duyệt',
      subtitle: claimRejected
          ? 'Vui lòng liên hệ quầy hỗ trợ nếu cần'
          : 'Chuẩn bị giấy tờ tùy thân đến quầy',
      isComplete: claimApproved || claimRejected || returned,
      isActive: claimApproved && !returned,
    ),
    _TimelineStepData(
      title: 'Đã trả đồ',
      subtitle: 'Hoàn tất bàn giao',
      isComplete: returned,
      isActive: returned,
    ),
  ];
}

String _overallStatusLabel(LostFoundPublicItem item) {
  if (item.isReturned) return 'Hoàn tất';
  if (item.userClaimStatus == 'rejected') return 'Từ chối';
  if (item.userClaimStatus == 'approved') return 'Đã duyệt';
  if (item.userHasPendingClaim || item.status == 'claimed') {
    return 'Đang xử lý';
  }
  if (item.isLostReport) return 'Đã gửi';
  return item.statusLabel;
}

FuveStatusBadgeVariant _overallStatusVariant(LostFoundPublicItem item) {
  if (item.isReturned || item.userClaimStatus == 'approved') {
    return FuveStatusBadgeVariant.success;
  }
  if (item.userClaimStatus == 'rejected') {
    return FuveStatusBadgeVariant.denied;
  }
  if (item.userHasPendingClaim || item.status == 'claimed') {
    return FuveStatusBadgeVariant.pending;
  }
  return FuveStatusBadgeVariant.neutral;
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.isComplete,
    required this.isActive,
    required this.isLast,
  });

  final String title;
  final String subtitle;
  final bool isComplete;
  final bool isActive;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = context.fuvekonTheme;
    final dotColor = isComplete
        ? FuvekonColors.premiumPrimary
        : FuvekonColors.premiumSurfaceContainerHigh;
    final lineColor = isComplete
        ? FuvekonColors.premiumPrimary.withValues(alpha: 0.5)
        : FuvekonColors.premiumSurfaceContainerHigh;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isActive ? FuvekonColors.premiumSecondary : dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isComplete
                          ? FuvekonColors.premiumPrimary
                          : FuvekonColors.premiumOutline,
                      width: isActive ? 2 : 1,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: theme.contentOnCard,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: theme.contentOnCardMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
