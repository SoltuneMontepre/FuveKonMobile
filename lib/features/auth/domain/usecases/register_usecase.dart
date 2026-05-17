import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/register_input.dart';
import 'package:fuvekonmobile/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call(RegisterInput input) => _repository.register(input);
}
