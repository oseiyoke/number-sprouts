import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/game_config.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/game_constants.dart';
import '../../providers/audio_provider.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/common/back_button_widget.dart';
import '../../widgets/common/game_results_screen.dart';
import 'train_game_controller.dart';
import 'svg_train_car_widget.dart';
import 'train_connector_widget.dart';
import 'train_score_display.dart';
import 'score_feedback_widget.dart';
import 'round_summary_widget.dart';

/// Main game screen for Number Train with realistic visuals
class TrainGameScreen extends ConsumerStatefulWidget {
  final NumberTrainConfig config;

  const TrainGameScreen({
    super.key,
    required this.config,
  });

  @override
  ConsumerState<TrainGameScreen> createState() => _TrainGameScreenState();
}

class _TrainGameScreenState extends ConsumerState<TrainGameScreen> {
  late final StateNotifierProvider<TrainGameController, TrainGameState> _gameProvider;
  int _roundsCompleted = 0;
  final Set<int> _newConnections = {}; // Track new connections for animation
  bool _showingRoundSummary = false; // Track if round summary is showing
  final GlobalKey _gameAreaKey = GlobalKey(); // Key for positioning score feedback

  @override
  void initState() {
    super.initState();
    
    _gameProvider = StateNotifierProvider<TrainGameController, TrainGameState>(
      (ref) => TrainGameController(widget.config),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_gameProvider.notifier).startNewRound();
    });
  }

  bool _isCorrectPlacement(int carNumber, int position) {
    final gameState = ref.read(_gameProvider);
    // The car should be placed in its correct sorted position
    return gameState.sortedNumbers[position] == carNumber;
  }

  void _handleCarPlaced(int carNumber, int position) {
    final audioService = ref.read(audioServiceProvider);
    final controller = ref.read(_gameProvider.notifier);
    
    // Check if this is the correct position for this car
    if (!_isCorrectPlacement(carNumber, position)) {
      // Wrong position - play incorrect sound, record error, and don't place
      audioService.playIncorrect();
      controller.recordError();
      
      // Show -20 score feedback at screen center
      _showScoreFeedback(-20, false, position);
      
      return;
    }
    
    // Correct placement!
    audioService.playClick();
    
    // Record score for correct placement
    controller.recordCorrectPlacement();
    final points = controller.calculatePlacementScore();
    
    // Show score feedback
    _showScoreFeedback(points, true, position);
    
    // Get connections before placement
    final oldConnections = <int>{};
    for (int i = 0; i < widget.config.numberOfCars - 1; i++) {
      if (controller.areAdjacentCarsCorrect(i)) {
        oldConnections.add(i);
      }
    }
    
    // Place the car
    controller.placeCar(carNumber, position);
    
    // Check for new connections
    _newConnections.clear();
    for (int i = 0; i < widget.config.numberOfCars - 1; i++) {
      if (controller.areAdjacentCarsCorrect(i) && !oldConnections.contains(i)) {
        _newConnections.add(i);
        // Play correct sound for new connection
        audioService.playCorrect();
      }
    }
    
    setState(() {}); // Rebuild to show animations
    
    final gameState = ref.read(_gameProvider);
    
    // Check if complete after placement
    if (gameState.isComplete) {
      // Correct order!
      audioService.playTrainChug();
      
      // Wait for animation then show results or new round
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted && !_showingRoundSummary) {
          _roundsCompleted++;
          if (_roundsCompleted < 3) {
            // Show round summary before starting new round
            _showRoundSummary();
          } else {
            // Game complete
            _onGameEnd();
          }
        }
      });
    }
  }

  void _showScoreFeedback(int points, bool isPositive, int position) {
    // Calculate position for score feedback (center of the drop target)
    final RenderBox? renderBox =
        _gameAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final offset = Offset(
        (position * 140.0) + 60, // Center of the car
        200, // Y position
      );
      ScoreFeedbackOverlay.show(
        context,
        points: points.abs(),
        isPositive: isPositive,
        position: offset,
      );
    }
  }

  void _showRoundSummary() {
    setState(() {
      _showingRoundSummary = true;
    });

    final gameState = ref.read(_gameProvider);
    final bonuses = ref.read(_gameProvider.notifier).calculateRoundBonus();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RoundSummaryWidget(
        roundNumber: _roundsCompleted,
        roundScore: gameState.roundScore,
        timeBonus: bonuses['timeBonus']!,
        perfectBonus: bonuses['perfectBonus']!,
        roundTime: gameState.completionTime,
        onContinue: () {
          Navigator.of(context).pop();
          setState(() {
            _showingRoundSummary = false;
          });
          // Start new round
          ref.read(_gameProvider.notifier).startNewRound();
          _newConnections.clear();
        },
      ),
    );
  }

  void _onGameEnd() {
    final gameState = ref.read(_gameProvider);
    final stars = GameConstants.getTrainStars(gameState.completionTime);
    
    // Use the actual score from game state
    final score = gameState.score;

    ref.read(progressProvider.notifier).recordGameResult(
      'Number Train',
      score,
      stars,
    );

    ref.read(audioServiceProvider).playCelebration();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => GameResultsScreen(
          gameName: 'Number Train',
          score: score,
          stars: stars,
          onReplay: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => TrainGameScreen(config: widget.config),
              ),
            );
          },
          onHome: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  String _getCarType(int position) {
    if (position == 0) return 'engine';
    if (position == widget.config.numberOfCars - 1) return 'caboose';
    return 'car';
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(_gameProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light sky blue background
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackButtonWidget(),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Number Train',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Arrange from smallest to largest',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Score display at top right
                  TrainScoreDisplay(
                    score: gameState.score,
                    combo: gameState.combo,
                    currentRound: _roundsCompleted + 1,
                    totalRounds: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Scenery (clouds and mountains)
            _buildScenery(),

            const SizedBox(height: 20),

            // Train track with cars
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    key: _gameAreaKey, // Key for positioning score feedback
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Train cars and connectors
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _buildTrainTrack(gameState),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Railroad track
                      _buildRailroadTrack(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Train yard (unplaced cars)
            Container(
              height: 160,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.brown[100],
                border: Border(
                  top: BorderSide(color: Colors.brown[300]!, width: 2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Train Yard - Drag cars to the track',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.brown[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: gameState.cars
                            .where((car) => car.position == null)
                            .map((car) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Draggable<int>(
                              data: car.number,
                              feedback: Material(
                                color: Colors.transparent,
                                child: Transform.scale(
                                  scale: 1.1,
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: SvgTrainCarWidget(
                                      number: car.number,
                                      carType: 'car',
                                    ),
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: SvgTrainCarWidget(
                                  number: car.number,
                                  carType: 'car',
                                ),
                              ),
                              child: SvgTrainCarWidget(
                                number: car.number,
                                carType: 'car',
                              ),
                            ),
                          );
                        }).toList(),
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

  List<Widget> _buildTrainTrack(TrainGameState gameState) {
    final widgets = <Widget>[];
    final controller = ref.read(_gameProvider.notifier);

    for (int i = 0; i < widget.config.numberOfCars; i++) {
      // Add connector before this car (except for first position)
      if (i > 0) {
        final showConnector = controller.areAdjacentCarsCorrect(i - 1);
        final shouldAnimate = _newConnections.contains(i - 1);
        
        widgets.add(
          TrainConnectorWidget(
            isVisible: showConnector,
            animate: shouldAnimate,
          ),
        );
      }

      // Find car at this position
      final carAtPosition = gameState.cars
          .where((car) => car.position == i)
          .firstOrNull;

      // Add drop target
      widgets.add(
        DragTarget<int>(
          onWillAcceptWithDetails: (details) {
            // Check if this car can be placed here
            return _isCorrectPlacement(details.data, i);
          },
          onAcceptWithDetails: (details) {
            _handleCarPlaced(details.data, i);
          },
          builder: (context, candidateData, rejectedData) {
            // Show red if incorrect car is hovering, green if correct
            final isHovering = candidateData.isNotEmpty;
            final isCorrectHover = isHovering 
                ? _isCorrectPlacement(candidateData.first as int, i) 
                : false;
            
            return Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isHovering
                    ? (isCorrectHover 
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isHovering
                      ? (isCorrectHover ? Colors.green : Colors.red)
                      : Colors.grey.withValues(alpha: 0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: carAtPosition != null
                  ? SvgTrainCarWidget(
                      number: carAtPosition.number,
                      carType: _getCarType(i),
                      isPlaced: true,
                    )
                  : Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            );
          },
        ),
      );
    }

    return widgets;
  }

  Widget _buildRailroadTrack() {
    final trackWidth = (widget.config.numberOfCars * 140.0);
    
    return CustomPaint(
      size: Size(trackWidth, 30),
      painter: _RailroadTrackPainter(),
    );
  }

  Widget _buildScenery() {
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          // Mountains in background
          Positioned(
            bottom: 0,
            left: 50,
            child: CustomPaint(
              size: const Size(100, 60),
              painter: _MountainPainter(Colors.grey[400]!),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 100,
            child: CustomPaint(
              size: const Size(120, 70),
              painter: _MountainPainter(Colors.grey[500]!),
            ),
          ),
          // Clouds
          Positioned(
            top: 10,
            left: 100,
            child: _buildCloud(60),
          ),
          Positioned(
            top: 20,
            right: 150,
            child: _buildCloud(50),
          ),
        ],
      ),
    );
  }

  Widget _buildCloud(double size) {
    return Container(
      width: size,
      height: size * 0.5,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}

/// Painter for railroad tracks
class _RailroadTrackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final railPaint = Paint()
      ..color = Colors.brown[800]!
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final tiePaint = Paint()
      ..color = Colors.brown[600]!
      ..strokeWidth = 3;

    // Draw two rails
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      railPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.7),
      railPaint,
    );

    // Draw railroad ties
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(
        Offset(x, size.height * 0.2),
        Offset(x, size.height * 0.8),
        tiePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter for mountain scenery
class _MountainPainter extends CustomPainter {
  final Color color;

  _MountainPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.3, size.height * 0.2)
      ..lineTo(size.width * 0.7, size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
