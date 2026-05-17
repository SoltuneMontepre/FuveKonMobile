import 'package:fuvekonmobile/core/api/auth_api.dart';
import 'package:fuvekonmobile/features/auth/data/models/auth_tokens_model.dart';
import 'package:fuvekonmobile/features/auth/data/models/user_model.dart';
import 'package:fuvekonmobile/shared/services/token_storage.dart';

abstract interface class AuthRemoteDataSource {
  Future<({AuthTokensModel tokens, UserModel user})> login({
    required String email,
    required String password,
  });

  Future<({AuthTokensModel tokens, UserModel user})> loginWithGoogle(
    Map<String, dynamic> body,
  );

  Future<void> logout();

  Future<void> register(Map<String, dynamic> payload);

  Future<void> forgotPassword({required String email});

  Future<void> verifyOtp({required String email, required String otp});

  Future<void> resendOtp({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required AuthApi authApi,
    required AccountApi accountApi,
    required TokenStorage tokenStorage,
  })  : _authApi = authApi,
        _accountApi = accountApi,
        _tokenStorage = tokenStorage;

  final AuthApi _authApi;
  final AccountApi _accountApi;
  final TokenStorage _tokenStorage;

  @override
  Future<({AuthTokensModel tokens, UserModel user})> login({
    required String email,
    required String password,
  }) async {
    final accessToken = await _authApi.loginAndExtractToken(
      email: email,
      password: password,
    );

    final tokens = AuthTokensModel(accessToken: accessToken);

    await _tokenStorage.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );

    final meResponse = await _accountApi.getMe();
    final account = meResponse.data;
    if (account == null) {
      throw const FormatException('Failed to load user profile after login');
    }

    final user = UserModel(
      id: account.id,
      email: account.email,
      name: account.displayName,
    );

    return (tokens: tokens, user: user);
  }

  @override
  Future<({AuthTokensModel tokens, UserModel user})> loginWithGoogle(
    Map<String, dynamic> body,
  ) async {
    final accessToken = await _authApi.googleLoginAndExtractToken(body);

    final tokens = AuthTokensModel(accessToken: accessToken);

    await _tokenStorage.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );

    final meResponse = await _accountApi.getMe();
    final account = meResponse.data;
    if (account == null) {
      throw const FormatException('Failed to load user profile after Google sign-in');
    }

    final user = UserModel(
      id: account.id,
      email: account.email,
      name: account.displayName,
    );

    return (tokens: tokens, user: user);
  }

  @override
  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {
      // Web clears local session even if logout API fails.
    }
  }

  @override
  Future<void> register(Map<String, dynamic> payload) async {
    await _authApi.register(payload);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _authApi.forgotPassword(email: email.trim().toLowerCase());
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    await _authApi.verifyOtp(email: email.trim().toLowerCase(), otp: otp.trim());
  }

  @override
  Future<void> resendOtp({required String email}) async {
    await _authApi.resendOtp(email: email.trim().toLowerCase());
  }
}
