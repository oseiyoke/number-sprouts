import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';

/// SVG-based train car widget with realistic train visuals
class SvgTrainCarWidget extends StatelessWidget {
  final int number;
  final String carType; // 'engine', 'car', or 'caboose'
  final bool isPlaced;

  const SvgTrainCarWidget({
    super.key,
    required this.number,
    this.carType = 'car',
    this.isPlaced = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 100,
      child: Stack(
        children: [
          // SVG Train car
          SvgPicture.asset(
            'assets/images/train/$carType.svg',
            width: 120,
            height: 100,
            fit: BoxFit.contain,
          ),
          
          // Number overlay
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black26, width: 1),
              ),
              child: Text(
                number.toString(),
                style: AppTheme.numberStyle(
                  size: 28,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

