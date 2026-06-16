import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_system_status_service.dart';

class SystemStatusSection extends StatelessWidget {
  const SystemStatusSection({
    super.key,
    required this.snapshot,
    this.loading = false,
    this.onRefresh,
  });

  final AdminSystemStatusSnapshot? snapshot;
  final bool loading;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trạng thái hệ thống',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: FuvekonColors.darkAppBarTitle,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Giám sát các dịch vụ cốt lõi theo thời gian thực.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: FuvekonColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onRefresh != null)
              IconButton(
                onPressed: loading ? null : onRefresh,
                icon: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh_rounded),
                color: FuvekonColors.darkTextSecondary,
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (snapshot == null && loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (snapshot != null)
          ...snapshot!.services.map(
            (service) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SystemStatusCard(service: service),
            ),
          ),
      ],
    );
  }
}

class _SystemStatusCard extends StatelessWidget {
  const _SystemStatusCard({required this.service});

  final SystemServiceHealth service;

  static const _warningColor = Color(0xFFFBBF24);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWarning = service.status == SystemServiceStatus.warning;
    final isError = service.status == SystemServiceStatus.error;
    final accent = isWarning
        ? _warningColor
        : isError
            ? const Color(0xFFF0A0A8)
            : FuvekonColors.available;

    final statusLabel = switch (service.status) {
      SystemServiceStatus.healthy => 'Hoạt động',
      SystemServiceStatus.warning => 'Cảnh báo',
      SystemServiceStatus.error => 'Lỗi',
      SystemServiceStatus.unknown => 'Không rõ',
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FuvekonColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: isWarning
            ? Border(
                left: BorderSide(color: accent, width: 3),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isWarning ? accent : FuvekonColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        statusLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: FuvekonColors.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (service.trailingIcon != null)
              Icon(
                service.trailingIcon,
                color: FuvekonColors.darkTextSecondary,
                size: 28,
              )
            else if (service.metricValue != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    service.metricValue!,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: isWarning || isError
                          ? accent
                          : FuvekonColors.darkText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (service.metricLabel != null)
                    Text(
                      service.metricLabel!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: FuvekonColors.darkTextSecondary,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
