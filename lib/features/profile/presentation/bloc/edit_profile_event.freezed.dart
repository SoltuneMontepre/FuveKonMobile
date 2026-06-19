// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileEvent {

 UpdateProfileInput get input;
/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileEventCopyWith<EditProfileEvent> get copyWith => _$EditProfileEventCopyWithImpl<EditProfileEvent>(this as EditProfileEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileEvent&&(identical(other.input, input) || other.input == input));
}


@override
int get hashCode => Object.hash(runtimeType,input);

@override
String toString() {
  return 'EditProfileEvent(input: $input)';
}


}

/// @nodoc
abstract mixin class $EditProfileEventCopyWith<$Res>  {
  factory $EditProfileEventCopyWith(EditProfileEvent value, $Res Function(EditProfileEvent) _then) = _$EditProfileEventCopyWithImpl;
@useResult
$Res call({
 UpdateProfileInput input
});




}
/// @nodoc
class _$EditProfileEventCopyWithImpl<$Res>
    implements $EditProfileEventCopyWith<$Res> {
  _$EditProfileEventCopyWithImpl(this._self, this._then);

  final EditProfileEvent _self;
  final $Res Function(EditProfileEvent) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? input = null,}) {
  return _then(EditProfileEvent.submitted(
null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as UpdateProfileInput,
  ));
}

}


/// Adds pattern-matching-related methods to [EditProfileEvent].
extension EditProfileEventPatterns on EditProfileEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditProfileSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditProfileSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditProfileSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case EditProfileSubmitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditProfileSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case EditProfileSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( UpdateProfileInput input)?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EditProfileSubmitted() when submitted != null:
return submitted(_that.input);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( UpdateProfileInput input)  submitted,}) {final _that = this;
switch (_that) {
case EditProfileSubmitted():
return submitted(_that.input);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( UpdateProfileInput input)?  submitted,}) {final _that = this;
switch (_that) {
case EditProfileSubmitted() when submitted != null:
return submitted(_that.input);case _:
  return null;

}
}

}

/// @nodoc


class EditProfileSubmitted implements EditProfileEvent {
  const EditProfileSubmitted(this.input);
  

@override final  UpdateProfileInput input;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileSubmittedCopyWith<EditProfileSubmitted> get copyWith => _$EditProfileSubmittedCopyWithImpl<EditProfileSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileSubmitted&&(identical(other.input, input) || other.input == input));
}


@override
int get hashCode => Object.hash(runtimeType,input);

@override
String toString() {
  return 'EditProfileEvent.submitted(input: $input)';
}


}

/// @nodoc
abstract mixin class $EditProfileSubmittedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory $EditProfileSubmittedCopyWith(EditProfileSubmitted value, $Res Function(EditProfileSubmitted) _then) = _$EditProfileSubmittedCopyWithImpl;
@override @useResult
$Res call({
 UpdateProfileInput input
});




}
/// @nodoc
class _$EditProfileSubmittedCopyWithImpl<$Res>
    implements $EditProfileSubmittedCopyWith<$Res> {
  _$EditProfileSubmittedCopyWithImpl(this._self, this._then);

  final EditProfileSubmitted _self;
  final $Res Function(EditProfileSubmitted) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? input = null,}) {
  return _then(EditProfileSubmitted(
null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as UpdateProfileInput,
  ));
}


}

// dart format on
