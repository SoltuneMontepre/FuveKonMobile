import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/api/health_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';

enum SystemServiceStatus { healthy, warning, error, unknown }

class SystemServiceHealth {
  const SystemServiceHealth({
    required this.name,
    required this.status,
    this.latencyMs,
    this.metricLabel,
    this.metricValue,
    this.trailingIcon,
  });

  final String name;
  final SystemServiceStatus status;
  final int? latencyMs;
  final String? metricLabel;
  final String? metricValue;
  final IconData? trailingIcon;
}

class AdminSystemStatusSnapshot {
  const AdminSystemStatusSnapshot({
    required this.services,
    required this.checkedAt,
  });

  final List<SystemServiceHealth> services;
  final DateTime checkedAt;
}

class AdminSystemStatusService {
  AdminSystemStatusService({required HealthApi healthApi}) : _healthApi = healthApi;

  final HealthApi _healthApi;

  Future<AdminSystemStatusSnapshot> checkAll() async {
    final response = await _healthApi.getSystemHealth();
    if (!response.isSuccess || response.data == null) {
      throw ServerException(
        response.message.isNotEmpty ? response.message : 'Không tải được trạng thái hệ thống',
      );
    }

    final data = response.data!;
    final servicesRaw = data['services'];
    final checkedAtRaw = data['checked_at']?.toString();

    final services = servicesRaw is List
        ? servicesRaw
            .whereType<Map<String, dynamic>>()
            .map(_parseService)
            .toList()
        : <SystemServiceHealth>[];

    return AdminSystemStatusSnapshot(
      services: services,
      checkedAt: checkedAtRaw != null
          ? DateTime.tryParse(checkedAtRaw) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  SystemServiceHealth _parseService(Map<String, dynamic> json) {
    final key = json['key']?.toString() ?? '';
    final status = _parseStatus(json['status']?.toString());
    final hasIcon = json['has_icon'] == true;
    final latencyMs = (json['latency_ms'] as num?)?.toInt();

    return SystemServiceHealth(
      name: json['name']?.toString() ?? key,
      status: status,
      latencyMs: latencyMs,
      metricLabel: json['metric_label']?.toString(),
      metricValue: json['metric_value']?.toString(),
      trailingIcon: hasIcon ? _iconForKey(key) : null,
    );
  }

  SystemServiceStatus _parseStatus(String? raw) {
    return switch (raw) {
      'healthy' => SystemServiceStatus.healthy,
      'warning' => SystemServiceStatus.warning,
      'error' => SystemServiceStatus.error,
      _ => SystemServiceStatus.unknown,
    };
  }

  IconData? _iconForKey(String key) {
    return switch (key) {
      's3' => Icons.cloud_done_outlined,
      _ => null,
    };
  }
}
