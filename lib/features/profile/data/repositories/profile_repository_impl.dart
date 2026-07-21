import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/update_profile_input.dart';
import 'package:fuvekonmobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Result<Account>> getMe() async {
    try {
      final account = await _remoteDataSource.getMe();
      return Success(account);
    } on AppException catch (error) {
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      return Error(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<Account>> updateMe(UpdateProfileInput input) async {
    try {
      final account = await _remoteDataSource.updateMe(input);
      return Success(account);
    } on AppException catch (error) {
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      return Error(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<Account>> updateAvatar(String? avatarUrl) async {
    try {
      final account = await _remoteDataSource.updateAvatar(avatarUrl);
      return Success(account);
    } on AppException catch (error) {
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      return Error(mapExceptionToFailure(error));
    }
  }
}
