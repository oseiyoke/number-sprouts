import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_progress.dart';
import '../services/storage_service.dart';

/// Provider that manages user progress (stars and high scores)
class ProgressNotifier extends StateNotifier<UserProgress> {
  final StorageService _storage;

  ProgressNotifier(this._storage) : super(const UserProgress()) {
    _loadProgress();
  }

  /// Load progress from storage on startup
  Future<void> _loadProgress() async {
    final progress = await _storage.loadUserProgress();
    state = progress;
  }

  /// Add stars after completing a game
  Future<void> addStars(int stars) async {
    state = state.addStars(stars);
    await _storage.saveUserProgress(state);
  }

  /// Update high score for a game
  Future<void> updateHighScore(String gameName, int score) async {
    state = state.updateHighScore(gameName, score);
    await _storage.saveUserProgress(state);
  }

  /// Add stars and update high score in one go
  Future<void> recordGameResult(String gameName, int score, int stars) async {
    state = state.addStars(stars).updateHighScore(gameName, score);
    await _storage.saveUserProgress(state);
  }
}

/// Global progress provider
final progressProvider = StateNotifierProvider<ProgressNotifier, UserProgress>((ref) {
  return ProgressNotifier(StorageService());
});



