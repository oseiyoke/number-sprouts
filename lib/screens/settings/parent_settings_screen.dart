import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/common/back_button_widget.dart';
import '../../core/theme/app_theme.dart';

/// Parent settings screen with age gate and controls
/// Parents can toggle sound/music and view progress
class ParentSettingsScreen extends ConsumerStatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  ConsumerState<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends ConsumerState<ParentSettingsScreen> {
  bool _hasPassedAgeGate = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    // Simple age gate: 3 + 5 = 8
    if (_controller.text.trim() == '8') {
      setState(() {
        _hasPassedAgeGate = true;
      });
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Try again!'),
          duration: Duration(seconds: 2),
        ),
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPassedAgeGate) {
      // Show age gate
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: BackButtonWidget(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 
                                MediaQuery.of(context).padding.top - 56,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Parent Settings',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'What is 3 + 5?',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Answer',
                              ),
                              onSubmitted: (_) => _checkAnswer(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _checkAnswer,
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show settings after passing age gate
    final settings = ref.watch(settingsProvider);
    final progress = ref.watch(progressProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: BackButtonWidget(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'Parent Settings',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 32),

                  // Sound toggle
                  Card(
                    child: SwitchListTile(
                      title: const Text('Sound Effects'),
                      subtitle: const Text('Enable or disable sound effects'),
                      value: settings.soundEnabled,
                      onChanged: (_) {
                        ref.read(settingsProvider.notifier).toggleSound();
                      },
                      activeTrackColor: AppTheme.primaryGreen,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Music toggle
                  Card(
                    child: SwitchListTile(
                      title: const Text('Background Music'),
                      subtitle: const Text('Enable or disable music'),
                      value: settings.musicEnabled,
                      onChanged: (_) {
                        ref.read(settingsProvider.notifier).toggleMusic();
                      },
                      activeTrackColor: AppTheme.primaryGreen,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Progress display
                  Text(
                    'Progress',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppTheme.sunnyOrange,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Total Stars: ${progress.totalStars}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          Text(
                            'High Scores',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          _buildHighScore('Balloon Pop', progress.getHighScore('Balloon Pop')),
                          _buildHighScore('Number Train', progress.getHighScore('Number Train')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighScore(String gameName, int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(gameName),
          Text(
            score.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

