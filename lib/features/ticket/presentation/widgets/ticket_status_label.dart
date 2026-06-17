import 'package:flutter/material.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_status.dart';
import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';

FuveStatusBadgeVariant statusBadgeVariant(TicketStatus status) {
  return switch (status) {
    TicketStatus.approved || TicketStatus.adminGranted =>
      FuveStatusBadgeVariant.success,
    TicketStatus.pending || TicketStatus.selfConfirmed =>
      FuveStatusBadgeVariant.pending,
    TicketStatus.denied => FuveStatusBadgeVariant.denied,
  };
}

String statusBadgeLabel(TicketStatus status) {
  return switch (status) {
    TicketStatus.pending => 'Chờ thanh toán',
    TicketStatus.selfConfirmed => 'Đang xác minh',
    TicketStatus.approved => 'Đã xác nhận',
    TicketStatus.denied => 'Từ chối',
    TicketStatus.adminGranted => 'Cấp bởi admin',
  };
}

class TicketStatusLabel extends StatelessWidget {
  const TicketStatusLabel({super.key, required this.status});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    return FuveStatusBadge(
      label: statusBadgeLabel(status),
      variant: statusBadgeVariant(status),
    );
  }
}
