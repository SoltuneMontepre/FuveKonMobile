// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthStarted value)?  started,TResult Function( AuthLoginSubmitted value)?  loginSubmitted,TResult Function( AuthGoogleSignInRequested value)?  googleSignInRequested,TResult Function( AuthGoogleRegisterSubmitted value)?  googleRegisterSubmitted,TResult Function( AuthGoogleRegistrationNavigated value)?  googleRegistrationNavigated,TResult Function( AuthLogoutRequested value)?  logoutRequested,TResult Function( AuthSessionExpired value)?  sessionExpired,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started(_that);case AuthLoginSubmitted() when loginSubmitted != null:
return loginSubmitted(_that);case AuthGoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested(_that);case AuthGoogleRegisterSubmitted() when googleRegisterSubmitted != null:
return googleRegisterSubmitted(_that);case AuthGoogleRegistrationNavigated() when googleRegistrationNavigated != null:
return googleRegistrationNavigated(_that);case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case AuthSessionExpired() when sessionExpired != null:
return sessionExpired(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthStarted value)  started,required TResult Function( AuthLoginSubmitted value)  loginSubmitted,required TResult Function( AuthGoogleSignInRequested value)  googleSignInRequested,required TResult Function( AuthGoogleRegisterSubmitted value)  googleRegisterSubmitted,required TResult Function( AuthGoogleRegistrationNavigated value)  googleRegistrationNavigated,required TResult Function( AuthLogoutRequested value)  logoutRequested,required TResult Function( AuthSessionExpired value)  sessionExpired,}){
final _that = this;
switch (_that) {
case AuthStarted():
return started(_that);case AuthLoginSubmitted():
return loginSubmitted(_that);case AuthGoogleSignInRequested():
return googleSignInRequested(_that);case AuthGoogleRegisterSubmitted():
return googleRegisterSubmitted(_that);case AuthGoogleRegistrationNavigated():
return googleRegistrationNavigated(_that);case AuthLogoutRequested():
return logoutRequested(_that);case AuthSessionExpired():
return sessionExpired(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthStarted value)?  started,TResult? Function( AuthLoginSubmitted value)?  loginSubmitted,TResult? Function( AuthGoogleSignInRequested value)?  googleSignInRequested,TResult? Function( AuthGoogleRegisterSubmitted value)?  googleRegisterSubmitted,TResult? Function( AuthGoogleRegistrationNavigated value)?  googleRegistrationNavigated,TResult? Function( AuthLogoutRequested value)?  logoutRequested,TResult? Function( AuthSessionExpired value)?  sessionExpired,}){
final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started(_that);case AuthLoginSubmitted() when loginSubmitted != null:
return loginSubmitted(_that);case AuthGoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested(_that);case AuthGoogleRegisterSubmitted() when googleRegisterSubmitted != null:
return googleRegisterSubmitted(_that);case AuthGoogleRegistrationNavigated() when googleRegistrationNavigated != null:
return googleRegistrationNavigated(_that);case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case AuthSessionExpired() when sessionExpired != null:
return sessionExpired(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String email,  String password)?  loginSubmitted,TResult Function()?  googleSignInRequested,TResult Function( String credential,  String fullName,  String nickname,  String dateOfBirth,  String country)?  googleRegisterSubmitted,TResult Function()?  googleRegistrationNavigated,TResult Function()?  logoutRequested,TResult Function()?  sessionExpired,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started();case AuthLoginSubmitted() when loginSubmitted != null:
return loginSubmitted(_that.email,_that.password);case AuthGoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested();case AuthGoogleRegisterSubmitted() when googleRegisterSubmitted != null:
return googleRegisterSubmitted(_that.credential,_that.fullName,_that.nickname,_that.dateOfBirth,_that.country);case AuthGoogleRegistrationNavigated() when googleRegistrationNavigated != null:
return googleRegistrationNavigated();case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested();case AuthSessionExpired() when sessionExpired != null:
return sessionExpired();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String email,  String password)  loginSubmitted,required TResult Function()  googleSignInRequested,required TResult Function( String credential,  String fullName,  String nickname,  String dateOfBirth,  String country)  googleRegisterSubmitted,required TResult Function()  googleRegistrationNavigated,required TResult Function()  logoutRequested,required TResult Function()  sessionExpired,}) {final _that = this;
switch (_that) {
case AuthStarted():
return started();case AuthLoginSubmitted():
return loginSubmitted(_that.email,_that.password);case AuthGoogleSignInRequested():
return googleSignInRequested();case AuthGoogleRegisterSubmitted():
return googleRegisterSubmitted(_that.credential,_that.fullName,_that.nickname,_that.dateOfBirth,_that.country);case AuthGoogleRegistrationNavigated():
return googleRegistrationNavigated();case AuthLogoutRequested():
return logoutRequested();case AuthSessionExpired():
return sessionExpired();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String email,  String password)?  loginSubmitted,TResult? Function()?  googleSignInRequested,TResult? Function( String credential,  String fullName,  String nickname,  String dateOfBirth,  String country)?  googleRegisterSubmitted,TResult? Function()?  googleRegistrationNavigated,TResult? Function()?  logoutRequested,TResult? Function()?  sessionExpired,}) {final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started();case AuthLoginSubmitted() when loginSubmitted != null:
return loginSubmitted(_that.email,_that.password);case AuthGoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested();case AuthGoogleRegisterSubmitted() when googleRegisterSubmitted != null:
return googleRegisterSubmitted(_that.credential,_that.fullName,_that.nickname,_that.dateOfBirth,_that.country);case AuthGoogleRegistrationNavigated() when googleRegistrationNavigated != null:
return googleRegistrationNavigated();case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested();case AuthSessionExpired() when sessionExpired != null:
return sessionExpired();case _:
  return null;

}
}

}

