import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

/// Settings state that holds sound and music preferences
class SettingsState {
  final bool soundEnabled;
  final bool musicEnabled;

  const SettingsState({
    this.soundEnabled = true,
    this.musicEnabled = true,
  });

  SettingsState copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
    );
  }
}

/// Provider that manages app settings
/// This is a StateNotifier which means it can update its state over time
class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService _storage;

  SettingsNotifier(this._storage) : super(const SettingsState()) {
    _loadSettings();
  }

  /// Load settings from storage on startup
  Future<void> _loadSettings() async {
    final soundEnabled = await _storage.isSoundEnabled();
    final musicEnabled = await _storage.isMusicEnabled();
    
    state = SettingsState(
      soundEnabled: soundEnabled,
      musicEnabled: musicEnabled,
    );
  }

  /// Toggle sound on/off
  Future<void> toggleSound() async {
    final newValue = !state.soundEnabled;
    state = state.copyWith(soundEnabled: newValue);
    await _storage.setSoundEnabled(newValue);
  }

  /// Toggle music on/off
  Future<void> toggleMusic() async {
    final newValue = !state.musicEnabled;
    state = state.copyWith(musicEnabled: newValue);
    await _storage.setMusicEnabled(newValue);
  }
}

/// Global provider instance that widgets can access
/// This creates a single instance of SettingsNotifier that lives throughout the app
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(StorageService());
});



