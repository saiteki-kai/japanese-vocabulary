class Hint {
  /// Creates a [Hint] with a [text] to show, the [max] number of hints, the
  /// current hint [n] and the available quality [values].
  const Hint({
    required this.text,
    required this.n,
    required this.max,
    required this.values,
  })  : assert(n >= 0),
        assert(n <= max);

  /// Hint message to show.
  final String text;

  /// Number of the hint.
  final int n;

  /// Max number of hints.
  final int max;

  /// Available quality values after this hint is given.
  final List<int> values;

  /// Creates a [Hint] with default values.
  Hint.empty()
      : text = "",
        n = 0,
        max = 0,
        values = [0],
        super();

  /// Creates a [Hint] given a reading by initializing the [max] with its
  /// length and all available [values].
  Hint.fromReading(String reading)
      : text = "",
        n = 0,
        max = reading.length,
        values = const [0, 1, 2, 3, 4, 5],
        super();

  /// Returns a [Hint] of a given word [reading] showing progressively more
  /// characters.
  ///
  /// Returns [Hint.empty] if the length of [reading] equals 1 or is less than
  /// or equal to [n].
  Hint getNextReadingHint(String reading) {
    final n = this.n + 1;

    final length = reading.length;
    final ratio = n / length;

    // TODO: handle exceptions
    if (n > length || length == 1) {
      return Hint.empty();
    }

    List<int> values = [0];

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
