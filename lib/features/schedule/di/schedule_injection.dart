import 'package:fuvekonmobile/features/schedule/data/repositories/mock_schedule_repository.dart';
import 'package:fuvekonmobile/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:fuvekonmobile/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/activity_detail_cubit.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/itinerary_cubit.dart';
import 'package:fuvekonmobile/features/schedule/presentation/bloc/schedule_list_cubit.dart';
import 'package:get_it/get_it.dart';

void registerScheduleModule(GetIt sl, {bool useMock = false}) {
  if (useMock) {
    sl.registerLazySingleton<ScheduleRepository>(MockScheduleRepository.new);
  } else {
    sl.registerLazySingleton<ScheduleRepository>(
      () => ScheduleRepositoryImpl(
        scheduleApi: sl(),
        venueDelegate: MockScheduleRepository(),
      ),
    );
  }

  sl
    ..registerFactory(() => ScheduleListCubit(repository: sl()))
    ..registerFactory(() => ActivityDetailCubit(repository: sl()))
    ..registerFactory(() => ItineraryCubit(repository: sl()));
}
