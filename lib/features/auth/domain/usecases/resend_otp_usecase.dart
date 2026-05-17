import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/auth/domain/repositories/auth_repository.dart';

class ResendOtpUseCase {
  const ResendOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call({required String email}) {
    return _repository.resendOtp(email: email);
  }
}
