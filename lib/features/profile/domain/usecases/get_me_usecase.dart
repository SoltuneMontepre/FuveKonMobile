import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/domain/repositories/profile_repository.dart';

class GetMeUseCase {
  const GetMeUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<Account>> call() => _repository.getMe();
}
