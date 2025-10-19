import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../core/theme/app_theme.dart';

/// Results screen shown after completing a game
/// Displays score, stars earned, and options to replay or go home
class GameResultsScreen extends StatefulWidget {
  final String gameName;
  final int score;
  final int stars;
  final VoidCallback onReplay;
  final VoidCallback onHome;

  const GameResultsScreen({
    super.key,
    required this.gameName,
    required this.score,
    required this.stars,
    required this.onReplay,
    required this.onHome,
  });

  @override
  State<GameResultsScreen> createState() => _GameResultsScreenState();
}

class _GameResultsScreenState extends State<GameResultsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'Great Job!',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 40),

                    // Stars display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            index < widget.stars ? Icons.star : Icons.star_border,
                            size: 80,
                            color: AppTheme.sunnyOrange,
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 40),

                    // Score display
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Score',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.score.toString(),
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: widget.onHome,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.textLight,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(140, 60),
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.home, size: 28),
                              SizedBox(height: 4),
                              Text('Home'),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 20),
                        
                        ElevatedButton(
                          onPressed: widget.onReplay,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(140, 60),
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.replay, size: 28),
                              SizedBox(height: 4),
                              Text('Play Again'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppTheme.primaryGreen,
                AppTheme.skyBlue,
                AppTheme.sunnyOrange,
                AppTheme.softYellow,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

