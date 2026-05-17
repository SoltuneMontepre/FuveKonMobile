import 'package:dio/dio.dart';
import 'package:fuvekonmobile/core/network/api_client.dart';
import 'package:fuvekonmobile/core/network/dio_factory.dart';
import 'package:fuvekonmobile/core/router/app_router.dart';
import 'package:fuvekonmobile/core/router/auth_session_notifier.dart';
import 'package:fuvekonmobile/core/di/api_injection.dart';
import 'package:fuvekonmobile/features/auth/di/auth_injection.dart';
import 'package:fuvekonmobile/shared/services/token_refresh_service.dart';
import 'package:fuvekonmobile/shared/services/token_storage.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl
    ..registerLazySingleton<TokenStorage>(SecureTokenStorage.new)
    ..registerLazySingleton(() => TokenRefreshService(tokenStorage: sl()))
    ..registerLazySingleton<Dio>(
      () => createDio(
        tokenStorage: sl(),
        refreshToken: sl<TokenRefreshService>().refresh,
      ),
    )
    ..registerLazySingleton(() => ApiClient(sl()))
    ..registerLazySingleton(AuthSessionNotifier.new)
    ..registerLazySingleton(() => AppRouter(authSessionNotifier: sl()));

  registerApiModule(sl);
  registerAuthModule(sl);
}
