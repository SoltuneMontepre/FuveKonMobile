// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_purchase_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketPurchaseState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketPurchaseState()';
}


}

/// @nodoc
class $TicketPurchaseStateCopyWith<$Res>  {
$TicketPurchaseStateCopyWith(TicketPurchaseState _, $Res Function(TicketPurchaseState) __);
}


/// Adds pattern-matching-related methods to [TicketPurchaseState].
extension TicketPurchaseStatePatterns on TicketPurchaseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TicketPurchaseInitial value)?  initial,TResult Function( TicketPurchaseLoading value)?  loading,TResult Function( TicketPurchasePolling value)?  polling,TResult Function( TicketPurchaseLoaded value)?  loaded,TResult Function( TicketPurchaseNotFound value)?  notFound,TResult Function( TicketPurchaseQueueTimedOut value)?  queueTimedOut,TResult Function( TicketPurchaseDenied value)?  denied,TResult Function( TicketPurchaseFailure value)?  failure,TResult Function( TicketPurchaseConfirmed value)?  confirmed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TicketPurchaseInitial() when initial != null:
return initial(_that);case TicketPurchaseLoading() when loading != null:
return loading(_that);case TicketPurchasePolling() when polling != null:
return polling(_that);case TicketPurchaseLoaded() when loaded != null:
return loaded(_that);case TicketPurchaseNotFound() when notFound != null:
return notFound(_that);case TicketPurchaseQueueTimedOut() when queueTimedOut != null:
return queueTimedOut(_that);case TicketPurchaseDenied() when denied != null:
return denied(_that);case TicketPurchaseFailure() when failure != null:
return failure(_that);case TicketPurchaseConfirmed() when confirmed != null:
return confirmed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TicketPurchaseInitial value)  initial,required TResult Function( TicketPurchaseLoading value)  loading,required TResult Function( TicketPurchasePolling value)  polling,required TResult Function( TicketPurchaseLoaded value)  loaded,required TResult Function( TicketPurchaseNotFound value)  notFound,required TResult Function( TicketPurchaseQueueTimedOut value)  queueTimedOut,required TResult Function( TicketPurchaseDenied value)  denied,required TResult Function( TicketPurchaseFailure value)  failure,required TResult Function( TicketPurchaseConfirmed value)  confirmed,}){
final _that = this;
switch (_that) {
case TicketPurchaseInitial():
return initial(_that);case TicketPurchaseLoading():
return loading(_that);case TicketPurchasePolling():
return polling(_that);case TicketPurchaseLoaded():
return loaded(_that);case TicketPurchaseNotFound():
return notFound(_that);case TicketPurchaseQueueTimedOut():
return queueTimedOut(_that);case TicketPurchaseDenied():
return denied(_that);case TicketPurchaseFailure():
return failure(_that);case TicketPurchaseConfirmed():
return confirmed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TicketPurchaseInitial value)?  initial,TResult? Function( TicketPurchaseLoading value)?  loading,TResult? Function( TicketPurchasePolling value)?  polling,TResult? Function( TicketPurchaseLoaded value)?  loaded,TResult? Function( TicketPurchaseNotFound value)?  notFound,TResult? Function( TicketPurchaseQueueTimedOut value)?  queueTimedOut,TResult? Function( TicketPurchaseDenied value)?  denied,TResult? Function( TicketPurchaseFailure value)?  failure,TResult? Function( TicketPurchaseConfirmed value)?  confirmed,}){
final _that = this;
switch (_that) {
case TicketPurchaseInitial() when initial != null:
return initial(_that);case TicketPurchaseLoading() when loading != null:
return loading(_that);case TicketPurchasePolling() when polling != null:
return polling(_that);case TicketPurchaseLoaded() when loaded != null:
return loaded(_that);case TicketPurchaseNotFound() when notFound != null:
return notFound(_that);case TicketPurchaseQueueTimedOut() when queueTimedOut != null:
return queueTimedOut(_that);case TicketPurchaseDenied() when denied != null:
return denied(_that);case TicketPurchaseFailure() when failure != null:
return failure(_that);case TicketPurchaseConfirmed() when confirmed != null:
return confirmed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( int attempt,  int maxAttempts)?  polling,TResult Function( UserTicket ticket,  Account account,  String tierId,  bool queued,  bool isConfirming,  bool isSavingIdCard,  bool isUpgrade,  double? payableAmount)?  loaded,TResult Function( bool queued)?  notFound,TResult Function()?  queueTimedOut,TResult Function( UserTicket ticket,  String denialReason)?  denied,TResult Function( String message)?  failure,TResult Function( UserTicket ticket)?  confirmed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TicketPurchaseInitial() when initial != null:
return initial();case TicketPurchaseLoading() when loading != null:
return loading();case TicketPurchasePolling() when polling != null:
return polling(_that.attempt,_that.maxAttempts);case TicketPurchaseLoaded() when loaded != null:
return loaded(_that.ticket,_that.account,_that.tierId,_that.queued,_that.isConfirming,_that.isSavingIdCard,_that.isUpgrade,_that.payableAmount);case TicketPurchaseNotFound() when notFound != null:
return notFound(_that.queued);case TicketPurchaseQueueTimedOut() when queueTimedOut != null:
return queueTimedOut();case TicketPurchaseDenied() when denied != null:
return denied(_that.ticket,_that.denialReason);case TicketPurchaseFailure() when failure != null:
return failure(_that.message);case TicketPurchaseConfirmed() when confirmed != null:
return confirmed(_that.ticket);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( int attempt,  int maxAttempts)  polling,required TResult Function( UserTicket ticket,  Account account,  String tierId,  bool queued,  bool isConfirming,  bool isSavingIdCard,  bool isUpgrade,  double? payableAmount)  loaded,required TResult Function( bool queued)  notFound,required TResult Function()  queueTimedOut,required TResult Function( UserTicket ticket,  String denialReason)  denied,required TResult Function( String message)  failure,required TResult Function( UserTicket ticket)  confirmed,}) {final _that = this;
switch (_that) {
case TicketPurchaseInitial():
return initial();case TicketPurchaseLoading():
return loading();case TicketPurchasePolling():
return polling(_that.attempt,_that.maxAttempts);case TicketPurchaseLoaded():
return loaded(_that.ticket,_that.account,_that.tierId,_that.queued,_that.isConfirming,_that.isSavingIdCard,_that.isUpgrade,_that.payableAmount);case TicketPurchaseNotFound():
return notFound(_that.queued);case TicketPurchaseQueueTimedOut():
return queueTimedOut();case TicketPurchaseDenied():
return denied(_that.ticket,_that.denialReason);case TicketPurchaseFailure():
return failure(_that.message);case TicketPurchaseConfirmed():
return confirmed(_that.ticket);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( int attempt,  int maxAttempts)?  polling,TResult? Function( UserTicket ticket,  Account account,  String tierId,  bool queued,  bool isConfirming,  bool isSavingIdCard,  bool isUpgrade,  double? payableAmount)?  loaded,TResult? Function( bool queued)?  notFound,TResult? Function()?  queueTimedOut,TResult? Function( UserTicket ticket,  String denialReason)?  denied,TResult? Function( String message)?  failure,TResult? Function( UserTicket ticket)?  confirmed,}) {final _that = this;
switch (_that) {
case TicketPurchaseInitial() when initial != null:
return initial();case TicketPurchaseLoading() when loading != null:
return loading();case TicketPurchasePolling() when polling != null:
return polling(_that.attempt,_that.maxAttempts);case TicketPurchaseLoaded() when loaded != null:
return loaded(_that.ticket,_that.account,_that.tierId,_that.queued,_that.isConfirming,_that.isSavingIdCard,_that.isUpgrade,_that.payableAmount);case TicketPurchaseNotFound() when notFound != null:
return notFound(_that.queued);case TicketPurchaseQueueTimedOut() when queueTimedOut != null:
return queueTimedOut();case TicketPurchaseDenied() when denied != null:
return denied(_that.ticket,_that.denialReason);case TicketPurchaseFailure() when failure != null:
return failure(_that.message);case TicketPurchaseConfirmed() when confirmed != null:
return confirmed(_that.ticket);case _:
  return null;

}
}

}

