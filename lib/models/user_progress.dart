/// Tracks the user's overall progress and achievements
/// This includes total stars earned and high scores for each game
class UserProgress {
  final int totalStars;
  final Map<String, int> highScores;

  const UserProgress({
    this.totalStars = 0,
    this.highScores = const {},
  });

  /// Add stars to the total
  UserProgress addStars(int stars) {
    return UserProgress(
      totalStars: totalStars + stars,
      highScores: highScores,
    );
  }

  /// Update high score for a specific game
  UserProgress updateHighScore(String gameName, int score) {
    final newHighScores = Map<String, int>.from(highScores);
    final currentHigh = newHighScores[gameName] ?? 0;
    
    if (score > currentHigh) {
      newHighScores[gameName] = score;
    }

    return UserProgress(
      totalStars: totalStars,
      highScores: newHighScores,
    );
  }

  /// Get high score for a specific game
  int getHighScore(String gameName) {
    return highScores[gameName] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalStars': totalStars,
      'highScores': highScores,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      totalStars: json['totalStars'] ?? 0,
      highScores: Map<String, int>.from(json['highScores'] ?? {}),
    );
  }
}



