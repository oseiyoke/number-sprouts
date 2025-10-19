import 'package:flutter/material.dart';

/// A widget that displays the current score with animations
/// Shows total score, combo counter, and round number at top right
class TrainScoreDisplay extends StatefulWidget {
  final int score;
  final int combo;
  final int currentRound;
  final int totalRounds;

  const TrainScoreDisplay({
    super.key,
    required this.score,
    required this.combo,
    required this.currentRound,
    required this.totalRounds,
  });

  @override
  State<TrainScoreDisplay> createState() => _TrainScoreDisplayState();
}

class _TrainScoreDisplayState extends State<TrainScoreDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  int _displayedScore = 0;

  @override
  void initState() {
    super.initState();
    _displayedScore = widget.score;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_animationController);

    _colorAnimation = ColorTween(
      begin: Colors.blue[700],
      end: Colors.green[400],
    ).animate(_animationController);
  }

  @override
  void didUpdateWidget(TrainScoreDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger animation when score changes
    if (widget.score != oldWidget.score) {
      _animateScoreChange();
      _animationController.forward(from: 0);
    }
  }

  void _animateScoreChange() {
    final start = _displayedScore;
    final end = widget.score;
    final duration = const Duration(milliseconds: 300);
    final startTime = DateTime.now();

    void updateScore() {
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      final progress = (elapsed / duration.inMilliseconds).clamp(0.0, 1.0);

      if (mounted) {
        setState(() {
          _displayedScore = (start + (end - start) * progress).round();
        });

        if (progress < 1.0) {
          Future.delayed(const Duration(milliseconds: 16), updateScore);
        }
      }
    }

    updateScore();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Round indicator
                Text(
                  'Round ${widget.currentRound}/${widget.totalRounds}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // Score
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: _animationController.isAnimating
                          ? _colorAnimation.value
                          : Colors.blue[700],
                      size: 24,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_displayedScore',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _animationController.isAnimating
                            ? _colorAnimation.value
                            : Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                // Combo indicator
                if (widget.combo > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 14,
                          color: Colors.orange[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '×${widget.combo + 1} Combo',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

