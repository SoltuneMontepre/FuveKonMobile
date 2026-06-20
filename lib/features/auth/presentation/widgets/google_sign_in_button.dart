import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/theme/app_colors.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    this.label = 'Sign in with Google',
    this.lightStyle = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;
  final bool lightStyle;

  @override
  Widget build(BuildContext context) {
    final bg = lightStyle ? Colors.white : null;
    final fg = lightStyle ? FuvekonColors.darkButtonText : null;
    final border = lightStyle
        ? BorderSide(color: Colors.black.withValues(alpha: 0.12))
        : null;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        side: border,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _GoogleLogo(size: 20),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final center = bounds.center;

    const blue = Color(0xFF4285F4);
    const red = Color(0xFFEA4335);
    const yellow = Color(0xFFFBBC05);
    const green = Color(0xFF34A853);

    final stroke = size.width / 4.5;
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    void arc(Color color, double start, double sweep) {
      canvas.drawArc(bounds, start, sweep, false, arcPaint..color = color);
    }

    // Official Google "G" segment layout (clockwise from top).
    arc(red, 3.5, 1.9);
    arc(yellow, 2.5, 1.0);
    arc(green, 0.9, 1.6);
    arc(blue, -0.18, 1.1);

    canvas.drawRect(
      Rect.fromLTRB(
        center.dx,
        center.dy - stroke / 2,
        bounds.centerRight.dx + stroke / 2 - size.width * 0.02,
        center.dy + stroke / 2,
      ),
      Paint()..color = blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
