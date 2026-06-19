import 'package:fuvekonmobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fuvekonmobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fuvekonmobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/google_register_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:fuvekonmobile/shared/services/google_sign_in_service.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

void registerAuthModule(GetIt sl) {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authApi: sl(),
        accountApi: sl(),
        tokenStorage: sl(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        tokenStorage: sl(),
        tokenRefreshService: sl(),
      ),
    )
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => GoogleLoginUseCase(sl()))
    ..registerLazySingleton(() => GoogleRegisterUseCase(sl()))
    ..registerLazySingleton(GoogleSignInService.new)
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => CheckAuthStatusUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => ForgotPasswordUseCase(sl()))
    ..registerLazySingleton(() => ResetPasswordUseCase(sl()))
    ..registerLazySingleton(() => VerifyOtpUseCase(sl()))
    ..registerLazySingleton(() => ResendOtpUseCase(sl()))
    ..registerFactory(
      () => AuthBloc(
        loginUseCase: sl(),
        googleLoginUseCase: sl(),
        googleRegisterUseCase: sl(),
        googleSignInService: sl(),
        logoutUseCase: sl(),
        checkAuthStatusUseCase: sl(),
      ),
    );
}
