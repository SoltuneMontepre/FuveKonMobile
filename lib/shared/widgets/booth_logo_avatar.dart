import 'package:flutter/material.dart';

/// Rounded-square placeholder avatar for a dealer booth.
///
/// Shown in place of a real logo image, which the app does not yet collect.
class BoothLogoAvatar extends StatelessWidget {
  const BoothLogoAvatar({
    super.key,
    required this.background,
    required this.foreground,
    this.size = 72,
  });

  final Color background;
  final Color foreground;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        Icons.storefront_rounded,
        color: foreground,
        size: size * 0.42,
      ),
    );
  }
}
