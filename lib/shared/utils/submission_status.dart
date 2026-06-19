import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';

FuveStatusBadgeVariant statusBadgeVariant(String? status) => switch (status) {
      'approved' => FuveStatusBadgeVariant.success,
      'denied' => FuveStatusBadgeVariant.denied,
      'pending' => FuveStatusBadgeVariant.pending,
      _ => FuveStatusBadgeVariant.neutral,
    };

String statusLabelVi(String? status) => switch (status) {
      'approved' => 'Đã duyệt',
      'denied' => 'Từ chối',
      'pending' => 'Chờ duyệt',
      _ => 'Không rõ',
    };
