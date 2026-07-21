import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/domain/repositories/profile_repository.dart';

/// Updates the current user's avatar URL.
class UpdateAvatarUseCase {
  const UpdateAvatarUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<Account>> call(String? avatarUrl) {
    return _repository.updateAvatar(avatarUrl);
  }
}
