// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_purchase_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketPurchaseEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketPurchaseEvent()';
}


}

/// @nodoc
class $TicketPurchaseEventCopyWith<$Res>  {
$TicketPurchaseEventCopyWith(TicketPurchaseEvent _, $Res Function(TicketPurchaseEvent) __);
}


/// Adds pattern-matching-related methods to [TicketPurchaseEvent].
extension TicketPurchaseEventPatterns on TicketPurchaseEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TicketPurchaseStarted value)?  started,TResult Function( TicketPurchaseRefreshRequested value)?  refreshRequested,TResult Function( TicketPurchaseIdCardSaved value)?  idCardSaved,TResult Function( TicketPurchaseConfirmPaymentRequested value)?  confirmPaymentRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TicketPurchaseStarted() when started != null:
return started(_that);case TicketPurchaseRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case TicketPurchaseIdCardSaved() when idCardSaved != null:
return idCardSaved(_that);case TicketPurchaseConfirmPaymentRequested() when confirmPaymentRequested != null:
return confirmPaymentRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TicketPurchaseStarted value)  started,required TResult Function( TicketPurchaseRefreshRequested value)  refreshRequested,required TResult Function( TicketPurchaseIdCardSaved value)  idCardSaved,required TResult Function( TicketPurchaseConfirmPaymentRequested value)  confirmPaymentRequested,}){
final _that = this;
switch (_that) {
case TicketPurchaseStarted():
return started(_that);case TicketPurchaseRefreshRequested():
return refreshRequested(_that);case TicketPurchaseIdCardSaved():
return idCardSaved(_that);case TicketPurchaseConfirmPaymentRequested():
return confirmPaymentRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TicketPurchaseStarted value)?  started,TResult? Function( TicketPurchaseRefreshRequested value)?  refreshRequested,TResult? Function( TicketPurchaseIdCardSaved value)?  idCardSaved,TResult? Function( TicketPurchaseConfirmPaymentRequested value)?  confirmPaymentRequested,}){
final _that = this;
switch (_that) {
case TicketPurchaseStarted() when started != null:
return started(_that);case TicketPurchaseRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case TicketPurchaseIdCardSaved() when idCardSaved != null:
return idCardSaved(_that);case TicketPurchaseConfirmPaymentRequested() when confirmPaymentRequested != null:
return confirmPaymentRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String tierId,  bool queued,  bool isUpgrade,  double? payableAmount)?  started,TResult Function()?  refreshRequested,TResult Function( String idCard)?  idCardSaved,TResult Function()?  confirmPaymentRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TicketPurchaseStarted() when started != null:
return started(_that.tierId,_that.queued,_that.isUpgrade,_that.payableAmount);case TicketPurchaseRefreshRequested() when refreshRequested != null:
return refreshRequested();case TicketPurchaseIdCardSaved() when idCardSaved != null:
return idCardSaved(_that.idCard);case TicketPurchaseConfirmPaymentRequested() when confirmPaymentRequested != null:
return confirmPaymentRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String tierId,  bool queued,  bool isUpgrade,  double? payableAmount)  started,required TResult Function()  refreshRequested,required TResult Function( String idCard)  idCardSaved,required TResult Function()  confirmPaymentRequested,}) {final _that = this;
switch (_that) {
case TicketPurchaseStarted():
return started(_that.tierId,_that.queued,_that.isUpgrade,_that.payableAmount);case TicketPurchaseRefreshRequested():
return refreshRequested();case TicketPurchaseIdCardSaved():
return idCardSaved(_that.idCard);case TicketPurchaseConfirmPaymentRequested():
return confirmPaymentRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String tierId,  bool queued,  bool isUpgrade,  double? payableAmount)?  started,TResult? Function()?  refreshRequested,TResult? Function( String idCard)?  idCardSaved,TResult? Function()?  confirmPaymentRequested,}) {final _that = this;
switch (_that) {
case TicketPurchaseStarted() when started != null:
return started(_that.tierId,_that.queued,_that.isUpgrade,_that.payableAmount);case TicketPurchaseRefreshRequested() when refreshRequested != null:
return refreshRequested();case TicketPurchaseIdCardSaved() when idCardSaved != null:
return idCardSaved(_that.idCard);case TicketPurchaseConfirmPaymentRequested() when confirmPaymentRequested != null:
return confirmPaymentRequested();case _:
  return null;

}
}

}

/// @nodoc


class TicketPurchaseStarted implements TicketPurchaseEvent {
  const TicketPurchaseStarted({required this.tierId, this.queued = false, this.isUpgrade = false, this.payableAmount});
  

