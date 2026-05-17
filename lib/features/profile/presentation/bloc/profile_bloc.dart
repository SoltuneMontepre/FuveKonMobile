import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_event.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required GetMeUseCase getMeUseCase})
      : _getMeUseCase = getMeUseCase,
        super(const ProfileState.initial()) {
    on<ProfileStarted>(_onLoad);
    on<ProfileRefreshRequested>(_onLoad);
  }

  final GetMeUseCase _getMeUseCase;

  Future<void> _onLoad(ProfileEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    final result = await _getMeUseCase();

    switch (result) {
      case Success(:final data):
        emit(ProfileState.loaded(data));
      case Error(:final failure):
        emit(ProfileState.failure(failure.message));
    }
  }
}
