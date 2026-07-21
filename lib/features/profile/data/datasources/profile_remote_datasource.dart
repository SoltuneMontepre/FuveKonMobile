import 'package:fuvekonmobile/core/api/auth_api.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/update_profile_input.dart';

abstract interface class ProfileRemoteDataSource {
  Future<Account> getMe();

  Future<Account> updateMe(UpdateProfileInput input);

  /// Updates the avatar URL. Pass `null` or an empty string to clear it.
  Future<Account> updateAvatar(String? avatarUrl);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({required AccountApi accountApi})
    : _accountApi = accountApi;

  final AccountApi _accountApi;

  @override
  Future<Account> getMe() async {
    final response = await _accountApi.getMe();
    final data = response.data;
    if (data == null) {
      throw const ServerException('Failed to load profile.');
    }
    return _toEntity(data);
  }

  @override
  Future<Account> updateMe(UpdateProfileInput input) async {
    final response = await _accountApi.updateMe(input.toPayload());
    final data = response.data;
    if (data == null) {
      throw const ServerException('Failed to update profile.');
    }
    return _toEntity(data);
  }

  @override
  Future<Account> updateAvatar(String? avatarUrl) async {
    final response = await _accountApi.updateAvatar({'avatar': avatarUrl ?? ''});
    final data = response.data;
    if (data == null) {
      throw const ServerException('Failed to update avatar.');
    }
    return _toEntity(data);
  }

  Account _toEntity(AccountJson json) {
    return Account(
      id: json.id,
      email: json.email,
      fursonaName: json.fursonaName,
      firstName: json.firstName,
      lastName: json.lastName,
      country: json.country,
      idCard: json.idCard,
      dateOfBirth: json.dateOfBirth,
      avatar: json.avatar,
      role: json.role,
      isVerified: json.isVerified,
      isDealer: json.isDealer,
      isBlacklisted: json.isBlacklisted,
      isHasTicket: json.isHasTicket,
    );
  }
}
