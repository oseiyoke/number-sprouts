import 'package:audioplayers/audioplayers.dart';
import '../core/constants/audio_constants.dart';

/// Service for playing sound effects and background music
/// This handles all audio in the app
class AudioService {
  final AudioPlayer _soundPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  /// Set whether sound effects are enabled
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    if (!enabled) {
      _soundPlayer.stop();
    }
  }

  /// Set whether background music is enabled
  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      _musicPlayer.stop();
    } else {
      playBackgroundMusic();
    }
  }

  /// Play a sound effect
  /// Since we don't have actual sound files yet, this handles errors gracefully
  Future<void> playSound(String soundPath) async {
    if (!_soundEnabled) return;
    
    try {
      await _soundPlayer.stop();
      await _soundPlayer.play(
        AssetSource(soundPath.replaceFirst('assets/', '')),
        volume: AudioConstants.defaultVolume,
      );
    } catch (e) {
      // Silently fail if sound file doesn't exist (placeholder mode)
      // In production, you'd log this error
    }
  }

  /// Play the pop sound (for balloon pop)
  Future<void> playPop() async {
    await playSound(AudioConstants.popSound);
  }

  /// Play correct answer sound
  Future<void> playCorrect() async {
    await playSound(AudioConstants.correctSound);
  }

  /// Play incorrect answer sound
  Future<void> playIncorrect() async {
    await playSound(AudioConstants.incorrectSound);
  }

  /// Play celebration sound
  Future<void> playCelebration() async {
    await playSound(AudioConstants.celebrationSound);
  }

  /// Play train chug sound
  Future<void> playTrainChug() async {
    await playSound(AudioConstants.trainChug);
  }

  /// Play click sound
  Future<void> playClick() async {
    await playSound(AudioConstants.clickSound);
  }

  /// Play background music on loop
  Future<void> playBackgroundMusic() async {
    if (!_musicEnabled) return;
    
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.play(
        AssetSource(AudioConstants.backgroundMusic.replaceFirst('assets/', '')),
        volume: AudioConstants.musicVolume,
      );
    } catch (e) {
      // Silently fail if music file doesn't exist
    }
  }

  /// Stop background music
  Future<void> stopBackgroundMusic() async {
    await _musicPlayer.stop();
  }

  /// Dispose of audio players when done
  void dispose() {
    _soundPlayer.dispose();
    _musicPlayer.dispose();
  }
}



