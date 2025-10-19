# Number Sprouts

An educational Flutter app for children aged 5-7 to develop foundational number skills through interactive mini-games.

## Features

- **Balloon Pop**: Tap correct number balloons before time runs out
- **Number Train**: Arrange train cars in correct numerical order (smallest to largest)
- **Number Stairs**: Climb stairs by tapping numbers in ascending order

## Tech Stack

- Flutter 3.x
- Riverpod for state management
- flutter_tts for voice narration
- audioplayers for sound effects
- flutter_animate for smooth animations
- confetti for celebrations
- shared_preferences for data persistence

## Getting Started

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to launch the app

## Project Structure

```
lib/
├── main.dart              # App entry point
├── app.dart               # Root app widget
├── core/
│   ├── theme/            # App theme and colors
│   ├── constants/        # Game rules and configuration
│   └── utils/            # Helper utilities
├── models/               # Data models
├── providers/            # Riverpod state management
├── services/             # Audio, TTS, and storage services
├── widgets/              # Reusable UI components
└── screens/              # Game screens
    ├── home/
    ├── balloon_pop/
    ├── number_train/
    ├── number_stairs/
    └── settings/
```

## Development Principles

- **Modular Code**: Each file kept under 200 lines
- **Clean UI**: No shadows, subtle colors, large tap targets (60x60dp minimum)
- **Beginner-Friendly**: Code includes explanations of Flutter concepts
- **Child-Safe**: Portrait-only, offline-first, no ads

## Configuration

Each game offers customizable settings:
- **Balloon Pop**: Timer duration, number range, balloon speed
- **Number Train**: Number of cars, number range
- **Number Stairs**: Number of steps, number range

Progress (stars earned and high scores) is saved locally.

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
```

## Notes

- Audio files are placeholders (assets/sounds/)
- Portrait mode is enforced
- Fully functional offline
- Target devices: iOS 12+, Android 6+
# number-sprouts
