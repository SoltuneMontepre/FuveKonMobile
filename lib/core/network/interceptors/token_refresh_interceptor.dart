import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/shared/services/token_storage.dart';

class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
    required Future<String?> Function() refreshToken,
    required void Function() onSessionExpired,
  })  : _dio = dio,
        _tokenStorage = tokenStorage,
        _refreshToken = refreshToken,
        _onSessionExpired = onSessionExpired;

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final Future<String?> Function() _refreshToken;
  final void Function() _onSessionExpired;

  bool _isRefreshing = false;
  final List<Completer<void>> _refreshQueue = [];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 ||
        _shouldSkipRefresh(err.requestOptions.path)) {
      return handler.next(err);
    }

    try {
      await _synchronizedRefresh();
      final response = await _retry(err.requestOptions);
      return handler.resolve(response);
    } catch (error) {
      await _tokenStorage.clearTokens();
      _onSessionExpired();
      return handler.next(err);
    }
  }

  bool _shouldSkipRefresh(String path) {
    return path.contains(ApiConstants.login) ||
        path.contains(ApiConstants.register) ||
        path.contains(ApiConstants.verifyOtp);
  }

  Future<void> _synchronizedRefresh() async {
    if (_isRefreshing) {
      final completer = Completer<void>();
      _refreshQueue.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    try {
      final newToken = await _refreshToken();
      if (newToken == null || newToken.isEmpty) {
        throw DioException(requestOptions: RequestOptions(path: ''));
      }
      for (final completer in _refreshQueue) {
        if (!completer.isCompleted) completer.complete();
      }
    } catch (error) {
      for (final completer in _refreshQueue) {
        if (!completer.isCompleted) completer.completeError(error);
      }
      rethrow;
    } finally {
      _refreshQueue.clear();
      _isRefreshing = false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
