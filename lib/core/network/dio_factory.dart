import 'package:dio/dio.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/network/interceptors/auth_interceptor.dart';
import 'package:fuvekonmobile/core/network/interceptors/logging_interceptor.dart';
import 'package:fuvekonmobile/core/network/interceptors/token_refresh_interceptor.dart';
import 'package:fuvekonmobile/shared/services/token_storage.dart';

Dio createDio({
  required TokenStorage tokenStorage,
  required Future<String?> Function() refreshToken,
  required void Function() onSessionExpired,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(tokenStorage),
    TokenRefreshInterceptor(
      dio: dio,
      tokenStorage: tokenStorage,
      refreshToken: refreshToken,
      onSessionExpired: onSessionExpired,
    ),
    LoggingInterceptor(),
  ]);

  return dio;
}

Dio createRefreshDio() {
  return Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
}
