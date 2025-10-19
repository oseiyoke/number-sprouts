import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-Speech service for speaking numbers and instructions
/// This helps children who are still learning to read
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isEnabled = true;

  TtsService() {
    _initialize();
  }

  /// Initialize TTS with settings
  Future<void> _initialize() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.4); // Slower speech for children
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1); // Slightly higher pitch for friendliness
  }

  /// Enable or disable TTS
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (!enabled) {
      _tts.stop();
    }
  }

  /// Speak a number
  Future<void> speakNumber(int number) async {
    if (!_isEnabled) return;
    await _tts.speak(number.toString());
  }

  /// Speak instruction to pop a number (for Balloon Pop game)
  Future<void> speakPopNumber(int number) async {
    if (!_isEnabled) return;
    await _tts.speak('$number');
  }

  /// Speak encouragement
  Future<void> speakEncouragement(String message) async {
    if (!_isEnabled) return;
    await _tts.speak(message);
  }

  /// Speak "Great job!"
  Future<void> speakGreatJob() async {
    await speakEncouragement('Great job!');
  }

  /// Speak "Try again!"
  Future<void> speakTryAgain() async {
    await speakEncouragement('Try again!');
  }

  /// Speak "You did it!"
  Future<void> speakYouDidIt() async {
    await speakEncouragement('You did it!');
  }

  /// Stop speaking
  Future<void> stop() async {
    await _tts.stop();
  }
}



