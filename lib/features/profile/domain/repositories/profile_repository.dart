import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/update_profile_input.dart';

abstract interface class ProfileRepository {
  Future<Result<Account>> getMe();

  Future<Result<Account>> updateMe(UpdateProfileInput input);
}
