// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_ticket_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyTicketEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyTicketEvent()';
}


}

/// @nodoc
class $MyTicketEventCopyWith<$Res>  {
$MyTicketEventCopyWith(MyTicketEvent _, $Res Function(MyTicketEvent) __);
}


/// Adds pattern-matching-related methods to [MyTicketEvent].
extension MyTicketEventPatterns on MyTicketEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MyTicketStarted value)?  started,TResult Function( MyTicketRefreshRequested value)?  refreshRequested,TResult Function( MyTicketBadgeNameChanged value)?  badgeNameChanged,TResult Function( MyTicketFursuiterChanged value)?  fursuiterChanged,TResult Function( MyTicketFursuitStaffChanged value)?  fursuitStaffChanged,TResult Function( MyTicketSaveNameCardRequested value)?  saveNameCardRequested,TResult Function( MyTicketPreviewRegenerateRequested value)?  previewRegenerateRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MyTicketStarted() when started != null:
return started(_that);case MyTicketRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case MyTicketBadgeNameChanged() when badgeNameChanged != null:
return badgeNameChanged(_that);case MyTicketFursuiterChanged() when fursuiterChanged != null:
return fursuiterChanged(_that);case MyTicketFursuitStaffChanged() when fursuitStaffChanged != null:
return fursuitStaffChanged(_that);case MyTicketSaveNameCardRequested() when saveNameCardRequested != null:
return saveNameCardRequested(_that);case MyTicketPreviewRegenerateRequested() when previewRegenerateRequested != null:
return previewRegenerateRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MyTicketStarted value)  started,required TResult Function( MyTicketRefreshRequested value)  refreshRequested,required TResult Function( MyTicketBadgeNameChanged value)  badgeNameChanged,required TResult Function( MyTicketFursuiterChanged value)  fursuiterChanged,required TResult Function( MyTicketFursuitStaffChanged value)  fursuitStaffChanged,required TResult Function( MyTicketSaveNameCardRequested value)  saveNameCardRequested,required TResult Function( MyTicketPreviewRegenerateRequested value)  previewRegenerateRequested,}){
final _that = this;
switch (_that) {
case MyTicketStarted():
return started(_that);case MyTicketRefreshRequested():
return refreshRequested(_that);case MyTicketBadgeNameChanged():
return badgeNameChanged(_that);case MyTicketFursuiterChanged():
return fursuiterChanged(_that);case MyTicketFursuitStaffChanged():
return fursuitStaffChanged(_that);case MyTicketSaveNameCardRequested():
return saveNameCardRequested(_that);case MyTicketPreviewRegenerateRequested():
return previewRegenerateRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MyTicketStarted value)?  started,TResult? Function( MyTicketRefreshRequested value)?  refreshRequested,TResult? Function( MyTicketBadgeNameChanged value)?  badgeNameChanged,TResult? Function( MyTicketFursuiterChanged value)?  fursuiterChanged,TResult? Function( MyTicketFursuitStaffChanged value)?  fursuitStaffChanged,TResult? Function( MyTicketSaveNameCardRequested value)?  saveNameCardRequested,TResult? Function( MyTicketPreviewRegenerateRequested value)?  previewRegenerateRequested,}){
final _that = this;
switch (_that) {
case MyTicketStarted() when started != null:
return started(_that);case MyTicketRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case MyTicketBadgeNameChanged() when badgeNameChanged != null:
return badgeNameChanged(_that);case MyTicketFursuiterChanged() when fursuiterChanged != null:
return fursuiterChanged(_that);case MyTicketFursuitStaffChanged() when fursuitStaffChanged != null:
return fursuitStaffChanged(_that);case MyTicketSaveNameCardRequested() when saveNameCardRequested != null:
return saveNameCardRequested(_that);case MyTicketPreviewRegenerateRequested() when previewRegenerateRequested != null:
return previewRegenerateRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  refreshRequested,TResult Function( String value)?  badgeNameChanged,TResult Function( bool value)?  fursuiterChanged,TResult Function( bool value)?  fursuitStaffChanged,TResult Function()?  saveNameCardRequested,TResult Function()?  previewRegenerateRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MyTicketStarted() when started != null:
return started();case MyTicketRefreshRequested() when refreshRequested != null:
return refreshRequested();case MyTicketBadgeNameChanged() when badgeNameChanged != null:
return badgeNameChanged(_that.value);case MyTicketFursuiterChanged() when fursuiterChanged != null:
return fursuiterChanged(_that.value);case MyTicketFursuitStaffChanged() when fursuitStaffChanged != null:
return fursuitStaffChanged(_that.value);case MyTicketSaveNameCardRequested() when saveNameCardRequested != null:
return saveNameCardRequested();case MyTicketPreviewRegenerateRequested() when previewRegenerateRequested != null:
return previewRegenerateRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  refreshRequested,required TResult Function( String value)  badgeNameChanged,required TResult Function( bool value)  fursuiterChanged,required TResult Function( bool value)  fursuitStaffChanged,required TResult Function()  saveNameCardRequested,required TResult Function()  previewRegenerateRequested,}) {final _that = this;
switch (_that) {
case MyTicketStarted():
return started();case MyTicketRefreshRequested():
return refreshRequested();case MyTicketBadgeNameChanged():
return badgeNameChanged(_that.value);case MyTicketFursuiterChanged():
return fursuiterChanged(_that.value);case MyTicketFursuitStaffChanged():
return fursuitStaffChanged(_that.value);case MyTicketSaveNameCardRequested():
return saveNameCardRequested();case MyTicketPreviewRegenerateRequested():
return previewRegenerateRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  refreshRequested,TResult? Function( String value)?  badgeNameChanged,TResult? Function( bool value)?  fursuiterChanged,TResult? Function( bool value)?  fursuitStaffChanged,TResult? Function()?  saveNameCardRequested,TResult? Function()?  previewRegenerateRequested,}) {final _that = this;
switch (_that) {
case MyTicketStarted() when started != null:
return started();case MyTicketRefreshRequested() when refreshRequested != null:
return refreshRequested();case MyTicketBadgeNameChanged() when badgeNameChanged != null:
return badgeNameChanged(_that.value);case MyTicketFursuiterChanged() when fursuiterChanged != null:
return fursuiterChanged(_that.value);case MyTicketFursuitStaffChanged() when fursuitStaffChanged != null:
return fursuitStaffChanged(_that.value);case MyTicketSaveNameCardRequested() when saveNameCardRequested != null:
return saveNameCardRequested();case MyTicketPreviewRegenerateRequested() when previewRegenerateRequested != null:
return previewRegenerateRequested();case _:
  return null;

}
}

}

