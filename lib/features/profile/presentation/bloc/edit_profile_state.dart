import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';

part 'edit_profile_state.freezed.dart';

@freezed
sealed class EditProfileState with _$EditProfileState {
  const factory EditProfileState.idle() = EditProfileIdle;
  const factory EditProfileState.saving() = EditProfileSaving;
  const factory EditProfileState.saved(Account account) = EditProfileSaved;
  const factory EditProfileState.failure(String message) = EditProfileFailure;
}
