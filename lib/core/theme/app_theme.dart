import 'package:flutter/material.dart';

/// App theme with nature/growth color palette
/// This defines all the colors, text styles, and visual elements
/// used throughout the app for consistency
class AppTheme {
  // Nature-inspired color palette - subtle greens, blues, oranges
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFF81C784);
  static const Color skyBlue = Color(0xFF42A5F5);
  static const Color sunnyOrange = Color(0xFFFF9800);
  static const Color softYellow = Color(0xFFFFEB3B);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF666666);

  /// Main theme data for the entire app
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryGreen,
        secondary: skyBlue,
        surface: white,
        onPrimary: white,
        onSecondary: white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      
      // Large, chunky text for numbers
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: textDark,
          height: 1.0,
        ),
        displayMedium: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: textDark,
        ),
      ),
      
      // Button styles with large tap targets (60x60dp minimum)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 60),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0, // No shadows per user preference
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Card style - clean with no shadows
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: EdgeInsets.all(8),
        color: white,
      ),
    );
  }

  /// Number text style for game screens
  static TextStyle numberStyle({
    double size = 60,
    Color color = textDark,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
      fontFamily: 'monospace',
    );
  }

  /// Button style for game controls
  static BoxDecoration gameButton(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
    );
  }
}

