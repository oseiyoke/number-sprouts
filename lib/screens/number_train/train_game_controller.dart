import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/game_config.dart';
import '../../core/utils/number_generator.dart';

/// Represents a train car with a number
class TrainCar {
  final int number;
  final int? position; // null if not placed yet

  TrainCar({
    required this.number,
    this.position,
  });

  TrainCar copyWith({int? position}) {
    return TrainCar(
      number: number,
      position: position,
    );
  }
}

/// Game state for Number Train
class TrainGameState {
  final List<TrainCar> cars;
  final List<int> sortedNumbers; // Correct order
  final bool isComplete;
  final int errors;
  final int completionTime; // In seconds
  final int score; // Total score across all rounds
  final int roundScore; // Current round score
  final int combo; // Current combo count
  final int roundErrors; // Errors in current round
  final int totalErrors; // Errors across all rounds
  final DateTime? roundStartTime; // Track round start for time bonus

  const TrainGameState({
    this.cars = const [],
    this.sortedNumbers = const [],
    this.isComplete = false,
    this.errors = 0,
    this.completionTime = 0,
    this.score = 0,
    this.roundScore = 0,
    this.combo = 0,
    this.roundErrors = 0,
    this.totalErrors = 0,
    this.roundStartTime,
  });

  TrainGameState copyWith({
    List<TrainCar>? cars,
    List<int>? sortedNumbers,
    bool? isComplete,
    int? errors,
    int? completionTime,
    int? score,
    int? roundScore,
    int? combo,
    int? roundErrors,
    int? totalErrors,
    DateTime? roundStartTime,
  }) {
    return TrainGameState(
      cars: cars ?? this.cars,
      sortedNumbers: sortedNumbers ?? this.sortedNumbers,
      isComplete: isComplete ?? this.isComplete,
      errors: errors ?? this.errors,
      completionTime: completionTime ?? this.completionTime,
      score: score ?? this.score,
      roundScore: roundScore ?? this.roundScore,
      combo: combo ?? this.combo,
      roundErrors: roundErrors ?? this.roundErrors,
      totalErrors: totalErrors ?? this.totalErrors,
      roundStartTime: roundStartTime ?? this.roundStartTime,
    );
  }
}

/// Controller for Number Train game logic
class TrainGameController extends StateNotifier<TrainGameState> {
  final NumberTrainConfig config;
  DateTime? _startTime;

  TrainGameController(this.config) : super(const TrainGameState());

  /// Start a new round
  void startNewRound() {
    // Generate sorted sequence of numbers
    final numbers = NumberGenerator.generateSequence(
      config.startRange,
      config.endRange,
      config.numberOfCars,
    );

    // Create cars with shuffled order (no positions assigned yet)
    final shuffled = List<int>.from(numbers)..shuffle();
    final cars = shuffled.map((n) => TrainCar(number: n)).toList();

    state = state.copyWith(
      cars: cars,
      sortedNumbers: numbers,
      isComplete: false,
      errors: 0,
      completionTime: 0,
      roundScore: 0,
      combo: 0,
      roundErrors: 0,
      roundStartTime: DateTime.now(),
    );

    _startTime = DateTime.now();
  }

  /// Place a car at a position
  void placeCar(int carNumber, int position) {
    final updatedCars = state.cars.map((car) {
      if (car.number == carNumber) {
        return car.copyWith(position: position);
      }
      // Clear this position if another car was there
      else if (car.position == position) {
        return TrainCar(number: car.number);
      }
      return car;
    }).toList();

    state = state.copyWith(cars: updatedCars);

    // Check if complete
    _checkCompletion();
  }

  /// Check if the ordering is correct
  bool checkOrder() {
    // Get placed cars sorted by position
    final placedCars = state.cars
        .where((car) => car.position != null)
        .toList()
      ..sort((a, b) => a.position!.compareTo(b.position!));

    // Check if all cars are placed
    if (placedCars.length != state.cars.length) {
      return false;
    }

    // Check if order matches sorted numbers
    for (int i = 0; i < placedCars.length; i++) {
      if (placedCars[i].number != state.sortedNumbers[i]) {
        return false;
      }
    }

    return true;
  }

  /// Check if adjacent cars at positions are correctly sequenced
  /// Returns true if both positions have cars and they're in ascending order
  bool areAdjacentCarsCorrect(int position) {
    final currentCar = getCarAtPosition(position);
    final nextCar = getCarAtPosition(position + 1);
    
    // Both positions must have cars
    if (currentCar == null || nextCar == null) {
      return false;
    }
    
    // Current car's number must be less than next car's number
    return currentCar.number < nextCar.number;
  }

  /// Get the car at a specific position
  TrainCar? getCarAtPosition(int position) {
    try {
      return state.cars.firstWhere((car) => car.position == position);
    } catch (e) {
      return null;
    }
  }

  /// Increment error count
  void incrementErrors() {
    state = state.copyWith(errors: state.errors + 1);
  }

  /// Calculate score for a correct placement based on combo
  int calculatePlacementScore() {
    const basePoints = 50;
    final multiplier = 1.0 + (state.combo * 0.5);
    return (basePoints * multiplier).round();
  }

  /// Record a correct placement and add score
  void recordCorrectPlacement() {
    final points = calculatePlacementScore();
    state = state.copyWith(
      roundScore: state.roundScore + points,
      score: state.score + points,
      combo: state.combo + 1,
    );
  }

  /// Record an error and deduct points
  void recordError() {
    const penalty = 20;
    state = state.copyWith(
      roundErrors: state.roundErrors + 1,
      totalErrors: state.totalErrors + 1,
      roundScore: state.roundScore - penalty,
      score: state.score - penalty,
      combo: 0, // Reset combo on error
    );
  }

  /// Calculate round completion bonuses
  Map<String, int> calculateRoundBonus() {
    final roundTime = DateTime.now().difference(state.roundStartTime!).inSeconds;
    final timeBonus = (300 - roundTime * 10).clamp(0, 300);
    final perfectBonus = state.roundErrors == 0 ? 200 : 0;
    
    return {
      'timeBonus': timeBonus,
      'perfectBonus': perfectBonus,
      'totalBonus': timeBonus + perfectBonus,
    };
  }

  /// Apply round bonuses to score
  void applyRoundBonus() {
    final bonuses = calculateRoundBonus();
    final totalBonus = bonuses['totalBonus']!;
    state = state.copyWith(
      score: state.score + totalBonus,
    );
  }

  /// Reset combo counter
  void resetCombo() {
    state = state.copyWith(combo: 0);
  }

  /// Increment combo counter
  void incrementCombo() {
    state = state.copyWith(combo: state.combo + 1);
  }

  /// Check if all cars are correctly placed
  void _checkCompletion() {
    if (checkOrder()) {
      final completionTime = DateTime.now().difference(_startTime!).inSeconds;
      
      // Apply round bonuses before marking complete
      applyRoundBonus();
      
      state = state.copyWith(
        isComplete: true,
        completionTime: completionTime,
      );
    }
  }
}

