class Hint {
  /// Creates a [Hint] with a [text] to show and the available quality [values].
  const Hint({
    required this.text,
    required this.n,
    required this.max,
    required this.values,
  })  : assert(n >= 0),
        assert(n <= max);

  /// Hint message to show.
  final String text;

  final int n;

  final int max;

  /// Available quality values after this hint is given.
  final List<int> values;

  Hint.empty()
      : text = "",
        n = 0,
        max = 0,
        values = [],
        super();

  Hint.fromReading(String reading)
      : text = "",
        n = 0,
        max = reading.length,
        values = const [0, 1, 2, 3, 4, 5],
        super();

  /// Returns a [Hint] of a given word [reading] showing progressively more
  /// characters.
  Hint getNextReadingHint(String reading) {
    final n = this.n + 1;

    final length = reading.length;
    final ratio = n / length;

    // TODO: handle exceptions
    if (n > length || length == 1) {
      return Hint.empty();
    }

    List<int> values = [];

    if (ratio <= 0.4) {
      values = [0, 1, 2, 3, 4];
    } else if (ratio <= 0.5) {
      values = [0, 1, 2, 3];
    } else if (ratio <= 0.8) {
      values = [0, 1, 2];
    }

    return Hint(
      text: reading.substring(0, n),
      n: n,
      max: reading.length,
      values: values,
    );
  }
}
