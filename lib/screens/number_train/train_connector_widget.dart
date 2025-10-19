import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Visual connector/coupling between train cars
/// Only shown when adjacent cars are correctly sequenced
class TrainConnectorWidget extends StatelessWidget {
  final bool isVisible;
  final bool animate;

  const TrainConnectorWidget({
    super.key,
    required this.isVisible,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox(width: 20);
    }

    Widget connector = SizedBox(
      width: 20,
      height: 100,
      child: CustomPaint(
        painter: _ConnectorPainter(),
      ),
    );

    // Animate the connector appearing
    if (animate) {
      connector = connector
          .animate()
          .scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1.0, 1.0),
            duration: 300.ms,
            curve: Curves.elasticOut,
          )
          .fade(duration: 200.ms);
    }

    return connector;
  }
}

/// Custom painter for the chain/coupling connector
class _ConnectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;

    // Draw chain links
    const linkWidth = 8.0;
    const linkHeight = 6.0;
    const numLinks = 2;

    for (int i = 0; i < numLinks; i++) {
      final x = (size.width / (numLinks + 1)) * (i + 1);
      
      // Draw oval link
      final rect = Rect.fromCenter(
        center: Offset(x, centerY),
        width: linkWidth,
        height: linkHeight,
      );
      
      canvas.drawOval(rect, fillPaint);
      canvas.drawOval(rect, paint);
    }

    // Draw connecting line
    canvas.drawLine(
      Offset(2, centerY),
      Offset(size.width - 2, centerY),
      paint..strokeWidth = 2,
    );

    // Draw coupling hooks on both ends
    final hookPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    // Left hook
    canvas.drawCircle(Offset(3, centerY), 4, hookPaint);
    canvas.drawCircle(Offset(3, centerY), 4, paint..strokeWidth = 2);

    // Right hook
    canvas.drawCircle(Offset(size.width - 3, centerY), 4, hookPaint);
    canvas.drawCircle(Offset(size.width - 3, centerY), 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

