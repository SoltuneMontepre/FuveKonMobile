import 'package:fuvekonmobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fuvekonmobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fuvekonmobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/logout_usecase.dart';
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
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => CheckAuthStatusUseCase(sl()))
    ..registerFactory(
      () => AuthBloc(
        loginUseCase: sl(),
        logoutUseCase: sl(),
        checkAuthStatusUseCase: sl(),
      ),
    );
}