 final  String tierId;
@JsonKey() final  bool queued;
@JsonKey() final  bool isUpgrade;
 final  double? payableAmount;

/// Create a copy of TicketPurchaseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketPurchaseStartedCopyWith<TicketPurchaseStarted> get copyWith => _$TicketPurchaseStartedCopyWithImpl<TicketPurchaseStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseStarted&&(identical(other.tierId, tierId) || other.tierId == tierId)&&(identical(other.queued, queued) || other.queued == queued)&&(identical(other.isUpgrade, isUpgrade) || other.isUpgrade == isUpgrade)&&(identical(other.payableAmount, payableAmount) || other.payableAmount == payableAmount));
}


@override
int get hashCode => Object.hash(runtimeType,tierId,queued,isUpgrade,payableAmount);

@override
String toString() {
  return 'TicketPurchaseEvent.started(tierId: $tierId, queued: $queued, isUpgrade: $isUpgrade, payableAmount: $payableAmount)';
}


}

/// @nodoc
abstract mixin class $TicketPurchaseStartedCopyWith<$Res> implements $TicketPurchaseEventCopyWith<$Res> {
  factory $TicketPurchaseStartedCopyWith(TicketPurchaseStarted value, $Res Function(TicketPurchaseStarted) _then) = _$TicketPurchaseStartedCopyWithImpl;
@useResult
$Res call({
 String tierId, bool queued, bool isUpgrade, double? payableAmount
});




}
/// @nodoc
class _$TicketPurchaseStartedCopyWithImpl<$Res>
    implements $TicketPurchaseStartedCopyWith<$Res> {
  _$TicketPurchaseStartedCopyWithImpl(this._self, this._then);

  final TicketPurchaseStarted _self;
  final $Res Function(TicketPurchaseStarted) _then;

/// Create a copy of TicketPurchaseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tierId = null,Object? queued = null,Object? isUpgrade = null,Object? payableAmount = freezed,}) {
  return _then(TicketPurchaseStarted(
tierId: null == tierId ? _self.tierId : tierId // ignore: cast_nullable_to_non_nullable
as String,queued: null == queued ? _self.queued : queued // ignore: cast_nullable_to_non_nullable
as bool,isUpgrade: null == isUpgrade ? _self.isUpgrade : isUpgrade // ignore: cast_nullable_to_non_nullable
as bool,payableAmount: freezed == payableAmount ? _self.payableAmount : payableAmount // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc


class TicketPurchaseRefreshRequested implements TicketPurchaseEvent {
  const TicketPurchaseRefreshRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseRefreshRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketPurchaseEvent.refreshRequested()';
}


}




/// @nodoc


class TicketPurchaseIdCardSaved implements TicketPurchaseEvent {
  const TicketPurchaseIdCardSaved(this.idCard);
  

 final  String idCard;

/// Create a copy of TicketPurchaseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketPurchaseIdCardSavedCopyWith<TicketPurchaseIdCardSaved> get copyWith => _$TicketPurchaseIdCardSavedCopyWithImpl<TicketPurchaseIdCardSaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseIdCardSaved&&(identical(other.idCard, idCard) || other.idCard == idCard));
}


@override
int get hashCode => Object.hash(runtimeType,idCard);

@override
String toString() {
  return 'TicketPurchaseEvent.idCardSaved(idCard: $idCard)';
}


}

/// @nodoc
abstract mixin class $TicketPurchaseIdCardSavedCopyWith<$Res> implements $TicketPurchaseEventCopyWith<$Res> {
  factory $TicketPurchaseIdCardSavedCopyWith(TicketPurchaseIdCardSaved value, $Res Function(TicketPurchaseIdCardSaved) _then) = _$TicketPurchaseIdCardSavedCopyWithImpl;
@useResult
$Res call({
 String idCard
});




}
/// @nodoc
class _$TicketPurchaseIdCardSavedCopyWithImpl<$Res>
    implements $TicketPurchaseIdCardSavedCopyWith<$Res> {
  _$TicketPurchaseIdCardSavedCopyWithImpl(this._self, this._then);

  final TicketPurchaseIdCardSaved _self;
  final $Res Function(TicketPurchaseIdCardSaved) _then;

/// Create a copy of TicketPurchaseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? idCard = null,}) {
  return _then(TicketPurchaseIdCardSaved(
null == idCard ? _self.idCard : idCard // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TicketPurchaseConfirmPaymentRequested implements TicketPurchaseEvent {
  const TicketPurchaseConfirmPaymentRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseConfirmPaymentRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketPurchaseEvent.confirmPaymentRequested()';
}


}




// dart format on
