import 'package:fuvekonmobile/features/ticket/data/datasources/ticket_remote_datasource.dart';
import 'package:fuvekonmobile/features/ticket/data/repositories/ticket_repository_impl.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/confirm_ticket_payment_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_my_ticket_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_ticket_tier_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/get_ticket_tiers_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/purchase_ticket_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/save_name_card_usecase.dart';
import 'package:fuvekonmobile/features/ticket/domain/usecases/upgrade_ticket_usecase.dart';
import 'package:fuvekonmobile/core/utils/ticket/render_namecard.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/my_ticket_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_purchase_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_tier_detail_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/ticket_tiers_bloc.dart';
import 'package:fuvekonmobile/features/ticket/presentation/bloc/tickets_bloc.dart';
import 'package:get_it/get_it.dart';

void registerTicketModule(GetIt sl) {
  sl
    ..registerLazySingleton(NamecardRenderer.new)
    ..registerLazySingleton<TicketRemoteDataSource>(
      () => TicketRemoteDataSourceImpl(ticketApi: sl()),
    )
    ..registerLazySingleton<TicketRepository>(
      () => TicketRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton(() => GetTicketTierUseCase(sl()))
    ..registerLazySingleton(() => GetTicketTiersUseCase(sl()))
    ..registerLazySingleton(() => GetMyTicketUseCase(sl()))
    ..registerLazySingleton(() => PurchaseTicketUseCase(sl()))
    ..registerLazySingleton(() => ConfirmTicketPaymentUseCase(sl()))
    ..registerLazySingleton(
      () => SaveNameCardUseCase(
        ticketRepository: sl(),
        s3UploadService: sl(),
        namecardRenderer: sl(),
      ),
    )
    ..registerLazySingleton(() => UpgradeTicketUseCase(sl()))
    ..registerFactory(
      () => MyTicketBloc(
        getMyTicketUseCase: sl(),
        getMeUseCase: sl(),
        saveNameCardUseCase: sl(),
        namecardRenderer: sl(),
      ),
    )
    ..registerFactory(
      () => TicketTiersBloc(getTicketTiersUseCase: sl()),
    )
    ..registerFactory(
      () => TicketTierDetailBloc(
        getTicketTierUseCase: sl(),
        getTicketTiersUseCase: sl(),
      ),
    )
    ..registerFactory(() => TicketsBloc(
          getTicketTiersUseCase: sl(),
          getMyTicketUseCase: sl(),
          getMeUseCase: sl(),
          purchaseTicketUseCase: sl(),
        ))
    ..registerFactory(() => TicketPurchaseBloc(
          confirmTicketPaymentUseCase: sl(),
          getMyTicketUseCase: sl(),
          getMeUseCase: sl(),
          updateMeUseCase: sl(),
        ));
}
