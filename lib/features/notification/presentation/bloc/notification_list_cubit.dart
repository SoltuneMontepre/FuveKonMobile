import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_list_state.dart';

class NotificationListCubit extends Cubit<NotificationListState> {
  NotificationListCubit({required NotificationRepository repository})
      : _repository = repository,
        super(const NotificationListInitial());

  final NotificationRepository _repository;

  Future<void> load() async {
    emit(const NotificationListLoading());
    final result = await _repository.list();

    switch (result) {
      case Success(:final data):
        if (data.isEmpty) {
          emit(const NotificationListEmpty());
        } else {
          emit(NotificationListLoaded(data));
        }
      case Error(:final failure):
        emit(NotificationListFailure(failure.message));
    }
  }

  Future<void> refresh() => load();
}
