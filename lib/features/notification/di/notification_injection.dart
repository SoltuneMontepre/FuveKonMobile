import 'package:fuvekonmobile/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:fuvekonmobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_detail_cubit.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_list_cubit.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_unread_cubit.dart';
import 'package:get_it/get_it.dart';

void registerNotificationModule(GetIt sl) {
  sl
    ..registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(api: sl()),
    )
    ..registerLazySingleton(
      () => NotificationUnreadCubit(repository: sl()),
    )
    ..registerFactory(() => NotificationListCubit(repository: sl()))
    ..registerFactory(() => NotificationDetailCubit(repository: sl()));
}
