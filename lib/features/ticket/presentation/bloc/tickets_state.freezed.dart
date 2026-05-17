// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tickets_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketsState()';
}


}

/// @nodoc
class $TicketsStateCopyWith<$Res>  {
$TicketsStateCopyWith(TicketsState _, $Res Function(TicketsState) __);
}


/// Adds pattern-matching-related methods to [TicketsState].
extension TicketsStatePatterns on TicketsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TicketsInitial value)?  initial,TResult Function( TicketsLoading value)?  loading,TResult Function( TicketsLoaded value)?  loaded,TResult Function( TicketsFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TicketsInitial() when initial != null:
return initial(_that);case TicketsLoading() when loading != null:
return loading(_that);case TicketsLoaded() when loaded != null:
return loaded(_that);case TicketsFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TicketsInitial value)  initial,required TResult Function( TicketsLoading value)  loading,required TResult Function( TicketsLoaded value)  loaded,required TResult Function( TicketsFailure value)  failure,}){
final _that = this;
switch (_that) {
case TicketsInitial():
return initial(_that);case TicketsLoading():
return loading(_that);case TicketsLoaded():
return loaded(_that);case TicketsFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TicketsInitial value)?  initial,TResult? Function( TicketsLoading value)?  loading,TResult? Function( TicketsLoaded value)?  loaded,TResult? Function( TicketsFailure value)?  failure,}){
final _that = this;
switch (_that) {
case TicketsInitial() when initial != null:
return initial(_that);case TicketsLoading() when loading != null:
return loading(_that);case TicketsLoaded() when loaded != null:
return loaded(_that);case TicketsFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<TicketTier> tiers,  UserTicket? myTicket,  Account? account,  bool isPurchasing)?  loaded,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TicketsInitial() when initial != null:
return initial();case TicketsLoading() when loading != null:
return loading();case TicketsLoaded() when loaded != null:
return loaded(_that.tiers,_that.myTicket,_that.account,_that.isPurchasing);case TicketsFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<TicketTier> tiers,  UserTicket? myTicket,  Account? account,  bool isPurchasing)  loaded,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case TicketsInitial():
return initial();case TicketsLoading():
return loading();case TicketsLoaded():
return loaded(_that.tiers,_that.myTicket,_that.account,_that.isPurchasing);case TicketsFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<TicketTier> tiers,  UserTicket? myTicket,  Account? account,  bool isPurchasing)?  loaded,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case TicketsInitial() when initial != null:
return initial();case TicketsLoading() when loading != null:
return loading();case TicketsLoaded() when loaded != null:
return loaded(_that.tiers,_that.myTicket,_that.account,_that.isPurchasing);case TicketsFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TicketsInitial implements TicketsState {
  const TicketsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketsState.initial()';
}


}




/// @nodoc


class TicketsLoading implements TicketsState {
  const TicketsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketsState.loading()';
}


}




/// @nodoc


class TicketsLoaded implements TicketsState {
  const TicketsLoaded({required final  List<TicketTier> tiers, this.myTicket, this.account, this.isPurchasing = false}): _tiers = tiers;
  

 final  List<TicketTier> _tiers;
 List<TicketTier> get tiers {
  if (_tiers is EqualUnmodifiableListView) return _tiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiers);
}

 final  UserTicket? myTicket;
 final  Account? account;
@JsonKey() final  bool isPurchasing;

/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsLoadedCopyWith<TicketsLoaded> get copyWith => _$TicketsLoadedCopyWithImpl<TicketsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsLoaded&&const DeepCollectionEquality().equals(other._tiers, _tiers)&&(identical(other.myTicket, myTicket) || other.myTicket == myTicket)&&(identical(other.account, account) || other.account == account)&&(identical(other.isPurchasing, isPurchasing) || other.isPurchasing == isPurchasing));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tiers),myTicket,account,isPurchasing);

@override
String toString() {
  return 'TicketsState.loaded(tiers: $tiers, myTicket: $myTicket, account: $account, isPurchasing: $isPurchasing)';
}


}

/// @nodoc
abstract mixin class $TicketsLoadedCopyWith<$Res> implements $TicketsStateCopyWith<$Res> {
  factory $TicketsLoadedCopyWith(TicketsLoaded value, $Res Function(TicketsLoaded) _then) = _$TicketsLoadedCopyWithImpl;
@useResult
$Res call({
 List<TicketTier> tiers, UserTicket? myTicket, Account? account, bool isPurchasing
});




}
/// @nodoc
class _$TicketsLoadedCopyWithImpl<$Res>
    implements $TicketsLoadedCopyWith<$Res> {
  _$TicketsLoadedCopyWithImpl(this._self, this._then);

  final TicketsLoaded _self;
  final $Res Function(TicketsLoaded) _then;

/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tiers = null,Object? myTicket = freezed,Object? account = freezed,Object? isPurchasing = null,}) {
  return _then(TicketsLoaded(
tiers: null == tiers ? _self._tiers : tiers // ignore: cast_nullable_to_non_nullable
as List<TicketTier>,myTicket: freezed == myTicket ? _self.myTicket : myTicket // ignore: cast_nullable_to_non_nullable
as UserTicket?,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account?,isPurchasing: null == isPurchasing ? _self.isPurchasing : isPurchasing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class TicketsFailure implements TicketsState {
  const TicketsFailure(this.message);
  

 final  String message;

/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsFailureCopyWith<TicketsFailure> get copyWith => _$TicketsFailureCopyWithImpl<TicketsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TicketsState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $TicketsFailureCopyWith<$Res> implements $TicketsStateCopyWith<$Res> {
  factory $TicketsFailureCopyWith(TicketsFailure value, $Res Function(TicketsFailure) _then) = _$TicketsFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TicketsFailureCopyWithImpl<$Res>
    implements $TicketsFailureCopyWith<$Res> {
  _$TicketsFailureCopyWithImpl(this._self, this._then);

  final TicketsFailure _self;
  final $Res Function(TicketsFailure) _then;

/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TicketsFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
