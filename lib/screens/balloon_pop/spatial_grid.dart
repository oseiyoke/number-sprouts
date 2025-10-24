import 'dart:math';

/// Spatial grid system for efficient collision detection
/// Divides the screen into a 4x6 grid (24 cells) for O(1) lookups
class SpatialGrid {
  static const int columns = 4;
  static const int rows = 6;
  
  // Map of cell index to list of balloon IDs in that cell
  final Map<int, Set<String>> _cells = {};
  
  // Map of balloon ID to its current cell index
  final Map<String, int> _balloonCells = {};
  
  // Map of balloon ID to its position for distance calculations
  final Map<String, _Position> _balloonPositions = {};
  
  SpatialGrid() {
    // Initialize all cells
    for (int i = 0; i < columns * rows; i++) {
      _cells[i] = {};
    }
  }
  
  /// Get cell index from normalized position (0.0 to 1.0)
  int _getCellIndex(double left, double bottom) {
    // Clamp values to valid range
    final clampedLeft = left.clamp(0.0, 0.99);
    final clampedBottom = bottom.clamp(0.0, 0.99);
    
    final col = (clampedLeft * columns).floor();
    final row = (clampedBottom * rows).floor();
    
    return row * columns + col;
  }
  
  /// Add a balloon to the grid
  void addBalloon(String balloonId, double left, double bottom) {
    final cellIndex = _getCellIndex(left, bottom);
    _cells[cellIndex]?.add(balloonId);
    _balloonCells[balloonId] = cellIndex;
    _balloonPositions[balloonId] = _Position(left, bottom);
  }
  
  /// Update a balloon's position in the grid
  void updateBalloon(String balloonId, double left, double bottom) {
    final newCellIndex = _getCellIndex(left, bottom);
    final oldCellIndex = _balloonCells[balloonId];
    
    // If balloon moved to a different cell, update it
    if (oldCellIndex != null && oldCellIndex != newCellIndex) {
      _cells[oldCellIndex]?.remove(balloonId);
      _cells[newCellIndex]?.add(balloonId);
      _balloonCells[balloonId] = newCellIndex;
    }
    
    // Update position
    _balloonPositions[balloonId] = _Position(left, bottom);
  }
  
  /// Remove a balloon from the grid
  void removeBalloon(String balloonId) {
    final cellIndex = _balloonCells[balloonId];
    if (cellIndex != null) {
      _cells[cellIndex]?.remove(balloonId);
      _balloonCells.remove(balloonId);
      _balloonPositions.remove(balloonId);
    }
  }
  
  /// Get all balloons in a specific cell
  Set<String> getBalloonsInCell(int cellIndex) {
    return _cells[cellIndex] ?? {};
  }
  
  /// Get all balloons in nearby cells (including the cell itself)
  /// This includes the 9 cells: current, and 8 surrounding cells
  Set<String> getNearbyBalloons(double left, double bottom) {
    final cellIndex = _getCellIndex(left, bottom);
    final col = cellIndex % columns;
    final row = cellIndex ~/ columns;
    
    final nearbyBalloons = <String>{};
    
    // Check current cell and all adjacent cells
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        final newRow = row + dr;
        final newCol = col + dc;
        
        // Check bounds
        if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < columns) {
          final nearbyIndex = newRow * columns + newCol;
          nearbyBalloons.addAll(_cells[nearbyIndex] ?? {});
        }
      }
    }
    
    return nearbyBalloons;
  }
  
  /// Check if a position has collision with existing balloons
  /// minDistance is in normalized coordinates (0.0 to 1.0)
  bool hasCollision(double left, double bottom, double minDistance) {
    final nearbyBalloons = getNearbyBalloons(left, bottom);
    
    for (final balloonId in nearbyBalloons) {
      final otherPos = _balloonPositions[balloonId];
      if (otherPos != null) {
        final distance = _calculateDistance(left, bottom, otherPos.left, otherPos.bottom);
        if (distance < minDistance) {
          return true;
        }
      }
    }
    
    return false;
  }
  
  /// Calculate Euclidean distance between two positions
  double _calculateDistance(double x1, double y1, double x2, double y2) {
    final dx = x1 - x2;
    final dy = y1 - y2;
    return sqrt(dx * dx + dy * dy);
  }
  
  /// Clear all balloons from the grid
  void clear() {
    for (final cell in _cells.values) {
      cell.clear();
    }
    _balloonCells.clear();
    _balloonPositions.clear();
  }
  
  /// Get total number of balloons in the grid
  int get balloonCount => _balloonCells.length;
}

/// Internal class to store balloon position
class _Position {
  final double left;
  final double bottom;
  
  _Position(this.left, this.bottom);
}

