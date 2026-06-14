import 'package:fuvekonmobile/core/router/routes.dart';

/// App access roles aligned with backend `UserRole` (`user_roles.go`).
enum UserRole {
  user,
  admin,
  dealer,
  staff;

  static UserRole? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    return switch (value.toLowerCase()) {
      'user' => UserRole.user,
      'admin' => UserRole.admin,
      'dealer' => UserRole.dealer,
      'staff' => UserRole.staff,
      _ => null,
    };
  }

  bool get isPrivileged => this == UserRole.admin || this == UserRole.staff;

  String get homeRoute => switch (this) {
        UserRole.admin => Routes.admin,
        UserRole.staff => Routes.admin,
        UserRole.user || UserRole.dealer => Routes.account,
      };
}
