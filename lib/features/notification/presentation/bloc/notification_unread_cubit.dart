import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/notification/domain/repositories/notification_repository.dart';

/// Tracks unread notification count for nav badges.
class NotificationUnreadCubit extends Cubit<int> {
  NotificationUnreadCubit({required NotificationRepository repository})
    : _repository = repository,
      super(0);

  final NotificationRepository _repository;

  Future<void> refresh() async {
    try {
      final result = await _repository.unreadCount();
      if (result case Success(:final data)) {
        emit(data);
      }
    } on Object {
      // Best-effort badge; unverified/expired sessions may 403.
    }
  }
}
