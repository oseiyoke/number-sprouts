import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';
import '../services/tts_service.dart';
import 'settings_provider.dart';

/// Provider for the audio service (sound effects and music)
/// This creates a single AudioService instance that lives throughout the app
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  
  // Listen to settings changes and update audio accordingly
  ref.listen(
    settingsProvider.select((state) => state.soundEnabled),
    (_, enabled) => service.setSoundEnabled(enabled),
  );
  
  ref.listen(
    settingsProvider.select((state) => state.musicEnabled),
    (_, enabled) => service.setMusicEnabled(enabled),
  );
  
  // Clean up when provider is disposed
  ref.onDispose(() => service.dispose());
  
  return service;
});

/// Provider for the TTS service (text-to-speech)
final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  
  // Listen to settings changes and update TTS accordingly
  ref.listen(
    settingsProvider.select((state) => state.soundEnabled),
    (_, enabled) => service.setEnabled(enabled),
  );
  
  return service;
});

