import 'package:dio/dio.dart';
import 'package:fuvekonmobile/core/auth/auth_session_controller.dart';
import 'package:fuvekonmobile/core/network/api_client.dart';
import 'package:fuvekonmobile/core/network/dio_factory.dart';
import 'package:fuvekonmobile/core/router/app_router.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/di/api_injection.dart';
import 'package:fuvekonmobile/features/auth/di/auth_injection.dart';
import 'package:fuvekonmobile/features/profile/di/profile_injection.dart';
import 'package:fuvekonmobile/features/ticket/di/ticket_injection.dart';
import 'package:fuvekonmobile/shared/services/app_preferences.dart';
import 'package:fuvekonmobile/shared/services/scan_session_store.dart';
import 'package:fuvekonmobile/shared/services/token_refresh_service.dart';
import 'package:fuvekonmobile/shared/services/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/locale/locale_notifier.dart';
import 'package:fuvekonmobile/core/theme/theme_mode_notifier.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  final appPreferences = await SharedAppPreferences.create();
  final scanSessionStore = await ScanSessionStore.create();
  final savedLanguage = await appPreferences.languageCode;
  final savedThemeMode = await appPreferences.themeMode;

  sl
    ..registerSingleton<AppPreferences>(appPreferences)
    ..registerSingleton<ScanSessionStore>(scanSessionStore)
    ..registerLazySingleton(
      () => LocaleNotifier(
        initialLocale: savedLanguage != null
            ? Locale(savedLanguage)
            : const Locale('vi'),
      ),
    )
    ..registerLazySingleton(
      () => ThemeModeNotifier(initialMode: savedThemeMode),
    )
    ..registerLazySingleton<TokenStorage>(SecureTokenStorage.new)
    ..registerLazySingleton(AuthSessionController.new)
    ..registerLazySingleton(() => TokenRefreshService(tokenStorage: sl()))
    ..registerLazySingleton<Dio>(
      () => createDio(
        tokenStorage: sl(),
        refreshToken: sl<TokenRefreshService>().refresh,
        onSessionExpired: sl<AuthSessionController>().notifySessionExpired,
      ),
    )
    ..registerLazySingleton(() => ApiClient(sl()))
    ..registerLazySingleton(AuthSessionNotifier.new)
    ..registerLazySingleton(() => AppRouter(authSessionNotifier: sl()));

  registerApiModule(sl);
  registerAuthModule(sl);
  registerProfileModule(sl);
  registerTicketModule(sl);
}
