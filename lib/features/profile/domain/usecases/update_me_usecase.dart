import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/update_profile_input.dart';
import 'package:fuvekonmobile/features/profile/domain/repositories/profile_repository.dart';

class UpdateMeUseCase {
  const UpdateMeUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<Account>> call(UpdateProfileInput input) {
    return _repository.updateMe(input);
  }
}
