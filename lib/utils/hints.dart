class Hint {
  /// Creates a [Hint] with a [text] to show and the available quality [values].
  const Hint({required this.text, required this.values});

  /// Hint message to show.
  final String text;

  /// Available quality values after this hint is given.
  final List<int> values;
}

/// Returns a [Hint] of a given word [reading] showing [n] characters.
///
/// Returns null if [reading] has 1 or less characters.
///
/// Throws a [FormatException] when the number of characters [n] is greater than
/// the length of [reading] or less than or equal to 0.
Hint? getReadingHint(String reading, int n) {
  final length = reading.length;
  final ratio = n / length;

  if (length <= 1) {
    return null;
  } else if (n <= 0) {
    throw const FormatException("'hints' must be greater than 0.");
  } else if (n > length) {
    throw const FormatException("No more hints available.");
  }

  List<int> values = [];

  if (ratio <= 0.4) {
    values = [0, 1, 2, 3, 4];
  } else if (ratio <= 0.5) {
    values = [0, 1, 2, 3];
  } else if (ratio <= 0.8) {
    values = [0, 1, 2];
  }

  return Hint(text: reading.substring(0, n), values: values);
}
