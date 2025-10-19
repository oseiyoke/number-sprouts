/// Game configuration constants
/// These define the rules, options, and scoring for all games
class GameConstants {
  // Timer options for Balloon Pop (in seconds)
  static const List<int> timerOptions = [30, 60, 90, 120];
  static const int defaultTimer = 60;

  // Number ranges available across all games
  static const String range1to10 = '1-10';
  static const String range1to20 = '1-20';
  static const String range20to50 = '20-50';
  static const String range50to100 = '50-100';
  static const String range1to50 = '1-50';
  static const String range1to100 = '1-100';
  static const String rangeMixed = 'Mixed';

  static const List<String> balloonRanges = [
    range1to10,
    range1to20,
    range20to50,
    range50to100,
    rangeMixed,
  ];

  static const List<String> trainRanges = [
    range1to10,
    range1to20,
    range1to50,
    range1to100,
  ];

  // Balloon spawn rates
  static const String spawnSlow = 'Slow';
  static const String spawnMedium = 'Medium';
  static const String spawnFast = 'Fast';
  static const List<String> spawnRates = [spawnSlow, spawnMedium, spawnFast];

  // Spawn intervals in milliseconds
  static const int spawnSlowInterval = 2000;
  static const int spawnMediumInterval = 1200;
  static const int spawnFastInterval = 700;

  // Number of train cars options
  static const List<int> trainCarOptions = [3, 4, 5, 6, 7];
  static const int defaultTrainCars = 3;

  // Scoring for Balloon Pop based on number range
  static int getPointsForNumber(int number) {
    if (number >= 1 && number <= 10) return 1;
    if (number >= 20 && number <= 50) return 2;
    if (number >= 50 && number <= 100) return 3;
    return 1;
  }

  // Star thresholds for Balloon Pop
  static int getBalloonStars(int score, int duration) {
    // Average points per second determines stars
    final double avgPerSecond = score / duration;
    if (avgPerSecond >= 2.0) return 3;
    if (avgPerSecond >= 1.0) return 2;
    if (avgPerSecond >= 0.5) return 1;
    return 0;
  }

  // Star thresholds for Number Train (based on completion time)
  static int getTrainStars(int seconds) {
    if (seconds <= 10) return 3;
    if (seconds <= 20) return 2;
    if (seconds <= 30) return 1;
    return 0;
  }
}



