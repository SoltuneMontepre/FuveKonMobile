// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_ticket_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyTicketState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyTicketState()';
}


}

/// @nodoc
class $MyTicketStateCopyWith<$Res>  {
$MyTicketStateCopyWith(MyTicketState _, $Res Function(MyTicketState) __);
}


/// Adds pattern-matching-related methods to [MyTicketState].
extension MyTicketStatePatterns on MyTicketState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MyTicketInitial value)?  initial,TResult Function( MyTicketLoading value)?  loading,TResult Function( MyTicketLoaded value)?  loaded,TResult Function( MyTicketEmpty value)?  empty,TResult Function( MyTicketFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MyTicketInitial() when initial != null:
return initial(_that);case MyTicketLoading() when loading != null:
return loading(_that);case MyTicketLoaded() when loaded != null:
return loaded(_that);case MyTicketEmpty() when empty != null:
return empty(_that);case MyTicketFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MyTicketInitial value)  initial,required TResult Function( MyTicketLoading value)  loading,required TResult Function( MyTicketLoaded value)  loaded,required TResult Function( MyTicketEmpty value)  empty,required TResult Function( MyTicketFailure value)  failure,}){
final _that = this;
switch (_that) {
case MyTicketInitial():
return initial(_that);case MyTicketLoading():
return loading(_that);case MyTicketLoaded():
return loaded(_that);case MyTicketEmpty():
return empty(_that);case MyTicketFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MyTicketInitial value)?  initial,TResult? Function( MyTicketLoading value)?  loading,TResult? Function( MyTicketLoaded value)?  loaded,TResult? Function( MyTicketEmpty value)?  empty,TResult? Function( MyTicketFailure value)?  failure,}){
final _that = this;
switch (_that) {
case MyTicketInitial() when initial != null:
return initial(_that);case MyTicketLoading() when loading != null:
return loading(_that);case MyTicketLoaded() when loaded != null:
return loaded(_that);case MyTicketEmpty() when empty != null:
return empty(_that);case MyTicketFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( UserTicket ticket,  Account account,  String badgeName,  bool isFursuiter,  bool isFursuitStaff,  bool isSavingNameCard,  bool isGeneratingPreview)?  loaded,TResult Function()?  empty,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MyTicketInitial() when initial != null:
return initial();case MyTicketLoading() when loading != null:
return loading();case MyTicketLoaded() when loaded != null:
return loaded(_that.ticket,_that.account,_that.badgeName,_that.isFursuiter,_that.isFursuitStaff,_that.isSavingNameCard,_that.isGeneratingPreview);case MyTicketEmpty() when empty != null:
return empty();case MyTicketFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( UserTicket ticket,  Account account,  String badgeName,  bool isFursuiter,  bool isFursuitStaff,  bool isSavingNameCard,  bool isGeneratingPreview)  loaded,required TResult Function()  empty,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case MyTicketInitial():
return initial();case MyTicketLoading():
return loading();case MyTicketLoaded():
return loaded(_that.ticket,_that.account,_that.badgeName,_that.isFursuiter,_that.isFursuitStaff,_that.isSavingNameCard,_that.isGeneratingPreview);case MyTicketEmpty():
return empty();case MyTicketFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( UserTicket ticket,  Account account,  String badgeName,  bool isFursuiter,  bool isFursuitStaff,  bool isSavingNameCard,  bool isGeneratingPreview)?  loaded,TResult? Function()?  empty,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case MyTicketInitial() when initial != null:
return initial();case MyTicketLoading() when loading != null:
return loading();case MyTicketLoaded() when loaded != null:
return loaded(_that.ticket,_that.account,_that.badgeName,_that.isFursuiter,_that.isFursuitStaff,_that.isSavingNameCard,_that.isGeneratingPreview);case MyTicketEmpty() when empty != null:
return empty();case MyTicketFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class MyTicketInitial implements MyTicketState {
  const MyTicketInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyTicketState.initial()';
}


}




/// @nodoc


class MyTicketLoading implements MyTicketState {
  const MyTicketLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyTicketState.loading()';
}


}




/// @nodoc


class MyTicketLoaded implements MyTicketState {
  const MyTicketLoaded({required this.ticket, required this.account, required this.badgeName, required this.isFursuiter, required this.isFursuitStaff, this.isSavingNameCard = false, this.isGeneratingPreview = false});
  

