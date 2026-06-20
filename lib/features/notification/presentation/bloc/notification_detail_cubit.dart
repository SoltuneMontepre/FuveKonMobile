import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_detail_state.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_unread_cubit.dart';

class NotificationDetailCubit extends Cubit<NotificationDetailState> {
  NotificationDetailCubit({required NotificationRepository repository})
    : _repository = repository,
      super(const NotificationDetailInitial());

  final NotificationRepository _repository;

  Future<void> load(String id) async {
    emit(const NotificationDetailLoading());
    final result = await _repository.getById(id);

    switch (result) {
      case Success(:final data):
        if (!data.isRead) {
          final readResult = await _repository.markAsRead(id);
          await _refreshUnreadBadge();
          switch (readResult) {
            case Success(:final data):
              emit(NotificationDetailLoaded(data));
            case Error():
              emit(NotificationDetailLoaded(data));
          }
        } else {
          emit(NotificationDetailLoaded(data));
        }
      case Error(:final failure):
        emit(NotificationDetailFailure(failure.message));
    }
  }

  Future<void> _refreshUnreadBadge() async {
    try {
      await sl<NotificationUnreadCubit>().refresh();
    } catch (_) {}
  }
}
