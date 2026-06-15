import 'package:fuvekonmobile/core/api/fuvekon_apis.dart';
import 'package:fuvekonmobile/core/network/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_conbook_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_dealer_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_panel_service.dart';
import 'package:fuvekonmobile/screens/admin/services/scan_ticket_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_user_service.dart';

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
    ..registerLazySingleton(() => sl<FuvekonApis>().analytics)
    ..registerLazySingleton(
      () => ScanTicketService(
        adminTicketApi: sl(),
        sessionStore: sl(),
      ),
    )
    ..registerLazySingleton(
      () => AdminDealerService(adminDealerApi: sl()),
    )
    ..registerLazySingleton(
      () => AdminPanelService(adminPanelApi: sl()),
    )
    ..registerLazySingleton(
      () => AdminConbookService(conbookApi: sl()),
    )
    ..registerLazySingleton(
      () => AdminUserService(adminUserApi: sl()),
    );
}
