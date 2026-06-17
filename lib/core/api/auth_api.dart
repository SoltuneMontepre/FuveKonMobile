import 'package:fuvekonmobile/core/constants/api_constants.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';
import 'package:fuvekonmobile/core/network/auth_token_extractor.dart';
import 'package:fuvekonmobile/core/network/base_api.dart';

/// Auth endpoints from Fuvekon `src/hooks/services/auth/*` and auth forms.
class AuthApi extends BaseApi {
  AuthApi(super.client);

  /// Login and return JWT. Backend sets `access_token` cookie; body `data` is null.
  Future<String> loginAndExtractToken({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.postWithResponse(
      ApiConstants.login,
      data: {
        'email': email.trim().toLowerCase(),
        'password': password,
      },
    );

    final body = response.data;
    if (body != null) {
      final envelope = ApiResponse<dynamic>.fromJson(body);
      if (!envelope.isSuccess) {
        throw ServerException(
          envelope.errorMessage ?? envelope.message,
        );
      }
    }

    final token = AuthTokenExtractor.fromResponse(response);
    if (token == null || token.isEmpty) {
      throw const ServerException('Login did not return an access token.');
    }
    return token;
  }

  /// Google Sign-In: verify ID token (`credential`) and return JWT.
  Future<String> googleLoginAndExtractToken(Map<String, dynamic> body) async {
    final response = await apiClient.postWithResponse(
      ApiConstants.googleAuth,
      data: body,
    );

    final responseBody = response.data;
    if (responseBody != null) {
      final envelope = ApiResponse<dynamic>.fromJson(responseBody);
      if (!envelope.isSuccess) {
        throw ServerException(
          envelope.errorMessage ?? envelope.message,
        );
      }
    }

    final token = AuthTokenExtractor.fromResponse(response);
    if (token == null || token.isEmpty) {
      throw const ServerException('Google sign-in did not return an access token.');
    }
    return token;
  }

  Future<ApiResponse<void>> logout() {
    return post<void>(ApiConstants.logout, throwOnFailure: false);
  }

  Future<ApiResponse<Map<String, dynamic>?>> register(
    Map<String, dynamic> payload,
  ) {
    return post(
      ApiConstants.register,
      data: payload,
      mapData: mapJsonObject,
    );
  }

  Future<ApiResponse<void>> verifyOtp({
    required String email,
    required String otp,
  }) {
    return post<void>(
      ApiConstants.verifyOtp,
      data: {'email': email, 'otp': otp},
    );
  }

  Future<ApiResponse<void>> resendOtp({required String email}) {
    return post<void>(
      ApiConstants.resendOtp,
      data: {'email': email},
    );
  }

  Future<ApiResponse<void>> forgotPassword({required String email}) {
    return post<void>(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );
  }

  Future<ApiResponse<void>> changePassword(Map<String, dynamic> payload) {
    return post<void>(ApiConstants.changePassword, data: payload);
  }

  Future<ApiResponse<void>> resetPasswordConfirm({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) {
    return post<void>(
      ApiConstants.resetPasswordConfirm,
      data: {
        'token': token,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
  }
}

/// Account / `users/me` endpoints from `useAccount.ts`.
class AccountApi extends BaseApi {
  AccountApi(super.client);

  Future<ApiResponse<AccountJson>> getMe() {
    return get(
      ApiConstants.usersMe,
      mapData: (value) => AccountJson.fromJson(mapJsonObject(value)!),
    );
  }

  Future<ApiResponse<AccountJson>> updateMe(Map<String, dynamic> payload) {
    return put(
      ApiConstants.usersMe,
      data: payload,
      mapData: (value) => AccountJson.fromJson(mapJsonObject(value)!),
    );
  }

  Future<ApiResponse<AccountJson>> updateAvatar(
    Map<String, dynamic> payload,
  ) {
    return patch(
      ApiConstants.usersMeAvatar,
      data: payload,
      mapData: (value) => AccountJson.fromJson(mapJsonObject(value)!),
    );
  }

  Future<ApiResponse<List<String>>> getMyPermissions({
    bool throwOnFailure = true,
  }) {
    return get(
      ApiConstants.usersMePermissions,
      mapData: (value) {
        final map = mapJsonObject(value);
        final raw = map?['permissions'];
        if (raw is! List) return const <String>[];
        return raw.whereType<String>().toList();
      },
      throwOnFailure: throwOnFailure,
    );
  }
}

/// Parsed account from `GET /users/me` (Fuvekon `Account` model).
class AccountJson {
  const AccountJson({
    required this.id,
    required this.email,
    this.fursonaName,
    this.firstName,
    this.lastName,
    this.country,
    this.idCard,
    this.dateOfBirth,
    this.avatar,
    this.role,
    this.isVerified,
    this.isDealer,
    this.isBlacklisted,
    this.isHasTicket,
  });

  final String id;
  final String email;
  final String? fursonaName;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? idCard;
  final String? dateOfBirth;
  final String? avatar;
  final String? role;
  final bool? isVerified;
  final bool? isDealer;
  final bool? isBlacklisted;
  final bool? isHasTicket;

  factory AccountJson.fromJson(Map<String, dynamic> json) {
    return AccountJson(
      id: json['id'] as String,
      email: json['email'] as String,
      fursonaName: json['fursona_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      country: json['country'] as String?,
      idCard: json['id_card'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String?,
      isVerified: json['is_verified'] as bool?,
      isDealer: json['is_dealer'] as bool?,
      isBlacklisted: json['is_blacklisted'] as bool? ??
          json['is_banned'] as bool?,
      isHasTicket: json['is_has_ticket'] as bool?,
    );
  }

  String? get displayName {
    if (fursonaName != null && fursonaName!.isNotEmpty) return fursonaName;
    final parts = [firstName, lastName].whereType<String>().where(
          (s) => s.isNotEmpty,
        );
    final joined = parts.join(' ').trim();
    return joined.isEmpty ? null : joined;
  }
}
