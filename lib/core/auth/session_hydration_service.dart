import 'dart:async';

import 'package:fuvekonmobile/core/api/auth_api.dart';
import 'package:fuvekonmobile/core/auth/auth_session_controller.dart';
import 'package:fuvekonmobile/core/auth/user_role.dart';
import 'package:fuvekonmobile/core/errors/failures.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/services/push_notification_service.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_unread_cubit.dart';
import 'package:fuvekonmobile/features/profile/domain/usecases/get_me_usecase.dart';

/// Loads the signed-in account role and permissions after auth is restored.
class SessionHydrationService {
  SessionHydrationService({
    required AuthSessionNotifier notifier,
    required GetMeUseCase getMeUseCase,
    required AccountApi accountApi,
    required AuthSessionController sessionController,
    PushNotificationService? pushNotificationService,
  }) : _notifier = notifier,
       _getMeUseCase = getMeUseCase,
       _accountApi = accountApi,
       _sessionController = sessionController,
       _pushNotificationService = pushNotificationService;

  final AuthSessionNotifier _notifier;
  final GetMeUseCase _getMeUseCase;
  final AccountApi _accountApi;
  final AuthSessionController _sessionController;
  final PushNotificationService? _pushNotificationService;
  Future<void>? _inFlight;

  Future<void> hydrate({bool force = false}) async {
    if (!_notifier.isAuthenticated) {
      await _inFlight;
      _inFlight = null;
      _notifier.clearHydrationProfile();
      return;
    }

    if (!force) {
      if (_inFlight != null) {
        return _inFlight;
      }
      final status = _notifier.hydrationStatus;
      if (status == SessionHydrationStatus.loading ||
          status == SessionHydrationStatus.success) {
        return;
      }
    }

    final task = _runHydration();
    _inFlight = task;
    try {
      await task;
    } finally {
      if (identical(_inFlight, task)) {
        _inFlight = null;
      }
    }
  }

  Future<void> _runHydration() async {
    _notifier.beginHydration();

    try {
      final result = await _getMeUseCase();

      switch (result) {
        case Success(:final data):
          _notifier.applyHydrationProfile(
            role: UserRole.tryParse(data.role),
            isVerified: data.isVerified,
            permissions: await _loadPermissions(),
            success: true,
          );
          unawaited(_syncPushNotifications());
          unawaited(_refreshNotificationUnreadCount());
        case Error(:final failure):
          if (failure is AuthFailure) {
            // Stale token (e.g. after DB reseed) or revoked session.
            _sessionController.notifySessionExpired();
          }
          _failHydration(failure.message);
      }
    } catch (error) {
      _failHydration(mapExceptionToFailure(error).message);
    }
  }

  Future<List<String>> _loadPermissions() async {
    try {
      final permsResult = await _accountApi.getMyPermissions(
        throwOnFailure: false,
      );
      if (permsResult.isSuccess && permsResult.data != null) {
        return permsResult.data!;
      }
    } catch (_) {
      // Permissions are optional; HTTP failures are ignored here.
    }
    return const [];
  }

  Future<void> _syncPushNotifications() async {
    await _pushNotificationService?.initialize();
    await _pushNotificationService?.registerTokenIfAuthenticated();
  }

  Future<void> _refreshNotificationUnreadCount() async {
    try {
      await sl<NotificationUnreadCubit>().refresh();
    } catch (_) {
      // Unread badge refresh is best-effort.
    }
  }

  void _failHydration(String message) {
    _notifier.applyHydrationProfile(
      role: null,
      isVerified: null,
      permissions: const [],
      success: false,
      error: message,
    );
  }
}
