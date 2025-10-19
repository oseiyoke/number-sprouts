import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/game_card.dart';
import 'garden_display.dart';
import 'parent_settings_button.dart';
import '../balloon_pop/balloon_config_screen.dart';
import '../number_train/train_config_screen.dart';

/// The main home screen showing all available games
/// This is what users see when they open the app
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with title and settings
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App title
                  Row(
                    children: [
                      Icon(
                        Icons.energy_savings_leaf,
                        size: 40,
                        color: AppTheme.primaryGreen,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Number Sprouts',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Grow Your Number Skills!',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Settings button
                  const ParentSettingsButton(),
                ],
              ),
            ),

            // Garden display showing total stars
            const GardenDisplay(),

            const SizedBox(height: 16),

            // Game cards
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Balloon Pop game
                  GameCard(
                    gameName: 'Balloon Pop',
                    icon: Icons.circle,
                    color: AppTheme.skyBlue,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BalloonConfigScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Number Train game
                  GameCard(
                    gameName: 'Number Train',
                    icon: Icons.train,
                    color: AppTheme.sunnyOrange,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TrainConfigScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



