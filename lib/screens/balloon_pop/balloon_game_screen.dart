import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/game_config.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/game_constants.dart';
import '../../providers/audio_provider.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/common/back_button_widget.dart';
import '../../widgets/common/game_results_screen.dart';
import 'balloon_game_controller.dart';
import 'balloon_widget.dart';

/// Main game screen for Balloon Pop
class BalloonGameScreen extends ConsumerStatefulWidget {
  final BalloonPopConfig config;

  const BalloonGameScreen({
    super.key,
    required this.config,
  });

  @override
  ConsumerState<BalloonGameScreen> createState() => _BalloonGameScreenState();
}

class _BalloonGameScreenState extends ConsumerState<BalloonGameScreen> {
  late final StateNotifierProvider<BalloonGameController, BalloonGameState> _gameProvider;
  String? _wobblingBalloonId;

  @override
  void initState() {
    super.initState();
    
    // Create a provider for this game instance
    _gameProvider = StateNotifierProvider<BalloonGameController, BalloonGameState>(
      (ref) => BalloonGameController(widget.config),
    );

    // Start the game after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_gameProvider.notifier).startGame();
      // Announce first target number
      ref.read(ttsServiceProvider).speakPopNumber(
        ref.read(_gameProvider).targetNumber,
      );
    });
  }

  void _handleBalloonTap(String balloonId, int number) {
    final gameState = ref.read(_gameProvider);
    final audioService = ref.read(audioServiceProvider);
    final ttsService = ref.read(ttsServiceProvider);

    if (number == gameState.targetNumber) {
      // Correct!
      audioService.playPop();
      ref.read(_gameProvider.notifier).popBalloon(balloonId, number);
      
      // Announce new target after a delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          final newTarget = ref.read(_gameProvider).targetNumber;
          ttsService.speakPopNumber(newTarget);
        }
      });
    } else {
      // Incorrect - wobble
      audioService.playIncorrect();
      setState(() {
        _wobblingBalloonId = balloonId;
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            _wobblingBalloonId = null;
          });
        }
      });
    }
  }

  void _onGameEnd() {
    final gameState = ref.read(_gameProvider);
    final stars = GameConstants.getBalloonStars(
      gameState.score,
      widget.config.timerDuration,
    );

    // Save progress
    ref.read(progressProvider.notifier).recordGameResult(
      'Balloon Pop',
      gameState.score,
      stars,
    );

    // Play celebration
    ref.read(audioServiceProvider).playCelebration();

    // Show results screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => GameResultsScreen(
          gameName: 'Balloon Pop',
          score: gameState.score,
          stars: stars,
          onReplay: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BalloonGameScreen(config: widget.config),
              ),
            );
          },
          onHome: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(_gameProvider);

    // Check if game ended
    if (!gameState.isPlaying && gameState.timeRemaining == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onGameEnd();
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Game area with balloons
            Positioned.fill(
              child: Stack(
                children: gameState.balloons.map((balloon) {
                  return Positioned(
                    left: MediaQuery.of(context).size.width * balloon.left,
                    bottom: MediaQuery.of(context).size.height * balloon.bottom,
                    child: BalloonWidget(
                      balloon: balloon,
                      onTap: () => _handleBalloonTap(balloon.id, balloon.number),
                      shouldWobble: _wobblingBalloonId == balloon.id,
                      isPopped: balloon.isPopped,
                    ),
                  );
                }).toList(),
              ),
            ),

            // Top UI
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Timer
                        Row(
                          children: [
                            const Icon(Icons.timer, size: 32),
                            const SizedBox(width: 8),
                            Text(
                              '${gameState.timeRemaining}s',
                              style: AppTheme.numberStyle(size: 32),
                            ),
                          ],
                        ),
                        // Score
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppTheme.sunnyOrange, size: 32),
                            const SizedBox(width: 8),
                            Text(
                              '${gameState.score}',
                              style: AppTheme.numberStyle(size: 32),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Back button
            const Positioned(
              bottom: 16,
              left: 0,
              child: BackButtonWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