/// @nodoc


class AuthStarted implements AuthEvent {
  const AuthStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.started()';
}


}




/// @nodoc


class AuthLoginSubmitted implements AuthEvent {
  const AuthLoginSubmitted({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthLoginSubmittedCopyWith<AuthLoginSubmitted> get copyWith => _$AuthLoginSubmittedCopyWithImpl<AuthLoginSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLoginSubmitted&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.loginSubmitted(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $AuthLoginSubmittedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthLoginSubmittedCopyWith(AuthLoginSubmitted value, $Res Function(AuthLoginSubmitted) _then) = _$AuthLoginSubmittedCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$AuthLoginSubmittedCopyWithImpl<$Res>
    implements $AuthLoginSubmittedCopyWith<$Res> {
  _$AuthLoginSubmittedCopyWithImpl(this._self, this._then);

  final AuthLoginSubmitted _self;
  final $Res Function(AuthLoginSubmitted) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(AuthLoginSubmitted(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthGoogleSignInRequested implements AuthEvent {
  const AuthGoogleSignInRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthGoogleSignInRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.googleSignInRequested()';
}


}




/// @nodoc


class AuthGoogleRegisterSubmitted implements AuthEvent {
  const AuthGoogleRegisterSubmitted({required this.credential, required this.fullName, required this.nickname, required this.dateOfBirth, required this.country});
  

 final  String credential;
 final  String fullName;
 final  String nickname;
 final  String dateOfBirth;
 final  String country;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthGoogleRegisterSubmittedCopyWith<AuthGoogleRegisterSubmitted> get copyWith => _$AuthGoogleRegisterSubmittedCopyWithImpl<AuthGoogleRegisterSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthGoogleRegisterSubmitted&&(identical(other.credential, credential) || other.credential == credential)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.country, country) || other.country == country));
}


@override
int get hashCode => Object.hash(runtimeType,credential,fullName,nickname,dateOfBirth,country);

@override
String toString() {
  return 'AuthEvent.googleRegisterSubmitted(credential: $credential, fullName: $fullName, nickname: $nickname, dateOfBirth: $dateOfBirth, country: $country)';
}


}

/// @nodoc
abstract mixin class $AuthGoogleRegisterSubmittedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthGoogleRegisterSubmittedCopyWith(AuthGoogleRegisterSubmitted value, $Res Function(AuthGoogleRegisterSubmitted) _then) = _$AuthGoogleRegisterSubmittedCopyWithImpl;
@useResult
$Res call({
 String credential, String fullName, String nickname, String dateOfBirth, String country
});




}
/// @nodoc
class _$AuthGoogleRegisterSubmittedCopyWithImpl<$Res>
    implements $AuthGoogleRegisterSubmittedCopyWith<$Res> {
  _$AuthGoogleRegisterSubmittedCopyWithImpl(this._self, this._then);

  final AuthGoogleRegisterSubmitted _self;
  final $Res Function(AuthGoogleRegisterSubmitted) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? credential = null,Object? fullName = null,Object? nickname = null,Object? dateOfBirth = null,Object? country = null,}) {
  return _then(AuthGoogleRegisterSubmitted(
credential: null == credential ? _self.credential : credential // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthGoogleRegistrationNavigated implements AuthEvent {
  const AuthGoogleRegistrationNavigated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthGoogleRegistrationNavigated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.googleRegistrationNavigated()';
}


}




/// @nodoc


class AuthLogoutRequested implements AuthEvent {
  const AuthLogoutRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLogoutRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logoutRequested()';
}


}




/// @nodoc


class AuthSessionExpired implements AuthEvent {
  const AuthSessionExpired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSessionExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.sessionExpired()';
}


}




// dart format on
