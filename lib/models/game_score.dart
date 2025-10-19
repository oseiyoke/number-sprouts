/// Represents the score and stars earned from a game session
/// This is created after each game to track performance
class GameScore {
  final String gameName;
  final int score;
  final int stars;
  final DateTime timestamp;

  const GameScore({
    required this.gameName,
    required this.score,
    required this.stars,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'gameName': gameName,
      'score': score,
      'stars': stars,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory GameScore.fromJson(Map<String, dynamic> json) {
    return GameScore(
      gameName: json['gameName'] ?? '',
      score: json['score'] ?? 0,
      stars: json['stars'] ?? 0,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}



