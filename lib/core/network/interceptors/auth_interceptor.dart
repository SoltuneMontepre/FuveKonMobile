import 'package:dio/dio.dart';
import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/shared/services/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  static const _publicPathFragments = [
    ApiConstants.login,
    ApiConstants.register,
    ApiConstants.verifyOtp,
    ApiConstants.resendOtp,
    ApiConstants.forgotPassword,
    ApiConstants.resetPasswordConfirm,
  ];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isPublicAuthRoute(options.path)) {
      return handler.next(options);
    }

    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  bool _isPublicAuthRoute(String path) {
    return _publicPathFragments.any(path.contains);
  }
}
