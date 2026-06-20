import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum ScanOutcome { valid, rejected, reused }

class ScanRecord {
  const ScanRecord({
    required this.id,
    required this.code,
    required this.outcome,
    required this.scannedAt,
    this.holderName,
    this.tierName,
    this.message,
  });

  final String id;
  final String code;
  final ScanOutcome outcome;
  final DateTime scannedAt;
  final String? holderName;
  final String? tierName;
  final String? message;

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'outcome': outcome.name,
    'scanned_at': scannedAt.toIso8601String(),
    'holder_name': holderName,
    'tier_name': tierName,
    'message': message,
  };

  factory ScanRecord.fromJson(Map<String, dynamic> json) {
    return ScanRecord(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      outcome: ScanOutcome.values.firstWhere(
        (e) => e.name == json['outcome'],
        orElse: () => ScanOutcome.rejected,
      ),
      scannedAt:
          DateTime.tryParse(json['scanned_at'] as String? ?? '') ??
          DateTime.now(),
      holderName: json['holder_name'] as String?,
      tierName: json['tier_name'] as String?,
      message: json['message'] as String?,
    );
  }
}

class ScanShiftStats {
  const ScanShiftStats({
    required this.total,
    required this.valid,
    required this.rejected,
    required this.reused,
    required this.lastUpdated,
  });

  final int total;
  final int valid;
  final int rejected;
  final int reused;
  final DateTime? lastUpdated;

  static const empty = ScanShiftStats(
    total: 0,
    valid: 0,
    rejected: 0,
    reused: 0,
    lastUpdated: null,
  );
}

/// Persists on-device scan history and shift counters for staff check-in.
class ScanSessionStore {
  ScanSessionStore(this._prefs);

  static const _historyKey = 'scan_history_v1';
  static const _statsDateKey = 'scan_stats_date_v1';
  static const _statsTotalKey = 'scan_stats_total_v1';
  static const _statsValidKey = 'scan_stats_valid_v1';
  static const _statsRejectedKey = 'scan_stats_rejected_v1';
  static const _statsReusedKey = 'scan_stats_reused_v1';
  static const _statsUpdatedKey = 'scan_stats_updated_v1';
  static const _maxHistory = 200;

  final SharedPreferences _prefs;

  static Future<ScanSessionStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ScanSessionStore(prefs);
  }

  Future<List<ScanRecord>> getHistory() async {
    final raw = _prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map>()
          .map((e) => ScanRecord.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<ScanShiftStats> getTodayStats() async {
    await _resetIfNewDay();
    return ScanShiftStats(
      total: _prefs.getInt(_statsTotalKey) ?? 0,
      valid: _prefs.getInt(_statsValidKey) ?? 0,
      rejected: _prefs.getInt(_statsRejectedKey) ?? 0,
      reused: _prefs.getInt(_statsReusedKey) ?? 0,
      lastUpdated: DateTime.tryParse(_prefs.getString(_statsUpdatedKey) ?? ''),
    );
  }

  Future<void> recordScan(ScanRecord record) async {
    await _resetIfNewDay();

    final history = await getHistory();
    history.insert(0, record);
    if (history.length > _maxHistory) {
      history.removeRange(_maxHistory, history.length);
    }
    await _prefs.setString(
      _historyKey,
      jsonEncode(history.map((e) => e.toJson()).toList()),
    );

    await _prefs.setInt(
      _statsTotalKey,
      (_prefs.getInt(_statsTotalKey) ?? 0) + 1,
    );
    switch (record.outcome) {
      case ScanOutcome.valid:
        await _prefs.setInt(
          _statsValidKey,
          (_prefs.getInt(_statsValidKey) ?? 0) + 1,
        );
      case ScanOutcome.rejected:
        await _prefs.setInt(
          _statsRejectedKey,
          (_prefs.getInt(_statsRejectedKey) ?? 0) + 1,
        );
      case ScanOutcome.reused:
        await _prefs.setInt(
          _statsReusedKey,
          (_prefs.getInt(_statsReusedKey) ?? 0) + 1,
        );
    }
    await _prefs.setString(_statsUpdatedKey, DateTime.now().toIso8601String());
  }

  Future<void> _resetIfNewDay() async {
    final today = _dateKey(DateTime.now());
    final stored = _prefs.getString(_statsDateKey);
    if (stored == today) return;

    await _prefs.setString(_statsDateKey, today);
    await _prefs.setInt(_statsTotalKey, 0);
    await _prefs.setInt(_statsValidKey, 0);
    await _prefs.setInt(_statsRejectedKey, 0);
    await _prefs.setInt(_statsReusedKey, 0);
    await _prefs.remove(_statsUpdatedKey);
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
