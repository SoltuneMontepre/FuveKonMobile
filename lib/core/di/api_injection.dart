import 'package:fuvekonmobile/core/api/analytics_api.dart';
import 'package:fuvekonmobile/core/api/lost_found_api.dart';
import 'package:fuvekonmobile/core/api/fuvekon_apis.dart';
import 'package:fuvekonmobile/core/network/api_client.dart';
import 'package:fuvekonmobile/core/services/s3_upload_service.dart';
import 'package:get_it/get_it.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_conbook_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_dashboard_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_dealer_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_lost_found_service.dart';
import 'package:fuvekonmobile/screens/info/lost_found_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_notification_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_panel_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_schedule_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_event_settings_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_system_status_service.dart';
import 'package:fuvekonmobile/screens/admin/services/scan_ticket_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_ticket_service.dart';
import 'package:fuvekonmobile/screens/admin/services/admin_user_service.dart';
import 'package:fuvekonmobile/screens/account/services/account_dealer_service.dart';
import 'package:fuvekonmobile/screens/account/services/account_submissions_service.dart';

void registerApiModule(GetIt sl) {
  sl
    ..registerLazySingleton(() => S3UploadService(apiClient: sl()))
    ..registerLazySingleton(() => FuvekonApis(sl<ApiClient>()))
    ..registerLazySingleton(() => sl<FuvekonApis>().auth)
    ..registerLazySingleton(() => sl<FuvekonApis>().account)
    ..registerLazySingleton(() => sl<FuvekonApis>().ticket)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminTicket)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminUser)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminNotification)
    ..registerLazySingleton(() => sl<FuvekonApis>().dealer)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminDealer)
    ..registerLazySingleton(() => sl<FuvekonApis>().talent)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminTalent)
    ..registerLazySingleton(() => sl<FuvekonApis>().panel)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminPanel)
    ..registerLazySingleton(() => sl<FuvekonApis>().conbook)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminLostFound)
    ..registerLazySingleton(() => sl<FuvekonApis>().lostFound)
    ..registerLazySingleton(() => sl<FuvekonApis>().notification)
    ..registerLazySingleton(() => sl<FuvekonApis>().device)
    ..registerLazySingleton(() => sl<FuvekonApis>().schedule)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminSchedule)
    ..registerLazySingleton(() => sl<FuvekonApis>().adminVenue)
    ..registerLazySingleton(() => sl<FuvekonApis>().analytics)
    ..registerLazySingleton(() => sl<FuvekonApis>().health)
    ..registerLazySingleton(() => sl<FuvekonApis>().event)
    ..registerLazySingleton(
      () => ScanTicketService(adminTicketApi: sl(), sessionStore: sl()),
    )
    ..registerLazySingleton(() => AdminDealerService(adminDealerApi: sl()))
    ..registerLazySingleton(() => AdminPanelService(adminPanelApi: sl()))
    ..registerLazySingleton(() => AdminConbookService(conbookApi: sl()))
    ..registerLazySingleton(() => AdminTicketService(adminTicketApi: sl()))
    ..registerLazySingleton(() => AdminUserService(adminUserApi: sl()))
    ..registerLazySingleton(() => AdminNotificationService(api: sl()))
    ..registerLazySingleton(
      () => AdminLostFoundService(api: sl<AdminLostFoundApi>()),
    )
    ..registerLazySingleton(() => LostFoundService(api: sl<LostFoundApi>()))
    ..registerLazySingleton(
      () => AdminDashboardService(analyticsApi: sl<AnalyticsApi>()),
    )
    ..registerLazySingleton(
      () => AdminScheduleService(scheduleApi: sl(), adminScheduleApi: sl()),
    )
    ..registerLazySingleton(() => AdminSystemStatusService(healthApi: sl()))
    ..registerLazySingleton(() => AdminEventSettingsService(eventApi: sl()))
    ..registerLazySingleton(
      () => AccountSubmissionsService(
        panelApi: sl(),
        talentApi: sl(),
        conbookApi: sl(),
      ),
    )
    ..registerLazySingleton(() => AccountDealerService(dealerApi: sl()));
}
