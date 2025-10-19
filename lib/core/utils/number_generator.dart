import 'dart:math';

/// Utility class for generating random numbers based on integer ranges
class NumberGenerator {
  static final Random _random = Random();

  /// Generate a random number within the specified range
  static int generateNumber(int start, int end) {
    final range = end - start + 1;
    return _random.nextInt(range) + start;
  }

  /// Generate a list of unique random numbers
  static List<int> generateUniqueNumbers(int start, int end, int count) {
    final Set<int> numbers = {};
    
    // Keep generating until we have enough unique numbers
    while (numbers.length < count) {
      numbers.add(generateNumber(start, end));
    }
    
    return numbers.toList();
  }

  /// Generate a sorted sequence of unique numbers (for train game)
  static List<int> generateSequence(int start, int end, int count) {
    final numbers = generateUniqueNumbers(start, end, count);
    numbers.sort();
    return numbers;
  }
}



