import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/progress_provider.dart';
import '../../core/theme/app_theme.dart';

/// Displays the garden with sprouts growing based on total stars earned
/// Visual representation of progress
class GardenDisplay extends ConsumerWidget {
  const GardenDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the progress provider to get total stars
    // When stars change, this widget automatically rebuilds
    final progress = ref.watch(progressProvider);
    final totalStars = progress.totalStars;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightGreen.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Star icon
          Icon(
            Icons.energy_savings_leaf,
            size: 48,
            color: AppTheme.primaryGreen,
          ),
          
          const SizedBox(width: 16),
          
          // Total stars text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Garden',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: AppTheme.sunnyOrange,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$totalStars Stars',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

