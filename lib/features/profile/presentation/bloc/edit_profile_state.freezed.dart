// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProfileState()';
}


}

/// @nodoc
class $EditProfileStateCopyWith<$Res>  {
$EditProfileStateCopyWith(EditProfileState _, $Res Function(EditProfileState) __);
}


/// Adds pattern-matching-related methods to [EditProfileState].
extension EditProfileStatePatterns on EditProfileState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditProfileIdle value)?  idle,TResult Function( EditProfileSaving value)?  saving,TResult Function( EditProfileSaved value)?  saved,TResult Function( EditProfileFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditProfileIdle() when idle != null:
return idle(_that);case EditProfileSaving() when saving != null:
return saving(_that);case EditProfileSaved() when saved != null:
return saved(_that);case EditProfileFailure() when failure != null:
return failure(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditProfileIdle value)  idle,required TResult Function( EditProfileSaving value)  saving,required TResult Function( EditProfileSaved value)  saved,required TResult Function( EditProfileFailure value)  failure,}){
final _that = this;
switch (_that) {
case EditProfileIdle():
return idle(_that);case EditProfileSaving():
return saving(_that);case EditProfileSaved():
return saved(_that);case EditProfileFailure():
return failure(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditProfileIdle value)?  idle,TResult? Function( EditProfileSaving value)?  saving,TResult? Function( EditProfileSaved value)?  saved,TResult? Function( EditProfileFailure value)?  failure,}){
final _that = this;
switch (_that) {
case EditProfileIdle() when idle != null:
return idle(_that);case EditProfileSaving() when saving != null:
return saving(_that);case EditProfileSaved() when saved != null:
return saved(_that);case EditProfileFailure() when failure != null:
return failure(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  saving,TResult Function( Account account)?  saved,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EditProfileIdle() when idle != null:
return idle();case EditProfileSaving() when saving != null:
return saving();case EditProfileSaved() when saved != null:
return saved(_that.account);case EditProfileFailure() when failure != null:
return failure(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  saving,required TResult Function( Account account)  saved,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case EditProfileIdle():
return idle();case EditProfileSaving():
return saving();case EditProfileSaved():
return saved(_that.account);case EditProfileFailure():
return failure(_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  saving,TResult? Function( Account account)?  saved,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case EditProfileIdle() when idle != null:
return idle();case EditProfileSaving() when saving != null:
return saving();case EditProfileSaved() when saved != null:
return saved(_that.account);case EditProfileFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class EditProfileIdle implements EditProfileState {
  const EditProfileIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProfileState.idle()';
}


}




/// @nodoc


class EditProfileSaving implements EditProfileState {
  const EditProfileSaving();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileSaving);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProfileState.saving()';
}


}




/// @nodoc


class EditProfileSaved implements EditProfileState {
  const EditProfileSaved(this.account);
  

 final  Account account;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileSavedCopyWith<EditProfileSaved> get copyWith => _$EditProfileSavedCopyWithImpl<EditProfileSaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileSaved&&(identical(other.account, account) || other.account == account));
}


@override
int get hashCode => Object.hash(runtimeType,account);

@override
String toString() {
  return 'EditProfileState.saved(account: $account)';
}


}

/// @nodoc
abstract mixin class $EditProfileSavedCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory $EditProfileSavedCopyWith(EditProfileSaved value, $Res Function(EditProfileSaved) _then) = _$EditProfileSavedCopyWithImpl;
@useResult
$Res call({
 Account account
});




}
/// @nodoc
class _$EditProfileSavedCopyWithImpl<$Res>
    implements $EditProfileSavedCopyWith<$Res> {
  _$EditProfileSavedCopyWithImpl(this._self, this._then);

  final EditProfileSaved _self;
  final $Res Function(EditProfileSaved) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? account = null,}) {
  return _then(EditProfileSaved(
null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account,
  ));
}


}

/// @nodoc


class EditProfileFailure implements EditProfileState {
  const EditProfileFailure(this.message);
  

 final  String message;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileFailureCopyWith<EditProfileFailure> get copyWith => _$EditProfileFailureCopyWithImpl<EditProfileFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'EditProfileState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $EditProfileFailureCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory $EditProfileFailureCopyWith(EditProfileFailure value, $Res Function(EditProfileFailure) _then) = _$EditProfileFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$EditProfileFailureCopyWithImpl<$Res>
    implements $EditProfileFailureCopyWith<$Res> {
  _$EditProfileFailureCopyWithImpl(this._self, this._then);

  final EditProfileFailure _self;
  final $Res Function(EditProfileFailure) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(EditProfileFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