 final  UserTicket ticket;
 final  Account account;
 final  String badgeName;
 final  bool isFursuiter;
 final  bool isFursuitStaff;
@JsonKey() final  bool isSavingNameCard;
@JsonKey() final  bool isGeneratingPreview;

/// Create a copy of MyTicketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyTicketLoadedCopyWith<MyTicketLoaded> get copyWith => _$MyTicketLoadedCopyWithImpl<MyTicketLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketLoaded&&(identical(other.ticket, ticket) || other.ticket == ticket)&&(identical(other.account, account) || other.account == account)&&(identical(other.badgeName, badgeName) || other.badgeName == badgeName)&&(identical(other.isFursuiter, isFursuiter) || other.isFursuiter == isFursuiter)&&(identical(other.isFursuitStaff, isFursuitStaff) || other.isFursuitStaff == isFursuitStaff)&&(identical(other.isSavingNameCard, isSavingNameCard) || other.isSavingNameCard == isSavingNameCard)&&(identical(other.isGeneratingPreview, isGeneratingPreview) || other.isGeneratingPreview == isGeneratingPreview));
}


@override
int get hashCode => Object.hash(runtimeType,ticket,account,badgeName,isFursuiter,isFursuitStaff,isSavingNameCard,isGeneratingPreview);

@override
String toString() {
  return 'MyTicketState.loaded(ticket: $ticket, account: $account, badgeName: $badgeName, isFursuiter: $isFursuiter, isFursuitStaff: $isFursuitStaff, isSavingNameCard: $isSavingNameCard, isGeneratingPreview: $isGeneratingPreview)';
}


}

/// @nodoc
abstract mixin class $MyTicketLoadedCopyWith<$Res> implements $MyTicketStateCopyWith<$Res> {
  factory $MyTicketLoadedCopyWith(MyTicketLoaded value, $Res Function(MyTicketLoaded) _then) = _$MyTicketLoadedCopyWithImpl;
@useResult
$Res call({
 UserTicket ticket, Account account, String badgeName, bool isFursuiter, bool isFursuitStaff, bool isSavingNameCard, bool isGeneratingPreview
});




}
/// @nodoc
class _$MyTicketLoadedCopyWithImpl<$Res>
    implements $MyTicketLoadedCopyWith<$Res> {
  _$MyTicketLoadedCopyWithImpl(this._self, this._then);

  final MyTicketLoaded _self;
  final $Res Function(MyTicketLoaded) _then;

/// Create a copy of MyTicketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ticket = null,Object? account = null,Object? badgeName = null,Object? isFursuiter = null,Object? isFursuitStaff = null,Object? isSavingNameCard = null,Object? isGeneratingPreview = null,}) {
  return _then(MyTicketLoaded(
ticket: null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as UserTicket,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account,badgeName: null == badgeName ? _self.badgeName : badgeName // ignore: cast_nullable_to_non_nullable
as String,isFursuiter: null == isFursuiter ? _self.isFursuiter : isFursuiter // ignore: cast_nullable_to_non_nullable
as bool,isFursuitStaff: null == isFursuitStaff ? _self.isFursuitStaff : isFursuitStaff // ignore: cast_nullable_to_non_nullable
as bool,isSavingNameCard: null == isSavingNameCard ? _self.isSavingNameCard : isSavingNameCard // ignore: cast_nullable_to_non_nullable
as bool,isGeneratingPreview: null == isGeneratingPreview ? _self.isGeneratingPreview : isGeneratingPreview // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class MyTicketEmpty implements MyTicketState {
  const MyTicketEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyTicketState.empty()';
}


}




/// @nodoc


class MyTicketFailure implements MyTicketState {
  const MyTicketFailure(this.message);
  

 final  String message;

/// Create a copy of MyTicketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyTicketFailureCopyWith<MyTicketFailure> get copyWith => _$MyTicketFailureCopyWithImpl<MyTicketFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTicketFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'MyTicketState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $MyTicketFailureCopyWith<$Res> implements $MyTicketStateCopyWith<$Res> {
  factory $MyTicketFailureCopyWith(MyTicketFailure value, $Res Function(MyTicketFailure) _then) = _$MyTicketFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MyTicketFailureCopyWithImpl<$Res>
    implements $MyTicketFailureCopyWith<$Res> {
  _$MyTicketFailureCopyWithImpl(this._self, this._then);

  final MyTicketFailure _self;
  final $Res Function(MyTicketFailure) _then;

/// Create a copy of MyTicketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MyTicketFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
