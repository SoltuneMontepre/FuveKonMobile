import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/google_register_input.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/register_input.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Result<User>> login({required String email, required String password});

  Future<Result<User>> loginWithGoogle({required String credential});

  Future<Result<User>> registerWithGoogle(GoogleRegisterInput input);

  Future<Result<void>> logout();

  Future<bool> isLoggedIn();

  Future<String?> refreshAccessToken();

  Future<Result<void>> register(RegisterInput input);

  Future<Result<void>> forgotPassword({required String email});

  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  });

  Future<Result<void>> verifyOtp({required String email, required String otp});

  Future<Result<void>> resendOtp({required String email});
}
