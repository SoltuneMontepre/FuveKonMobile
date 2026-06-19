import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/ticket/data/datasources/ticket_remote_datasource.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/confirm_payment_result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/purchase_ticket_result.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/update_badge_details_input.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl({required TicketRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final TicketRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<TicketTier>>> getTiers() async {
    try {
      final tiers = await _remoteDataSource.getTiers();
      return Success(tiers);
    } on AppException catch (error) {
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      return Error(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<TicketTier>> getTierById(String tierId) async {
    try {
      final tier = await _remoteDataSource.getTierById(tierId);
      return Success(tier);
    } on AppException catch (error) {
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      return Error(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<UserTicket?>> getMyTicket() async {
    try {
      final ticket = await _remoteDataSource.getMyTicket();
      return Success(ticket);
    } on AppException catch (error) {
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      return Error(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<PurchaseTicketResult>> purchaseTicket(String tierId) async {
    try {
      final result = await _remoteDataSource.purchaseTicket(tierId);
      return Success(result);
    } on AppException catch (error) {
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      return Error(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<ConfirmPaymentResult>> confirmPayment() async {
    try {
      final result = await _remoteDataSource.confirmPayment();
      return Success(result);
    } on AppException catch (error) {
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      return Error(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<UserTicket>> updateBadgeDetails(
    UpdateBadgeDetailsInput input,
  ) async {
    try {
      final ticket = await _remoteDataSource.updateBadgeDetails(input);
      return Success(ticket);
    } on AppException catch (error) {
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      return Error(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<UserTicket>> upgradeTicket(String newTierId) async {
    try {
      final ticket = await _remoteDataSource.upgradeTicket(newTierId);
      return Success(ticket);
    } on AppException catch (error) {
      return Error(mapExceptionToFailure(error));
    } catch (error) {
      return Error(mapExceptionToFailure(error));
    }
  }
}
