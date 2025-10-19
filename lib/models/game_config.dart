import '../core/constants/game_constants.dart';

/// Configuration for Balloon Pop game
/// This stores all the settings a player can customize
class BalloonPopConfig {
  final int timerDuration;
  final int startRange;
  final int endRange;
  final String spawnRate;

  const BalloonPopConfig({
    this.timerDuration = GameConstants.defaultTimer,
    this.startRange = 1,
    this.endRange = 10,
    this.spawnRate = GameConstants.spawnMedium,
  });

  /// Create a copy with some values changed
  BalloonPopConfig copyWith({
    int? timerDuration,
    int? startRange,
    int? endRange,
    String? spawnRate,
  }) {
    return BalloonPopConfig(
      timerDuration: timerDuration ?? this.timerDuration,
      startRange: startRange ?? this.startRange,
      endRange: endRange ?? this.endRange,
      spawnRate: spawnRate ?? this.spawnRate,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'timerDuration': timerDuration,
      'startRange': startRange,
      'endRange': endRange,
      'spawnRate': spawnRate,
    };
  }

  /// Create from JSON
  factory BalloonPopConfig.fromJson(Map<String, dynamic> json) {
    return BalloonPopConfig(
      timerDuration: json['timerDuration'] ?? GameConstants.defaultTimer,
      startRange: json['startRange'] ?? 1,
      endRange: json['endRange'] ?? 10,
      spawnRate: json['spawnRate'] ?? GameConstants.spawnMedium,
    );
  }
}

/// Configuration for Number Train game
class NumberTrainConfig {
  final int numberOfCars;
  final int startRange;
  final int endRange;

  const NumberTrainConfig({
    this.numberOfCars = GameConstants.defaultTrainCars,
    this.startRange = 1,
    this.endRange = 10,
  });

  NumberTrainConfig copyWith({
    int? numberOfCars,
    int? startRange,
    int? endRange,
  }) {
    return NumberTrainConfig(
      numberOfCars: numberOfCars ?? this.numberOfCars,
      startRange: startRange ?? this.startRange,
      endRange: endRange ?? this.endRange,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numberOfCars': numberOfCars,
      'startRange': startRange,
      'endRange': endRange,
    };
  }

  factory NumberTrainConfig.fromJson(Map<String, dynamic> json) {
    return NumberTrainConfig(
      numberOfCars: json['numberOfCars'] ?? GameConstants.defaultTrainCars,
      startRange: json['startRange'] ?? 1,
      endRange: json['endRange'] ?? 10,
    );
  }
}
