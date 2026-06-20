import 'package:fuvekonmobile/core/errors/failures.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';

sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}

extension ResultX<T> on Result<T> {
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Error(:final failure) => error(failure),
    };
  }
}

Failure mapExceptionToFailure(Object error) {
  return switch (error) {
    NetworkException(:final message) => NetworkFailure(message),
    ServerException(:final message) => ServerFailure(message),
    CacheException(:final message) => CacheFailure(message),
    AuthException(:final message) => AuthFailure(message),
    UnauthorizedException(:final message) => AuthFailure(message),
    _ => UnknownFailure(error.toString()),
  };
}
