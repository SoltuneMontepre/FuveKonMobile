import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';

/// Dark scaffold for admin/staff bottom-nav tab pages (no app bar).
class StaffTabScaffold extends StatelessWidget {
  const StaffTabScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FuvekonColors.darkBg,
      body: SafeArea(child: child),
    );
  }
}
