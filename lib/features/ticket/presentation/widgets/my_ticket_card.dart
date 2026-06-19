import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/core/theme/fuvekon_theme_extension.dart';
import 'package:fuvekonmobile/core/utils/ticket_price.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/presentation/widgets/ticket_status_label.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_mint_card.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_pill_button.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyTicketCard extends StatelessWidget {
  const MyTicketCard({
    super.key,
    required this.ticket,
    this.onPay,
    this.onUpgrade,
  });

  final UserTicket ticket;
  final VoidCallback? onPay;
  final VoidCallback? onUpgrade;

  bool get _showQrCode =>
      ticket.status == TicketStatus.approved ||
      ticket.status == TicketStatus.adminGranted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = context.fuvekonTheme;
    final locale = Localizations.localeOf(context);
    final tier = ticket.tier;
    final dateFormat = DateFormat.yMMMd(locale.toString());

    return FuveMintCard(
      showGoldAccent: _showQrCode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vé của tôi',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: ext.contentOnCard,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (tier != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        tier.ticketName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: ext.contentOnCardMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              TicketStatusLabel(status: ticket.status),
            ],
          ),
          if (_showQrCode) ...[
            const SizedBox(height: FuvekonSpacing.stackGapLg),
            _EticketQrSection(ticket: ticket),
          ],
          const SizedBox(height: FuvekonSpacing.stackGapLg),
          _InfoRow(
            label: 'Mã tham chiếu',
            value: ticket.referenceCode,
            mono: true,
          ),
          if (tier != null)
            _InfoRow(
              label: 'Giá vé',
              value: formatTierPrice(tier, locale: locale),
            ),
          _InfoRow(
            label: 'Ngày mua',
            value: dateFormat.format(ticket.createdAt.toLocal()),
          ),
          if (ticket.ticketNumber > 0)
            _InfoRow(
              label: 'Số vé',
              value: '#${ticket.ticketNumber}',
            ),
          const SizedBox(height: FuvekonSpacing.stackGapSm),
          _StatusMessage(status: ticket.status, denialReason: ticket.denialReason),
          if (onPay != null) ...[
            const SizedBox(height: FuvekonSpacing.stackGapMd),
            FuvePillButton(
              label: 'Thanh toán ngay',
              icon: Icons.payment_outlined,
              onPressed: onPay,
            ),
          ],
          if (onUpgrade != null) ...[
            const SizedBox(height: FuvekonSpacing.stackGapSm),
            FuvePillButton(
              label: 'Nâng cấp vé',
              icon: Icons.upgrade_outlined,
              variant: FuvePillButtonVariant.outline,
              onPressed: onUpgrade,
            ),
          ],
        ],
      ),
    );
  }
}

class _EticketQrSection extends StatelessWidget {
  const _EticketQrSection({required this.ticket});

  final UserTicket ticket;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'E-ticket',
          style: theme.textTheme.labelSmall?.copyWith(
            color: ext.contentOnCardMuted,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: FuvekonSpacing.stackGapMd),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(FuvekonRadii.input),
            border: Border.all(
              color: FuvekonColors.premiumDecorativeGold.withValues(alpha: 0.35),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: QrImageView(
              data: ticket.id,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: FuvekonColors.premiumOnMintCard,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: FuvekonColors.premiumOnMintCard,
              ),
            ),
          ),
        ),
        const SizedBox(height: FuvekonSpacing.stackGapSm),
        Text(
          'Xuất trình mã QR tại cổng check-in',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: ext.contentOnCardMuted,
          ),
        ),
      ],
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.status,
    this.denialReason,
  });

  final TicketStatus status;
  final String? denialReason;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;
    final theme = Theme.of(context);

    final message = switch (status) {
      TicketStatus.pending =>
        'Vui lòng hoàn tất thanh toán để xác nhận vé của bạn.',
      TicketStatus.selfConfirmed =>
        'Chúng tôi đã nhận xác nhận thanh toán. Thời gian xác minh: 3–5 ngày làm việc.',
      TicketStatus.denied => denialReason?.isNotEmpty == true
          ? 'Từ chối: $denialReason'
          : 'Vé của bạn đã bị từ chối.',
      TicketStatus.approved => 'Vé đã được xác nhận. Hẹn gặp bạn tại sự kiện!',
      TicketStatus.adminGranted => 'Vé này được cấp bởi ban tổ chức.',
    };

    final color = switch (status) {
      TicketStatus.denied => theme.colorScheme.error,
      TicketStatus.approved || TicketStatus.adminGranted => ext.contentOnCard,
      _ => ext.contentOnCardMuted,
    };

    return Text(
      message,
      style: theme.textTheme.bodyMedium?.copyWith(color: color),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final ext = context.fuvekonTheme;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: ext.contentOnCardMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: ext.contentOnCard,
              fontFamily: mono ? 'monospace' : null,
              fontWeight: mono ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