/// @nodoc


class TicketPurchaseInitial implements TicketPurchaseState {
  const TicketPurchaseInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketPurchaseState.initial()';
}


}




/// @nodoc


class TicketPurchaseLoading implements TicketPurchaseState {
  const TicketPurchaseLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketPurchaseState.loading()';
}


}




/// @nodoc


class TicketPurchasePolling implements TicketPurchaseState {
  const TicketPurchasePolling({required this.attempt, required this.maxAttempts});
  

 final  int attempt;
 final  int maxAttempts;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketPurchasePollingCopyWith<TicketPurchasePolling> get copyWith => _$TicketPurchasePollingCopyWithImpl<TicketPurchasePolling>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchasePolling&&(identical(other.attempt, attempt) || other.attempt == attempt)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts));
}


@override
int get hashCode => Object.hash(runtimeType,attempt,maxAttempts);

@override
String toString() {
  return 'TicketPurchaseState.polling(attempt: $attempt, maxAttempts: $maxAttempts)';
}


}

/// @nodoc
abstract mixin class $TicketPurchasePollingCopyWith<$Res> implements $TicketPurchaseStateCopyWith<$Res> {
  factory $TicketPurchasePollingCopyWith(TicketPurchasePolling value, $Res Function(TicketPurchasePolling) _then) = _$TicketPurchasePollingCopyWithImpl;
@useResult
$Res call({
 int attempt, int maxAttempts
});




}
/// @nodoc
class _$TicketPurchasePollingCopyWithImpl<$Res>
    implements $TicketPurchasePollingCopyWith<$Res> {
  _$TicketPurchasePollingCopyWithImpl(this._self, this._then);

  final TicketPurchasePolling _self;
  final $Res Function(TicketPurchasePolling) _then;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? attempt = null,Object? maxAttempts = null,}) {
  return _then(TicketPurchasePolling(
attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TicketPurchaseLoaded implements TicketPurchaseState {
  const TicketPurchaseLoaded({required this.ticket, required this.account, required this.tierId, this.queued = false, this.isConfirming = false, this.isSavingIdCard = false, this.isUpgrade = false, this.payableAmount});
  

 final  UserTicket ticket;
 final  Account account;
 final  String tierId;
@JsonKey() final  bool queued;
@JsonKey() final  bool isConfirming;
@JsonKey() final  bool isSavingIdCard;
@JsonKey() final  bool isUpgrade;
 final  double? payableAmount;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketPurchaseLoadedCopyWith<TicketPurchaseLoaded> get copyWith => _$TicketPurchaseLoadedCopyWithImpl<TicketPurchaseLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseLoaded&&(identical(other.ticket, ticket) || other.ticket == ticket)&&(identical(other.account, account) || other.account == account)&&(identical(other.tierId, tierId) || other.tierId == tierId)&&(identical(other.queued, queued) || other.queued == queued)&&(identical(other.isConfirming, isConfirming) || other.isConfirming == isConfirming)&&(identical(other.isSavingIdCard, isSavingIdCard) || other.isSavingIdCard == isSavingIdCard)&&(identical(other.isUpgrade, isUpgrade) || other.isUpgrade == isUpgrade)&&(identical(other.payableAmount, payableAmount) || other.payableAmount == payableAmount));
}


@override
int get hashCode => Object.hash(runtimeType,ticket,account,tierId,queued,isConfirming,isSavingIdCard,isUpgrade,payableAmount);

@override
String toString() {
  return 'TicketPurchaseState.loaded(ticket: $ticket, account: $account, tierId: $tierId, queued: $queued, isConfirming: $isConfirming, isSavingIdCard: $isSavingIdCard, isUpgrade: $isUpgrade, payableAmount: $payableAmount)';
}


}

/// @nodoc
abstract mixin class $TicketPurchaseLoadedCopyWith<$Res> implements $TicketPurchaseStateCopyWith<$Res> {
  factory $TicketPurchaseLoadedCopyWith(TicketPurchaseLoaded value, $Res Function(TicketPurchaseLoaded) _then) = _$TicketPurchaseLoadedCopyWithImpl;
@useResult
$Res call({
 UserTicket ticket, Account account, String tierId, bool queued, bool isConfirming, bool isSavingIdCard, bool isUpgrade, double? payableAmount
});




}
/// @nodoc
class _$TicketPurchaseLoadedCopyWithImpl<$Res>
    implements $TicketPurchaseLoadedCopyWith<$Res> {
  _$TicketPurchaseLoadedCopyWithImpl(this._self, this._then);

  final TicketPurchaseLoaded _self;
  final $Res Function(TicketPurchaseLoaded) _then;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ticket = null,Object? account = null,Object? tierId = null,Object? queued = null,Object? isConfirming = null,Object? isSavingIdCard = null,Object? isUpgrade = null,Object? payableAmount = freezed,}) {
  return _then(TicketPurchaseLoaded(
ticket: null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as UserTicket,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account,tierId: null == tierId ? _self.tierId : tierId // ignore: cast_nullable_to_non_nullable
as String,queued: null == queued ? _self.queued : queued // ignore: cast_nullable_to_non_nullable
as bool,isConfirming: null == isConfirming ? _self.isConfirming : isConfirming // ignore: cast_nullable_to_non_nullable
as bool,isSavingIdCard: null == isSavingIdCard ? _self.isSavingIdCard : isSavingIdCard // ignore: cast_nullable_to_non_nullable
as bool,isUpgrade: null == isUpgrade ? _self.isUpgrade : isUpgrade // ignore: cast_nullable_to_non_nullable
as bool,payableAmount: freezed == payableAmount ? _self.payableAmount : payableAmount // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc


class TicketPurchaseNotFound implements TicketPurchaseState {
  const TicketPurchaseNotFound({this.queued = false});
  

@JsonKey() final  bool queued;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketPurchaseNotFoundCopyWith<TicketPurchaseNotFound> get copyWith => _$TicketPurchaseNotFoundCopyWithImpl<TicketPurchaseNotFound>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseNotFound&&(identical(other.queued, queued) || other.queued == queued));
}


@override
int get hashCode => Object.hash(runtimeType,queued);

@override
String toString() {
  return 'TicketPurchaseState.notFound(queued: $queued)';
}


}

/// @nodoc
abstract mixin class $TicketPurchaseNotFoundCopyWith<$Res> implements $TicketPurchaseStateCopyWith<$Res> {
  factory $TicketPurchaseNotFoundCopyWith(TicketPurchaseNotFound value, $Res Function(TicketPurchaseNotFound) _then) = _$TicketPurchaseNotFoundCopyWithImpl;
@useResult
$Res call({
 bool queued
});




}
/// @nodoc
class _$TicketPurchaseNotFoundCopyWithImpl<$Res>
    implements $TicketPurchaseNotFoundCopyWith<$Res> {
  _$TicketPurchaseNotFoundCopyWithImpl(this._self, this._then);

  final TicketPurchaseNotFound _self;
  final $Res Function(TicketPurchaseNotFound) _then;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? queued = null,}) {
  return _then(TicketPurchaseNotFound(
queued: null == queued ? _self.queued : queued // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class TicketPurchaseQueueTimedOut implements TicketPurchaseState {
  const TicketPurchaseQueueTimedOut();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseQueueTimedOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketPurchaseState.queueTimedOut()';
}


}




/// @nodoc


class TicketPurchaseDenied implements TicketPurchaseState {
  const TicketPurchaseDenied({required this.ticket, required this.denialReason});
  

 final  UserTicket ticket;
 final  String denialReason;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketPurchaseDeniedCopyWith<TicketPurchaseDenied> get copyWith => _$TicketPurchaseDeniedCopyWithImpl<TicketPurchaseDenied>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseDenied&&(identical(other.ticket, ticket) || other.ticket == ticket)&&(identical(other.denialReason, denialReason) || other.denialReason == denialReason));
}


