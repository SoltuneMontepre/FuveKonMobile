import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_list_state.dart';
import 'package:fuvekonmobile/features/notification/presentation/bloc/notification_unread_cubit.dart';

class NotificationListCubit extends Cubit<NotificationListState> {
  NotificationListCubit({required NotificationRepository repository})
      : _repository = repository,
        super(const NotificationListInitial());

  static const _pageSize = 20;

  final NotificationRepository _repository;
  bool _unreadOnly = false;
  int _currentPage = 1;

  Future<void> load({bool refreshUnreadBadge = true}) async {
    emit(const NotificationListLoading());
    _currentPage = 1;

    final result = await _repository.list(
      page: _currentPage,
      pageSize: _pageSize,
      unreadOnly: _unreadOnly,
    );

    if (refreshUnreadBadge) {
      await _refreshUnreadBadge();
    }

    switch (result) {
      case Success(:final data):
        _currentPage = data.meta.currentPage;
        if (data.items.isEmpty) {
          emit(NotificationListEmpty(unreadOnly: _unreadOnly));
        } else {
          emit(
            NotificationListLoaded(
              items: data.items,
              hasMore: data.meta.hasMore,
              unreadOnly: _unreadOnly,
            ),
          );
        }
      case Error(:final failure):
        emit(NotificationListFailure(failure.message));
    }
  }

  Future<void> refresh() => load();

  Future<void> loadMore() async {
    final current = state;
    if (current is! NotificationListLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    emit(
      NotificationListLoaded(
        items: current.items,
        hasMore: current.hasMore,
        isLoadingMore: true,
        unreadOnly: current.unreadOnly,
      ),
    );

    final result = await _repository.list(
      page: _currentPage + 1,
      pageSize: _pageSize,
      unreadOnly: _unreadOnly,
    );

    switch (result) {
      case Success(:final data):
        _currentPage = data.meta.currentPage;
        if (data.items.isEmpty) {
          emit(
            NotificationListLoaded(
              items: current.items,
              hasMore: false,
              unreadOnly: current.unreadOnly,
            ),
          );
          return;
        }
        emit(
          NotificationListLoaded(
            items: [...current.items, ...data.items],
            hasMore: data.meta.hasMore,
            unreadOnly: _unreadOnly,
          ),
        );
      case Error(:final failure):
        emit(
          NotificationListLoaded(
            items: current.items,
            hasMore: current.hasMore,
            unreadOnly: current.unreadOnly,
          ),
        );
        emit(NotificationListFailure(failure.message));
    }
  }

  Future<void> setUnreadOnly(bool value) async {
    if (_unreadOnly == value) return;
    _unreadOnly = value;
    await load(refreshUnreadBadge: false);
  }

  Future<bool> markAllRead() async {
    final result = await _repository.markAllRead();
    switch (result) {
      case Success():
        await load();
        return true;
      case Error():
        return false;
    }
  }

  Future<void> _refreshUnreadBadge() async {
    try {
      await sl<NotificationUnreadCubit>().refresh();
    } catch (_) {
      // Badge refresh is best-effort.
    }
  }
}