/// @nodoc


class MyTicketStarted implements MyTicketEvent {
  const MyTicketStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyTicketEvent.started()';
}


}




/// @nodoc


class MyTicketRefreshRequested implements MyTicketEvent {
  const MyTicketRefreshRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketRefreshRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyTicketEvent.refreshRequested()';
}


}




/// @nodoc


class MyTicketBadgeNameChanged implements MyTicketEvent {
  const MyTicketBadgeNameChanged(this.value);
  

 final  String value;

/// Create a copy of MyTicketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyTicketBadgeNameChangedCopyWith<MyTicketBadgeNameChanged> get copyWith => _$MyTicketBadgeNameChangedCopyWithImpl<MyTicketBadgeNameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketBadgeNameChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'MyTicketEvent.badgeNameChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $MyTicketBadgeNameChangedCopyWith<$Res> implements $MyTicketEventCopyWith<$Res> {
  factory $MyTicketBadgeNameChangedCopyWith(MyTicketBadgeNameChanged value, $Res Function(MyTicketBadgeNameChanged) _then) = _$MyTicketBadgeNameChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$MyTicketBadgeNameChangedCopyWithImpl<$Res>
    implements $MyTicketBadgeNameChangedCopyWith<$Res> {
  _$MyTicketBadgeNameChangedCopyWithImpl(this._self, this._then);

  final MyTicketBadgeNameChanged _self;
  final $Res Function(MyTicketBadgeNameChanged) _then;

/// Create a copy of MyTicketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(MyTicketBadgeNameChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MyTicketFursuiterChanged implements MyTicketEvent {
  const MyTicketFursuiterChanged(this.value);
  

 final  bool value;

/// Create a copy of MyTicketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyTicketFursuiterChangedCopyWith<MyTicketFursuiterChanged> get copyWith => _$MyTicketFursuiterChangedCopyWithImpl<MyTicketFursuiterChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketFursuiterChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'MyTicketEvent.fursuiterChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $MyTicketFursuiterChangedCopyWith<$Res> implements $MyTicketEventCopyWith<$Res> {
  factory $MyTicketFursuiterChangedCopyWith(MyTicketFursuiterChanged value, $Res Function(MyTicketFursuiterChanged) _then) = _$MyTicketFursuiterChangedCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$MyTicketFursuiterChangedCopyWithImpl<$Res>
    implements $MyTicketFursuiterChangedCopyWith<$Res> {
  _$MyTicketFursuiterChangedCopyWithImpl(this._self, this._then);

  final MyTicketFursuiterChanged _self;
  final $Res Function(MyTicketFursuiterChanged) _then;

/// Create a copy of MyTicketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(MyTicketFursuiterChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class MyTicketFursuitStaffChanged implements MyTicketEvent {
  const MyTicketFursuitStaffChanged(this.value);
  

 final  bool value;

/// Create a copy of MyTicketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyTicketFursuitStaffChangedCopyWith<MyTicketFursuitStaffChanged> get copyWith => _$MyTicketFursuitStaffChangedCopyWithImpl<MyTicketFursuitStaffChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketFursuitStaffChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'MyTicketEvent.fursuitStaffChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $MyTicketFursuitStaffChangedCopyWith<$Res> implements $MyTicketEventCopyWith<$Res> {
  factory $MyTicketFursuitStaffChangedCopyWith(MyTicketFursuitStaffChanged value, $Res Function(MyTicketFursuitStaffChanged) _then) = _$MyTicketFursuitStaffChangedCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$MyTicketFursuitStaffChangedCopyWithImpl<$Res>
    implements $MyTicketFursuitStaffChangedCopyWith<$Res> {
  _$MyTicketFursuitStaffChangedCopyWithImpl(this._self, this._then);

  final MyTicketFursuitStaffChanged _self;
  final $Res Function(MyTicketFursuitStaffChanged) _then;

/// Create a copy of MyTicketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(MyTicketFursuitStaffChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class MyTicketSaveNameCardRequested implements MyTicketEvent {
  const MyTicketSaveNameCardRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketSaveNameCardRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyTicketEvent.saveNameCardRequested()';
}


}




/// @nodoc


class MyTicketPreviewRegenerateRequested implements MyTicketEvent {
  const MyTicketPreviewRegenerateRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketPreviewRegenerateRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyTicketEvent.previewRegenerateRequested()';
}


}




// dart format on