@override
int get hashCode => Object.hash(runtimeType,ticket,denialReason);

@override
String toString() {
  return 'TicketPurchaseState.denied(ticket: $ticket, denialReason: $denialReason)';
}


}

/// @nodoc
abstract mixin class $TicketPurchaseDeniedCopyWith<$Res> implements $TicketPurchaseStateCopyWith<$Res> {
  factory $TicketPurchaseDeniedCopyWith(TicketPurchaseDenied value, $Res Function(TicketPurchaseDenied) _then) = _$TicketPurchaseDeniedCopyWithImpl;
@useResult
$Res call({
 UserTicket ticket, String denialReason
});




}
/// @nodoc
class _$TicketPurchaseDeniedCopyWithImpl<$Res>
    implements $TicketPurchaseDeniedCopyWith<$Res> {
  _$TicketPurchaseDeniedCopyWithImpl(this._self, this._then);

  final TicketPurchaseDenied _self;
  final $Res Function(TicketPurchaseDenied) _then;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ticket = null,Object? denialReason = null,}) {
  return _then(TicketPurchaseDenied(
ticket: null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as UserTicket,denialReason: null == denialReason ? _self.denialReason : denialReason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TicketPurchaseFailure implements TicketPurchaseState {
  const TicketPurchaseFailure(this.message);
  

 final  String message;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketPurchaseFailureCopyWith<TicketPurchaseFailure> get copyWith => _$TicketPurchaseFailureCopyWithImpl<TicketPurchaseFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TicketPurchaseState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $TicketPurchaseFailureCopyWith<$Res> implements $TicketPurchaseStateCopyWith<$Res> {
  factory $TicketPurchaseFailureCopyWith(TicketPurchaseFailure value, $Res Function(TicketPurchaseFailure) _then) = _$TicketPurchaseFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TicketPurchaseFailureCopyWithImpl<$Res>
    implements $TicketPurchaseFailureCopyWith<$Res> {
  _$TicketPurchaseFailureCopyWithImpl(this._self, this._then);

  final TicketPurchaseFailure _self;
  final $Res Function(TicketPurchaseFailure) _then;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TicketPurchaseFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TicketPurchaseConfirmed implements TicketPurchaseState {
  const TicketPurchaseConfirmed(this.ticket);
  

 final  UserTicket ticket;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketPurchaseConfirmedCopyWith<TicketPurchaseConfirmed> get copyWith => _$TicketPurchaseConfirmedCopyWithImpl<TicketPurchaseConfirmed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPurchaseConfirmed&&(identical(other.ticket, ticket) || other.ticket == ticket));
}


@override
int get hashCode => Object.hash(runtimeType,ticket);

@override
String toString() {
  return 'TicketPurchaseState.confirmed(ticket: $ticket)';
}


}

/// @nodoc
abstract mixin class $TicketPurchaseConfirmedCopyWith<$Res> implements $TicketPurchaseStateCopyWith<$Res> {
  factory $TicketPurchaseConfirmedCopyWith(TicketPurchaseConfirmed value, $Res Function(TicketPurchaseConfirmed) _then) = _$TicketPurchaseConfirmedCopyWithImpl;
@useResult
$Res call({
 UserTicket ticket
});




}
/// @nodoc
class _$TicketPurchaseConfirmedCopyWithImpl<$Res>
    implements $TicketPurchaseConfirmedCopyWith<$Res> {
  _$TicketPurchaseConfirmedCopyWithImpl(this._self, this._then);

  final TicketPurchaseConfirmed _self;
  final $Res Function(TicketPurchaseConfirmed) _then;

/// Create a copy of TicketPurchaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ticket = null,}) {
  return _then(TicketPurchaseConfirmed(
null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as UserTicket,
  ));
}


}

// dart format on
