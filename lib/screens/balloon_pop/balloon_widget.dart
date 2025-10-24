import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';
import 'balloon_game_controller.dart';
import 'balloon_painter.dart';
import 'balloon_render_box.dart';

/// A single balloon widget that floats upward
class BalloonWidget extends StatefulWidget {
  final Balloon balloon;
  final VoidCallback onTap;
  final bool shouldWobble;
  final bool isPopped;

  const BalloonWidget({
    super.key,
    required this.balloon,
    required this.onTap,
    this.shouldWobble = false,
    this.isPopped = false,
  });

  @override
  State<BalloonWidget> createState() => _BalloonWidgetState();
}

class _BalloonWidgetState extends State<BalloonWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.isPopped) {
      // Show confetti pop animation
      return SizedBox(
        width: 140,
        height: 160,
        child: _buildConfettiExplosion(),
      );
    }

    // Colors for balloons
    final colors = [
      AppTheme.skyBlue,
      AppTheme.primaryGreen,
      AppTheme.sunnyOrange,
      Colors.purple,
      Colors.pink,
      Colors.red,
      Colors.teal,
      Colors.indigo,
    ];
    final color = colors[widget.balloon.number % colors.length];

    Widget balloonWidget = BalloonHitTestWidget(
      onTap: widget.onTap,
      child: SizedBox(
        width: 140,
        height: 180,
        child: Stack(
          children: [
            // Custom painted balloon
            CustomPaint(
              size: const Size(140, 160),
              painter: BalloonPainter(
                color: color,
                isPopping: widget.isPopped,
              ),
            ),
            // Number on balloon
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.balloon.number.toString(),
                  style: AppTheme.numberStyle(
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Add wobble animation if incorrect tap
    if (widget.shouldWobble) {
      balloonWidget = balloonWidget
          .animate()
          .shake(duration: 400.ms, hz: 5);
    }

    return balloonWidget;
  }

  /// Build confetti explosion animation for correct pops
  Widget _buildConfettiExplosion() {
    return Stack(
      children: List.generate(12, (index) {
        final angle = (index * 30.0) * (math.pi / 180);
        final distance = 56.0 + (index % 3) * 21.0; // Scaled by 1.4x (140/100)
        
        return Positioned(
          left: 70, // Scaled by 1.4x (70 = 50 * 1.4)
          top: 70,  // Scaled by 1.4x
          child: Transform.translate(
            offset: Offset(
              math.cos(angle) * distance,
              math.sin(angle) * distance,
            ),
            child: Container(
              width: 11,  // Scaled by 1.4x (11 ≈ 8 * 1.4)
              height: 11,
              decoration: BoxDecoration(
                color: _getConfettiColor(index),
                shape: index % 2 == 0 ? BoxShape.circle : BoxShape.rectangle,
              ),
            ),
          ),
        )
            .animate()
            .moveY(
              duration: 500.ms,
              begin: 0,
              end: math.sin(angle) * distance * 2,
            )
            .moveX(
              duration: 500.ms,
              begin: 0,
              end: math.cos(angle) * distance * 2,
            )
            .fadeOut(duration: 500.ms, delay: 100.ms)
            .scale(duration: 300.ms, begin: const Offset(1, 1), end: const Offset(0.3, 0.3));
      }),
    );
  }

  Color _getConfettiColor(int index) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}



