import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/game_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/game_config.dart';
import '../../services/storage_service.dart';
import '../../widgets/common/back_button_widget.dart';
import 'train_game_screen.dart';

/// Configuration screen for Number Train game
class TrainConfigScreen extends ConsumerStatefulWidget {
  const TrainConfigScreen({super.key});

  @override
  ConsumerState<TrainConfigScreen> createState() => _TrainConfigScreenState();
}

class _TrainConfigScreenState extends ConsumerState<TrainConfigScreen> {
  final StorageService _storage = StorageService();
  late NumberTrainConfig _config;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    _config = await _storage.loadTrainConfig();
    setState(() {
      _isLoading = false;
    });
  }

  void _startGame() async {
    await _storage.saveTrainConfig(_config);
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrainGameScreen(config: _config),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                  // Title
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.sunnyOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.train,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Number Train',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Number of cars
                  _buildSectionTitle('Number of Train Cars'),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: _buildDropdown<int>(
                        value: _config.numberOfCars,
                        items: GameConstants.trainCarOptions,
                        onChanged: (value) {
                          setState(() {
                            _config = _config.copyWith(numberOfCars: value);
                          });
                        },
                        itemLabel: (value) => '$value cars',
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Number range
                  _buildSectionTitle('Number Range'),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: _buildRangeSlider(),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Start game button
                  Center(
                    child: ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.sunnyOrange,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 60),
                      ),
                      child: const Text(
                        'Start Game',
                        style: TextStyle(fontSize: 24),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemLabel,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.sunnyOrange, width: 2),
      ),
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        style: Theme.of(context).textTheme.titleLarge,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(itemLabel(item)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildRangeSlider() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.sunnyOrange, width: 2),
      ),
      child: Column(
        children: [
          Text(
            '${_config.startRange.round()} - ${_config.endRange.round()}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.sunnyOrange,
            ),
          ),
          RangeSlider(
            values: RangeValues(
              _config.startRange.toDouble(),
              _config.endRange.toDouble(),
            ),
            min: 1,
            max: 100,
            divisions: 99,
            activeColor: AppTheme.sunnyOrange,
            inactiveColor: AppTheme.sunnyOrange.withValues(alpha: 0.3),
            labels: RangeLabels(
              _config.startRange.round().toString(),
              _config.endRange.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _config = _config.copyWith(
                  startRange: values.start.round(),
                  endRange: values.end.round(),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}



