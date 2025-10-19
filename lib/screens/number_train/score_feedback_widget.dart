import 'package:flutter/material.dart';

/// Animated floating text that shows score changes at placement location
class ScoreFeedbackWidget extends StatefulWidget {
  final int points;
  final bool isPositive;
  final Offset position;
  final VoidCallback onComplete;

  const ScoreFeedbackWidget({
    super.key,
    required this.points,
    required this.isPositive,
    required this.position,
    required this.onComplete,
  });

  @override
  State<ScoreFeedbackWidget> createState() => _ScoreFeedbackWidgetState();
}

class _ScoreFeedbackWidgetState extends State<ScoreFeedbackWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    if (widget.isPositive) {
      // Positive score: float up and fade
      _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
        ),
      );

      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, -80),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      );

      _scaleAnimation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.5, end: 1.2),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.2, end: 1.0),
          weight: 70,
        ),
      ]).animate(_controller);
    } else {
      // Negative score: shake and fade
      _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
        ),
      );

      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, 20),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      );

      _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      );
    }

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _slideAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: widget.isPositive
                    ? _buildPositiveFeedback()
                    : _buildNegativeFeedback(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPositiveFeedback() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[400],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        '+${widget.points}',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNegativeFeedback() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        '-${widget.points.abs()}',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Overlay manager for score feedback animations
class ScoreFeedbackOverlay {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required int points,
    required bool isPositive,
    required Offset position,
  }) {
    // Remove any existing feedback
    remove();

    final overlay = Overlay.of(context);
    _currentEntry = OverlayEntry(
      builder: (context) => ScoreFeedbackWidget(
        points: points,
        isPositive: isPositive,
        position: position,
        onComplete: remove,
      ),
    );

    overlay.insert(_currentEntry!);
  }

  static void remove() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

