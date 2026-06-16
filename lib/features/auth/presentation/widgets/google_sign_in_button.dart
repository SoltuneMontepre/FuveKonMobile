import 'package:flutter/material.dart';

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
    final fg = lightStyle ? const Color(0xFF0A2E1F) : null;
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
    final r = size.width / 2;
    final center = Offset(r, r);

    const blue = Color(0xFF4285F4);
    const red = Color(0xFFEA4335);
    const yellow = Color(0xFFFBBC05);
    const green = Color(0xFF34A853);

    final stroke = r * 0.38;

    void arc(Color color, double start, double sweep) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r - stroke / 2),
        start,
        sweep,
        false,
        paint,
      );
    }

    arc(blue, -0.45, 1.4);
    arc(green, 0.95, 1.0);
    arc(yellow, 1.95, 1.0);
    arc(red, 2.95, 1.0);

    canvas.drawRect(
      Rect.fromLTWH(r - stroke * 0.15, r - stroke * 0.35, r, stroke * 0.7),
      Paint()..color = blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
