import 'package:dio/dio.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';

Never throwMappedDioException(DioException error) {
  throw switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError =>
      const NetworkException(),
    DioExceptionType.badResponse => _mapBadResponse(error),
    DioExceptionType.cancel => const ServerException('Request cancelled.'),
    _ => const ServerException(),
  };
}

String? _apiErrorMessage(DioException error) {
  final data = error.response?.data;
  if (data is Map) {
    final map = Map<String, dynamic>.from(data);
    final errorMessage = map['errorMessage'] as String?;
    if (errorMessage != null && errorMessage.isNotEmpty) {
      return errorMessage;
    }
    final message = map['message'] as String?;
    if (message != null && message.isNotEmpty) {
      return message;
    }
  }
  return null;
}

bool _isLoginRequest(DioException error) {
  return error.requestOptions.path.contains('/auth/login');
}

AppException _mapBadResponse(DioException error) {
  final statusCode = error.response?.statusCode;
  final apiMessage = _apiErrorMessage(error);

  if (statusCode == 401) {
    if (_isLoginRequest(error)) {
      return AuthException(
        _loginErrorLabel(apiMessage),
      );
    }
    return UnauthorizedException(apiMessage ?? 'Session expired.');
  }
  if (statusCode == 403) {
    return AuthException(apiMessage ?? 'Access denied.');
  }
  if (statusCode == 429) {
    return AuthException(apiMessage ?? 'Too many attempts. Try again later.');
  }
  if (statusCode != null && statusCode >= 500 && statusCode < 600) {
    return const ServerException();
  }
  return ServerException(apiMessage ?? error.response?.statusMessage ?? 'Request failed.');
}

String _loginErrorLabel(String? errorMessage) {
  return switch (errorMessage) {
    'invalidEmailOrPassword' => 'Invalid email or password.',
    'accountLocked' => 'Too many failed attempts. Try again later.',
    'userNotVerified' => 'Please verify your email before signing in.',
    'accountBanned' => 'This account has been banned.',
    _ => errorMessage ?? 'Invalid email or password.',
  };
}
