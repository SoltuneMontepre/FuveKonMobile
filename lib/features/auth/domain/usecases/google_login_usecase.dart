import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/user.dart';
import 'package:fuvekonmobile/features/auth/domain/repositories/auth_repository.dart';

class GoogleLoginUseCase {
  const GoogleLoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<User>> call({required String credential}) {
    return _repository.loginWithGoogle(credential: credential);
  }
}
