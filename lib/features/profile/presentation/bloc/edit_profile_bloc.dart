import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/features/profile/domain/usecases/update_me_usecase.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/edit_profile_event.dart';
import 'package:fuvekonmobile/features/profile/presentation/bloc/edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({required UpdateMeUseCase updateMeUseCase})
    : _updateMeUseCase = updateMeUseCase,
      super(const EditProfileState.idle()) {
    on<EditProfileSubmitted>(_onSubmitted);
  }

  final UpdateMeUseCase _updateMeUseCase;

  Future<void> _onSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(const EditProfileState.saving());
    final result = await _updateMeUseCase(event.input);

    switch (result) {
      case Success(:final data):
        emit(EditProfileState.saved(data));
      case Error(:final failure):
        emit(EditProfileState.failure(failure.message));
    }
  }
}
