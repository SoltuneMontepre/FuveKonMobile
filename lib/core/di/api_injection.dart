import 'package:fuvekonmobile/core/api/fuvekon_apis.dart';
import 'package:fuvekonmobile/core/network/api_client.dart';
import 'package:get_it/get_it.dart';

void registerApiModule(GetIt sl) {
  sl
    ..registerLazySingleton(() => FuvekonApis(sl<ApiClient>()))
    ..registerLazySingleton(() => sl<FuvekonApis>().auth)
    ..registerLazySingleton(() => sl<FuvekonApis>().account)
    ..registerLazySingleton(() => sl<FuvekonApis>().ticket)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminTicket)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminUser)
    ..registerLazySingleton(() => sl<FuvekonApis>().dealer)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminDealer)
    ..registerLazySingleton(() => sl<FuvekonApis>().talent)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminTalent)
    ..registerLazySingleton(() => sl<FuvekonApis>().panel)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminPanel)
    ..registerLazySingleton(() => sl<FuvekonApis>().conbook)
    ..registerLazySingleton(() => sl<FuvekonApis>().analytics);
}
