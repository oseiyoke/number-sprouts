import 'package:flutter/material.dart';

/// Custom painter to draw a realistic balloon shape
/// with gradient shading and glossy highlight effects
class BalloonPainter extends CustomPainter {
  final Color color;
  final bool isPopping;

  BalloonPainter({
    required this.color,
    this.isPopping = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isPopping) return; // Don't draw if balloon is popping

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Create balloon body path (teardrop shape)
    final path = Path();
    final centerX = size.width / 2;
    final bodyHeight = size.height * 0.75;
    final bodyWidth = size.width * 0.85;

    // Start from bottom center (where string attaches)
    path.moveTo(centerX, bodyHeight);

    // Create teardrop shape using quadratic bezier curves
    // Left side of balloon
    path.quadraticBezierTo(
      centerX - bodyWidth / 2,
      bodyHeight * 0.85,
      centerX - bodyWidth / 2,
      bodyHeight / 2,
    );

    // Top left curve
    path.quadraticBezierTo(
      centerX - bodyWidth / 2,
      bodyHeight * 0.15,
      centerX,
      0,
    );

    // Top right curve
    path.quadraticBezierTo(
      centerX + bodyWidth / 2,
      bodyHeight * 0.15,
      centerX + bodyWidth / 2,
      bodyHeight / 2,
    );

    // Right side of balloon
    path.quadraticBezierTo(
      centerX + bodyWidth / 2,
      bodyHeight * 0.85,
      centerX,
      bodyHeight,
    );

    path.close();

    // Draw gradient for 3D effect
    final rect = Rect.fromLTWH(0, 0, size.width, bodyHeight);
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withOpacity(0.95),
        color,
        color.withOpacity(0.7),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(rect);

    canvas.drawPath(path, paint);

    // Add shine/highlight for glossy effect
    final shinePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 0.6,
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(rect);

    final shinePath = Path();
    final shineX = centerX - bodyWidth / 6;
    final shineY = bodyHeight * 0.2;
    final shineWidth = bodyWidth * 0.35;
    final shineHeight = bodyHeight * 0.3;

    shinePath.addOval(
      Rect.fromLTWH(shineX, shineY, shineWidth, shineHeight),
    );

    canvas.drawPath(shinePath, shinePaint);

    // Draw balloon knot at bottom
    final knotPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final knotPath = Path();
    final knotY = bodyHeight;
    final knotWidth = size.width * 0.15;
    final knotHeight = size.height * 0.08;

    knotPath.moveTo(centerX - knotWidth / 2, knotY);
    knotPath.quadraticBezierTo(
      centerX,
      knotY + knotHeight / 2,
      centerX + knotWidth / 2,
      knotY,
    );
    knotPath.quadraticBezierTo(
      centerX,
      knotY + knotHeight * 0.8,
      centerX - knotWidth / 2,
      knotY,
    );

    canvas.drawPath(knotPath, knotPaint);

    // Draw string
    final stringPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final stringPath = Path();
    final stringStartY = knotY + knotHeight * 0.5;
    final stringEndY = size.height;

    stringPath.moveTo(centerX, stringStartY);
    
    // Slightly curved string
    stringPath.quadraticBezierTo(
      centerX + 3,
      (stringStartY + stringEndY) / 2,
      centerX,
      stringEndY,
    );

    canvas.drawPath(stringPath, stringPaint);
  }

  @override
  bool shouldRepaint(covariant BalloonPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isPopping != isPopping;
  }
}

