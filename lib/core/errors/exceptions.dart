sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred.']);
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection.']);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Local storage error.']);
}

final class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed.']);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Session expired.']);
}
