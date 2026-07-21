import 'package:fuvekonmobile/core/api/conbook_api.dart';
import 'package:fuvekonmobile/core/api/panel_api.dart';
import 'package:fuvekonmobile/core/api/talent_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/shared/models/submission_summary.dart';

class AccountSubmissionsService {
  AccountSubmissionsService({
    required PanelApi panelApi,
    required TalentApi talentApi,
    required ConbookApi conbookApi,
  }) : _panelApi = panelApi,
       _talentApi = talentApi,
       _conbookApi = conbookApi;

  final PanelApi _panelApi;
  final TalentApi _talentApi;
  final ConbookApi _conbookApi;

  Future<List<SubmissionSummary>> getAll({bool useMockFallback = true}) async {
    try {
      final results = await Future.wait([
        _loadPanels(),
        _loadTalents(),
        _loadConbooks(),
      ]);
      final combined = [...results[0], ...results[1], ...results[2]];
      combined.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
      if (combined.isEmpty && useMockFallback) return _mockSubmissions;
      return combined;
    } catch (_) {
      if (!useMockFallback) rethrow;
      return _mockSubmissions;
    }
  }

  Future<List<SubmissionSummary>> getPanels({
    bool useMockFallback = true,
  }) async {
    try {
      return await _loadPanels();
    } catch (_) {
      if (!useMockFallback) rethrow;
      return _mockSubmissions
          .where((s) => s.type == SubmissionType.panel)
          .toList();
    }
  }

  Future<List<SubmissionSummary>> getTalents({
    bool useMockFallback = true,
  }) async {
    try {
      return await _loadTalents();
    } catch (_) {
      if (!useMockFallback) rethrow;
      return _mockSubmissions
          .where((s) => s.type == SubmissionType.talent)
          .toList();
    }
  }

  Future<List<SubmissionSummary>> getConbooks({
    bool useMockFallback = true,
  }) async {
    try {
      return await _loadConbooks();
    } catch (_) {
      if (!useMockFallback) rethrow;
      return _mockSubmissions
          .where((s) => s.type == SubmissionType.conbook)
          .toList();
    }
  }

  Future<Map<String, dynamic>> getPanelDetail(String id) async {
    final response = await _panelApi.getById(id);
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.data!;
  }

  Future<Map<String, dynamic>> getTalentDetail(String id) async {
    final response = await _talentApi.getById(id);
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.data!;
  }

  Future<Map<String, dynamic>> getConbookDetail(String id) async {
    final response = await _conbookApi.getById(id);
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.data!;
  }

  Future<Map<String, dynamic>> updateConbook(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final data = await _conbookApi.update(id, payload);
    return data;
  }

  Future<Map<String, dynamic>> updateTalent(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _talentApi.updateTalent(id, payload);
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.data!;
  }

  Future<Map<String, dynamic>> updatePanel(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _panelApi.updatePanel(id, payload);
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.data!;
  }

  Future<List<SubmissionSummary>> _loadPanels() async {
    final response = await _panelApi.getMyPanels();
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.data!
        .whereType<Map<String, dynamic>>()
        .map(SubmissionSummary.panel)
        .toList();
  }

  Future<List<SubmissionSummary>> _loadTalents() async {
    final response = await _talentApi.getMyTalents();
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.data!
        .whereType<Map<String, dynamic>>()
        .map(SubmissionSummary.talent)
        .toList();
  }

  Future<List<SubmissionSummary>> _loadConbooks() async {
    final response = await _conbookApi.getMySubmissions();
    if (!response.isSuccess || response.data == null) {
      throw ServerException(response.errorMessage ?? response.message);
    }
    return response.data!
        .whereType<Map<String, dynamic>>()
        .map(SubmissionSummary.conbook)
        .toList();
  }

  static final _mockSubmissions = [
    SubmissionSummary(
      id: 'mock-panel-1',
      type: SubmissionType.panel,
      title: 'Fursuit Dance Panel',
      status: 'pending',
      subtitle: 'Dance',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    SubmissionSummary(
      id: 'mock-talent-1',
      type: SubmissionType.talent,
      title: 'Live Music Performance',
      status: 'approved',
      subtitle: 'Music',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    SubmissionSummary(
      id: 'mock-conbook-1',
      type: SubmissionType.conbook,
      title: 'My Fursona Portrait',
      status: 'pending',
      subtitle: '@artist_fur',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
