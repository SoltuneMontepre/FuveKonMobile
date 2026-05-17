// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tickets_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketsEvent()';
}


}

/// @nodoc
class $TicketsEventCopyWith<$Res>  {
$TicketsEventCopyWith(TicketsEvent _, $Res Function(TicketsEvent) __);
}


/// Adds pattern-matching-related methods to [TicketsEvent].
extension TicketsEventPatterns on TicketsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TicketsStarted value)?  started,TResult Function( TicketsRefreshRequested value)?  refreshRequested,TResult Function( TicketsPurchaseRequested value)?  purchaseRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TicketsStarted() when started != null:
return started(_that);case TicketsRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case TicketsPurchaseRequested() when purchaseRequested != null:
return purchaseRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TicketsStarted value)  started,required TResult Function( TicketsRefreshRequested value)  refreshRequested,required TResult Function( TicketsPurchaseRequested value)  purchaseRequested,}){
final _that = this;
switch (_that) {
case TicketsStarted():
return started(_that);case TicketsRefreshRequested():
return refreshRequested(_that);case TicketsPurchaseRequested():
return purchaseRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TicketsStarted value)?  started,TResult? Function( TicketsRefreshRequested value)?  refreshRequested,TResult? Function( TicketsPurchaseRequested value)?  purchaseRequested,}){
final _that = this;
switch (_that) {
case TicketsStarted() when started != null:
return started(_that);case TicketsRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case TicketsPurchaseRequested() when purchaseRequested != null:
return purchaseRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  refreshRequested,TResult Function( String tierId)?  purchaseRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TicketsStarted() when started != null:
return started();case TicketsRefreshRequested() when refreshRequested != null:
return refreshRequested();case TicketsPurchaseRequested() when purchaseRequested != null:
return purchaseRequested(_that.tierId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  refreshRequested,required TResult Function( String tierId)  purchaseRequested,}) {final _that = this;
switch (_that) {
case TicketsStarted():
return started();case TicketsRefreshRequested():
return refreshRequested();case TicketsPurchaseRequested():
return purchaseRequested(_that.tierId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  refreshRequested,TResult? Function( String tierId)?  purchaseRequested,}) {final _that = this;
switch (_that) {
case TicketsStarted() when started != null:
return started();case TicketsRefreshRequested() when refreshRequested != null:
return refreshRequested();case TicketsPurchaseRequested() when purchaseRequested != null:
return purchaseRequested(_that.tierId);case _:
  return null;

}
}

}

/// @nodoc


class TicketsStarted implements TicketsEvent {
  const TicketsStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketsEvent.started()';
}


}




/// @nodoc


class TicketsRefreshRequested implements TicketsEvent {
  const TicketsRefreshRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsRefreshRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketsEvent.refreshRequested()';
}


}




/// @nodoc


class TicketsPurchaseRequested implements TicketsEvent {
  const TicketsPurchaseRequested(this.tierId);
  

 final  String tierId;

/// Create a copy of TicketsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsPurchaseRequestedCopyWith<TicketsPurchaseRequested> get copyWith => _$TicketsPurchaseRequestedCopyWithImpl<TicketsPurchaseRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsPurchaseRequested&&(identical(other.tierId, tierId) || other.tierId == tierId));
}


@override
int get hashCode => Object.hash(runtimeType,tierId);

@override
String toString() {
  return 'TicketsEvent.purchaseRequested(tierId: $tierId)';
}


}

/// @nodoc
abstract mixin class $TicketsPurchaseRequestedCopyWith<$Res> implements $TicketsEventCopyWith<$Res> {
  factory $TicketsPurchaseRequestedCopyWith(TicketsPurchaseRequested value, $Res Function(TicketsPurchaseRequested) _then) = _$TicketsPurchaseRequestedCopyWithImpl;
@useResult
$Res call({
 String tierId
});




}
/// @nodoc
class _$TicketsPurchaseRequestedCopyWithImpl<$Res>
    implements $TicketsPurchaseRequestedCopyWith<$Res> {
  _$TicketsPurchaseRequestedCopyWithImpl(this._self, this._then);

  final TicketsPurchaseRequested _self;
  final $Res Function(TicketsPurchaseRequested) _then;

/// Create a copy of TicketsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tierId = null,}) {
  return _then(TicketsPurchaseRequested(
null == tierId ? _self.tierId : tierId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
