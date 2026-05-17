import 'package:fuvekonmobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:fuvekonmobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:fuvekonmobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:fuvekonmobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:fuvekonmobile/features/profile/domain/usecases/update_me_usecase.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/edit_profile_bloc.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';

void registerProfileModule(GetIt sl) {
  sl
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(accountApi: sl()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton(() => GetMeUseCase(sl()))
    ..registerLazySingleton(() => UpdateMeUseCase(sl()))
    ..registerFactory(() => ProfileBloc(getMeUseCase: sl()))
    ..registerFactory(() => EditProfileBloc(updateMeUseCase: sl()));
}
