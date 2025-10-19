import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_config.dart';
import '../models/user_progress.dart';

/// Service for storing and retrieving data locally on the device
/// Uses SharedPreferences to save game configs and user progress
class StorageService {
  // Keys for storing data
  static const String _balloonConfigKey = 'balloon_config';
  static const String _trainConfigKey = 'train_config';
  static const String _userProgressKey = 'user_progress';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _musicEnabledKey = 'music_enabled';

  /// Save Balloon Pop configuration
  Future<void> saveBalloonConfig(BalloonPopConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(config.toJson());
    await prefs.setString(_balloonConfigKey, jsonString);
  }

  /// Load Balloon Pop configuration
  Future<BalloonPopConfig> loadBalloonConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_balloonConfigKey);
    
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return BalloonPopConfig.fromJson(jsonMap);
    }
    
    return const BalloonPopConfig();
  }

  /// Save Number Train configuration
  Future<void> saveTrainConfig(NumberTrainConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(config.toJson());
    await prefs.setString(_trainConfigKey, jsonString);
  }

  /// Load Number Train configuration
  Future<NumberTrainConfig> loadTrainConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_trainConfigKey);
    
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return NumberTrainConfig.fromJson(jsonMap);
    }
    
    return const NumberTrainConfig();
  }

  /// Save user progress (stars and high scores)
  Future<void> saveUserProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(progress.toJson());
    await prefs.setString(_userProgressKey, jsonString);
  }

  /// Load user progress
  Future<UserProgress> loadUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userProgressKey);
    
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return UserProgress.fromJson(jsonMap);
    }
    
    return const UserProgress();
  }

  /// Save sound enabled state
  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }

  /// Get sound enabled state
  Future<bool> isSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEnabledKey) ?? true;
  }

  /// Save music enabled state
  Future<void> setMusicEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_musicEnabledKey, enabled);
  }

  /// Get music enabled state
  Future<bool> isMusicEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_musicEnabledKey) ?? true;
  }
}



