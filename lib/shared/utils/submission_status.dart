import 'package:fuvekonmobile/shared/widgets/fuve_status_badge.dart';

FuveStatusBadgeVariant statusBadgeVariant(String? status) => switch (status) {
  'approved' => FuveStatusBadgeVariant.success,
  'denied' => FuveStatusBadgeVariant.denied,
  'require_changes' => FuveStatusBadgeVariant.pending,
  'pending' => FuveStatusBadgeVariant.pending,
  _ => FuveStatusBadgeVariant.neutral,
};

String statusLabelVi(String? status) => switch (status) {
  'approved' => 'Đã duyệt',
  'require_changes' => 'Cần chỉnh sửa',
  'denied' => 'Từ chối',
  'pending' => 'Chờ duyệt',
  _ => 'Không rõ',
};

bool submissionNeedsFix(String? status) => status == 'require_changes';
