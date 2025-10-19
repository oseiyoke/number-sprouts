import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

/// The entry point of the app
/// This function runs when the app starts
void main() {
  // WidgetsFlutterBinding ensures Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // ProviderScope is required for Riverpod to work
  // It wraps the entire app and provides state management
  runApp(
    const ProviderScope(
      child: NumberSproutsApp(),
    ),
  );
}
