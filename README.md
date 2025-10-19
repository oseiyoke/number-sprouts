# Number Sprouts

An educational Flutter app for children aged 5-7 to develop foundational number skills through interactive mini-games.

## Download

[Download APK](https://drive.google.com/file/d/19GHQPALZJuVfVTiRKioUs0aAlupP3Lhf/view?usp=sharing) - Try the latest Android version

## Current Features

### Implemented Games
- **Balloon Pop**: Pop balloons with the correct numbers before time runs out. Features customizable timer duration, number ranges, and dynamic balloon spawning with animations.
- **Number Train**: Arrange train cars in correct numerical order (smallest to largest). Uses SVG graphics for train components (engine, cars, caboose) with drag-and-drop functionality.

### Core Features
- **Progress Tracking**: Stars and scores are saved locally for each game
- **Garden Display**: Visual representation of total stars earned across all games
- **Audio System**: Background music, sound effects for clicks, correct/incorrect answers, celebrations, and game-specific sounds
- **Text-to-Speech**: Voice narration for numbers and game instructions
- **Parent Settings**: Protected settings area for audio controls and other preferences
- **Celebrations**: Confetti animations and celebration sounds when games are completed successfully

### Game Mechanics
Each game includes:
- Configuration screen to customize difficulty settings
- Real-time score tracking and feedback
- Star-based rating system (1-3 stars based on performance)
- Round summaries with performance statistics
- Visual and audio feedback for correct/incorrect answers

## Tech Stack

- **Flutter 3.x** with Dart SDK ^3.9.2
- **State Management**: flutter_riverpod ^2.6.1
- **Audio**: 
  - audioplayers ^6.1.0 (background music & sound effects)
  - flutter_tts ^4.2.0 (voice narration)
- **Animations**: flutter_animate ^4.5.0
- **Graphics**: flutter_svg ^2.0.10 (SVG rendering for train graphics)
- **Celebrations**: confetti ^0.7.0
- **Persistence**: shared_preferences ^2.3.3

## Getting Started

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to launch the app

## Project Structure

```
lib/
├── main.dart                    # App entry point with ProviderScope
├── app.dart                     # Root MaterialApp widget
├── core/
│   ├── theme/
│   │   └── app_theme.dart      # Color scheme and theme definitions
│   ├── constants/
│   │   ├── animation_constants.dart  # Animation timing and effects
│   │   ├── audio_constants.dart      # Sound file paths
│   │   └── game_constants.dart       # Game rules and configuration
│   └── utils/
│       └── number_generator.dart     # Random number generation utilities
├── models/
│   ├── game_config.dart        # Configuration data for each game
│   ├── game_score.dart         # Score and stars from game sessions
│   └── user_progress.dart      # Overall progress tracking
├── providers/
│   ├── audio_provider.dart     # Audio state management
│   ├── progress_provider.dart  # User progress state
│   └── settings_provider.dart  # App settings state
├── services/
│   ├── audio_service.dart      # Audio playback management
│   ├── storage_service.dart    # Local data persistence
│   └── tts_service.dart        # Text-to-speech functionality
├── widgets/
│   ├── common/
│   │   ├── back_button_widget.dart   # Reusable back button
│   │   └── game_results_screen.dart  # Post-game results display
│   └── game_card.dart                # Home screen game cards
└── screens/
    ├── home/
    │   ├── home_screen.dart           # Main menu
    │   ├── garden_display.dart        # Star count visualization
    │   └── parent_settings_button.dart # Protected settings access
    ├── balloon_pop/
    │   ├── balloon_config_screen.dart   # Game configuration
    │   ├── balloon_game_screen.dart     # Main game interface
    │   ├── balloon_game_controller.dart # Game logic and state
    │   ├── balloon_widget.dart          # Individual balloon rendering
    │   └── balloon_painter.dart         # Custom balloon graphics
    ├── number_train/
    │   ├── train_config_screen.dart     # Game configuration
    │   ├── train_game_screen.dart       # Main game interface
    │   ├── train_game_controller.dart   # Game logic and state
    │   ├── svg_train_car_widget.dart    # SVG train car rendering
    │   ├── train_connector_widget.dart  # Visual train car connections
    │   ├── train_score_display.dart     # In-game score display
    │   ├── score_feedback_widget.dart   # Answer feedback display
    │   └── round_summary_widget.dart    # Post-round statistics
    ├── number_stairs/               # Coming soon
    └── settings/
        └── parent_settings_screen.dart  # Settings interface
```

## Assets

### Audio Files
- background_music.mp3 - Main menu background music
- celebration.mp3 - Success/completion sound
- click.mp3 - UI interaction sound
- correct.mp3 - Correct answer feedback
- incorrect.mp3 - Wrong answer feedback
- pop.mp3 - Balloon pop sound
- train_chug.mp3 - Train movement sound

### Graphics
- train/ - SVG train components (engine.svg, car.svg, caboose.svg)

## Development Principles

- **Modular Code**: Each file kept under 200 lines for maintainability
- **Clean UI**: No shadows, subtle colors, large tap targets (minimum 60x60dp)
- **Beginner-Friendly**: Code includes explanatory comments for Flutter concepts
- **Child-Safe**: Portrait-only, offline-first, no ads, no external links
- **Separation of Concerns**: Game logic separated from UI rendering

## Game Configuration

### Balloon Pop
- Timer duration (adjustable)
- Number range (e.g., 1-10, 1-20)
- Balloon spawn rate and speed

### Number Train
- Number of train cars (3-7 cars)
- Number range customization
- Difficulty levels affect scoring

### Number Stairs (Coming Soon)
- Number of steps
- Number range
- Step timing

Progress (stars earned and high scores) is automatically saved locally using SharedPreferences.

## Testing

Run tests with:
```bash
flutter test
```

## Building

For release builds:
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# macOS
flutter build macos --release

# Web
flutter build web --release
```

## Platform Support

- iOS 12+
- Android 6+ (API 23+)
- macOS 10.14+
- Web (Chrome, Safari, Firefox)
- Linux
- Windows

## Notes

- Portrait mode is enforced on mobile devices
- Fully functional offline
- All audio files are included in assets
- SVG graphics used for scalable train components
- State persists across app restarts
- No internet connection required
