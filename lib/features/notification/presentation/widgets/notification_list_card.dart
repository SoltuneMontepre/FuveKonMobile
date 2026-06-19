import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/features/notification/domain/entities/notification_item.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';
import 'package:intl/intl.dart';

class NotificationKindBadge extends StatelessWidget {
  const NotificationKindBadge({super.key, required this.kind});

  final String kind;

  @override
  Widget build(BuildContext context) {
    final (label, variant) = switch (kind) {
      'ticket' => ('Vé', FuveStatusBadgeVariant.success),
      'schedule' => ('Lịch trình', FuveStatusBadgeVariant.pending),
      'reminder' => ('Nhắc nhở', FuveStatusBadgeVariant.neutral),
      'system' => ('Hệ thống', FuveStatusBadgeVariant.neutral),
      _ => ('Thông báo', FuveStatusBadgeVariant.neutral),
    };

    return FuveStatusBadge(label: label, variant: variant);
  }
}

class NotificationListCard extends StatelessWidget {
  const NotificationListCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final NotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = context.fuvekonTheme;
    final timeLabel = DateFormat('HH:mm dd/MM').format(item.createdAt);

    return FuveMintCard(
      onTap: onTap,
      showGoldAccent: !item.isRead,
      padding: const EdgeInsets.all(FuvekonSpacing.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: ext.contentOnCard,
                    fontWeight:
                        item.isRead ? FontWeight.w600 : FontWeight.w700,
                  ),
                ),
              ),
              if (!item.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: FuvekonColors.premiumTertiary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: FuvekonSpacing.stackGapSm),
          Text(
            item.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: ext.contentOnCardMuted,
            ),
          ),
          const SizedBox(height: FuvekonSpacing.stackGapMd),
          Row(
            children: [
              NotificationKindBadge(kind: item.kind),
              const Spacer(),
              Text(
                timeLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: ext.contentOnCardMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
