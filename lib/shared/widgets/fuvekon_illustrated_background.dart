import 'package:flutter/material.dart';

/// Full-screen illustrated background used on guest/public pages.
class FuvekonIllustratedBackground extends StatelessWidget {
  const FuvekonIllustratedBackground({super.key});

  static const asset = 'assets/images/guest-landing-background.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

/// Semi-transparent panel for interactive content over illustrated backgrounds.
class FuvekonIllustratedContentPanel extends StatelessWidget {
  const FuvekonIllustratedContentPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 24, 20, 24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Stacks [FuvekonIllustratedBackground] behind [child] for full-screen coverage.
class FuvekonIllustratedPageStack extends StatelessWidget {
  const FuvekonIllustratedPageStack({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(child: FuvekonIllustratedBackground()),
        child,
      ],
    );
  }
}
