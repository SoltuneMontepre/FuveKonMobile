import 'package:flutter/material.dart';

/// Layout wrapper for authenticated account routes.
///
/// Unverified users are restricted to profile and change-password only
/// (enforced in [AppRouter] redirect).
class AccountShell extends StatelessWidget {
  const AccountShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child);
  }
}
