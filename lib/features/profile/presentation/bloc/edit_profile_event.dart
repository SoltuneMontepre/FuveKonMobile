import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/update_profile_input.dart';

part 'edit_profile_event.freezed.dart';

@freezed
sealed class EditProfileEvent with _$EditProfileEvent {
  const factory EditProfileEvent.submitted(UpdateProfileInput input) =
      EditProfileSubmitted;
}
