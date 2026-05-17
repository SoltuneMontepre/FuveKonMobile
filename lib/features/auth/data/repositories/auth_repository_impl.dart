import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fuvekonmobile/features/auth/data/mappers/user_mapper.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/user.dart';
import 'package:fuvekonmobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:fuvekonmobile/shared/services/token_refresh_service.dart';
import 'package:fuvekonmobile/shared/services/token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenStorage tokenStorage,
    required TokenRefreshService tokenRefreshService,
  })  : _remoteDataSource = remoteDataSource,
        _tokenStorage = tokenStorage,
        _tokenRefreshService = tokenRefreshService;

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;
  final TokenRefreshService _tokenRefreshService;

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      await _tokenStorage.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );

      return Success(UserMapper.toEntity(result.user));
    } on AppException catch (error) {
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      return Error(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final hasToken = await isLoggedIn();
      if (hasToken) {
        await _remoteDataSource.logout();
      }
      await _tokenStorage.clearTokens();
      return const Success(null);
    } on AppException catch (error) {
      await _tokenStorage.clearTokens();
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      await _tokenStorage.clearTokens();
      return Error(mapExceptionToFailure(error));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> refreshAccessToken() => _tokenRefreshService.refresh();
}
