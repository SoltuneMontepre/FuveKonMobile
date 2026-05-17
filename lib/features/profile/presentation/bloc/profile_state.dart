import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';

part 'profile_state.freezed.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = ProfileInitial;
  const factory ProfileState.loading() = ProfileLoading;
  const factory ProfileState.loaded(Account account) = ProfileLoaded;
  const factory ProfileState.failure(String message) = ProfileFailure;
}
