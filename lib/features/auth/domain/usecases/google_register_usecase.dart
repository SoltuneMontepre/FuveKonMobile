import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/google_register_input.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/user.dart';
import 'package:fuvekonmobile/features/auth/domain/repositories/auth_repository.dart';

class GoogleRegisterUseCase {
  const GoogleRegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<User>> call(GoogleRegisterInput input) {
    return _repository.registerWithGoogle(input);
  }
}
