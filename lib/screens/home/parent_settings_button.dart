import 'package:flutter/material.dart';
import '../settings/parent_settings_screen.dart';

/// Button to access parent settings
/// Positioned in the top corner of the home screen
class ParentSettingsButton extends StatelessWidget {
  const ParentSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.settings,
        size: 32,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ParentSettingsScreen(),
          ),
        );
      },
    );
  }
}



