import 'package:flutter/material.dart';

/// A card widget for displaying a game on the home screen
/// Shows game name, icon, and a play button
class GameCard extends StatelessWidget {
  final String gameName;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.gameName,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              // Game icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Game name
              Expanded(
                child: Text(
                  gameName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Arrow icon to indicate tap
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

