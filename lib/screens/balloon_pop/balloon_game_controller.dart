import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/game_config.dart';
import '../../core/constants/game_constants.dart';
import '../../core/utils/number_generator.dart';
import 'spatial_grid.dart';

/// Represents a single balloon in the game
class Balloon {
  final String id;
  final int number;
  final double left; // Position from left (0.0 to 1.0)
  final double bottom; // Position from bottom (0.0 to 1.0)
  final bool isPopped; // Whether this balloon has been popped

  Balloon({
    required this.id,
    required this.number,
    required this.left,
    required this.bottom,
    this.isPopped = false,
  });

  Balloon copyWith({double? bottom, bool? isPopped}) {
    return Balloon(
      id: id,
      number: number,
      left: left,
      bottom: bottom ?? this.bottom,
      isPopped: isPopped ?? this.isPopped,
    );
  }
}

/// Game state for Balloon Pop
class BalloonGameState {
  final int score;
  final int targetNumber;
  final int timeRemaining;
  final List<Balloon> balloons;
  final bool isPlaying;

  const BalloonGameState({
    this.score = 0,
    this.targetNumber = 1,
    this.timeRemaining = 60,
    this.balloons = const [],
    this.isPlaying = false,
  });

  BalloonGameState copyWith({
    int? score,
    int? targetNumber,
    int? timeRemaining,
    List<Balloon>? balloons,
    bool? isPlaying,
  }) {
    return BalloonGameState(
      score: score ?? this.score,
      targetNumber: targetNumber ?? this.targetNumber,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      balloons: balloons ?? this.balloons,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

/// Controller for Balloon Pop game logic
class BalloonGameController extends StateNotifier<BalloonGameState> {
  final BalloonPopConfig config;
  Timer? _gameTimer;
  Timer? _spawnTimer;
  Timer? _balloonUpdateTimer;
  final Random _random = Random();
  final SpatialGrid _spatialGrid = SpatialGrid();
  
  // Constants for collision detection and spawn management
  static const double _minSeparationDistance = 0.15; // 15% of screen
  static const int _maxRetryAttempts = 5;
  static const double _maxBalloonDensity = 15.0; // Maximum balloons for density calculation

  BalloonGameController(this.config) : super(const BalloonGameState());

  /// Start the game
  void startGame() {
    // Clear spatial grid
    _spatialGrid.clear();
    
    state = BalloonGameState(
      score: 0,
      targetNumber: NumberGenerator.generateNumber(config.startRange, config.endRange),
      timeRemaining: config.timerDuration,
      balloons: [],
      isPlaying: true,
    );

    // Start game timer (countdown)
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.timeRemaining > 0) {
        state = state.copyWith(timeRemaining: state.timeRemaining - 1);
      } else {
        endGame();
      }
    });

    // Start spawning balloons
    final spawnInterval = _getSpawnInterval();
    _spawnTimer = Timer.periodic(Duration(milliseconds: spawnInterval), (_) {
      _spawnBalloon();
    });

    // Update balloon positions
    _balloonUpdateTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      _updateBalloons();
    });
  }

  int _getSpawnInterval() {
    switch (config.spawnRate) {
      case GameConstants.spawnSlow:
        return GameConstants.spawnSlowInterval;
      case GameConstants.spawnFast:
        return GameConstants.spawnFastInterval;
      default:
        return GameConstants.spawnMediumInterval;
    }
  }

  /// Spawn multiple balloons with dynamic count based on screen density
  /// Uses collision detection to prevent overlapping
  void _spawnBalloon() {
    // Calculate current screen density
    final currentDensity = state.balloons.length / _maxBalloonDensity;
    
    // Determine spawn count based on density
    int spawnCount;
    if (currentDensity > 0.7) {
      // High density: spawn fewer balloons (1-2)
      spawnCount = 1 + _random.nextInt(2);
    } else if (currentDensity < 0.3) {
      // Low density: spawn more balloons (4-6)
      spawnCount = 4 + _random.nextInt(3);
    } else {
      // Medium density: spawn moderate amount (2-4)
      spawnCount = 2 + _random.nextInt(3);
    }
    
    final newBalloons = <Balloon>[];
    
    for (int i = 0; i < spawnCount; i++) {
      // 35% chance (slightly more than 1 in 4) of spawning target number
      final shouldSpawnTarget = _random.nextDouble() < 0.35;
      final number = shouldSpawnTarget 
          ? state.targetNumber
          : NumberGenerator.generateNumber(config.startRange, config.endRange);
      
      // Try to find a valid position without collision
      double? leftPosition;
      double? bottomPosition;
      
      for (int attempt = 0; attempt < _maxRetryAttempts; attempt++) {
        final testLeft = 0.1 + (_random.nextDouble() * 0.75); // Keep away from edges
        final testBottom = -0.05 - (i * 0.05); // Slight vertical stagger
        
        // Check for collision with existing balloons
        if (!_spatialGrid.hasCollision(testLeft, testBottom, _minSeparationDistance)) {
          leftPosition = testLeft;
          bottomPosition = testBottom;
          break;
        }
      }
      
      // Skip this balloon if no valid position found after max attempts
      if (leftPosition == null || bottomPosition == null) {
        continue;
      }
      
      final balloon = Balloon(
        id: '${DateTime.now().millisecondsSinceEpoch}_$i',
        number: number,
        left: leftPosition,
        bottom: bottomPosition,
      );
      
      // Add to spatial grid
      _spatialGrid.addBalloon(balloon.id, balloon.left, balloon.bottom);
      newBalloons.add(balloon);
    }

    if (newBalloons.isNotEmpty) {
      state = state.copyWith(
        balloons: [...state.balloons, ...newBalloons],
      );
    }
  }

  /// Update balloon positions (move them up)
  void _updateBalloons() {
    final balloonsToRemove = <String>[];
    
    final updatedBalloons = state.balloons
        .where((balloon) => !balloon.isPopped) // Keep popped balloons temporarily
        .map((balloon) {
          final newBottom = balloon.bottom + 0.01; // Rise speed
          final updatedBalloon = balloon.copyWith(bottom: newBottom);
          
          // Update position in spatial grid
          _spatialGrid.updateBalloon(updatedBalloon.id, updatedBalloon.left, updatedBalloon.bottom);
          
          return updatedBalloon;
        })
        .where((balloon) {
          // Remove off-screen balloons (changed threshold from 1.2 to 1.0)
          if (balloon.bottom >= 1.0) {
            balloonsToRemove.add(balloon.id);
            return false;
          }
          return true;
        })
        .toList();
    
    // Remove off-screen balloons from spatial grid
    for (final balloonId in balloonsToRemove) {
      _spatialGrid.removeBalloon(balloonId);
    }
    
    // Add back popped balloons (they don't move)
    final poppedBalloons = state.balloons.where((b) => b.isPopped).toList();

    state = state.copyWith(balloons: [...updatedBalloons, ...poppedBalloons]);
  }

  /// Pop a balloon
  void popBalloon(String balloonId, int number) {
    // Check if it's the correct number
    if (number == state.targetNumber) {
      // Correct! Add points
      final points = GameConstants.getPointsForNumber(number);
      final newScore = state.score + points;
      
      // Remove from spatial grid immediately
      _spatialGrid.removeBalloon(balloonId);
      
      // Mark balloon as popped (don't remove immediately)
      final updatedBalloons = state.balloons.map((b) {
        if (b.id == balloonId) {
          return b.copyWith(isPopped: true);
        }
        return b;
      }).toList();
      
      // Generate new target number
      final newTarget = NumberGenerator.generateNumber(config.startRange, config.endRange);
      
      state = state.copyWith(
        score: newScore,
        balloons: updatedBalloons,
        targetNumber: newTarget,
      );
      
      // Remove popped balloon after animation completes
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          state = state.copyWith(
            balloons: state.balloons.where((b) => b.id != balloonId).toList(),
          );
        }
      });
    }
    // If incorrect, just do wobble animation (handled by widget)
  }

  /// End the game
  void endGame() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _balloonUpdateTimer?.cancel();
    state = state.copyWith(isPlaying: false);
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _balloonUpdateTimer?.cancel();
    super.dispose();
  }
}



