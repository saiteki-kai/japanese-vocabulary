import '../data/models/sentence.dart';
import '../data/models/word.dart';

/// An abstract class that has the general properties for a [hint].
abstract class Hint {
  /// Creates a [Hint] with the [max] number of hints, the number of the
  /// current hint [n] and the available quality [values].
  const Hint({
    required this.n,
    required this.max,
    required this.values,
  })  : assert(n >= 0),
        assert(n <= max);

  /// Number of the hint.
  final int n;

  /// Max number of hints.
  final int max;

  /// Available quality values after this hint is given.
  final List<int> values;

  /// Creates a [Hint] with default values.
  Hint.empty()
      : n = 0,
        max = 0,
        values = [0, 1, 2, 3, 4, 5],
        super();

  /// Create a [Hint] from a [word].
  Hint.fromWord(Word word, this.n, this.max, this.values);

  /// Return the next [Hint] given a [word].
  Hint getNextHint(Word word);
}

/// A class that represents the hint given for the meaning of a word.
class MeaningHint extends Hint {
  /// The list of sentences to be displayed.
  final List<Sentence> currSentences;

  /// Creates a [MeaningHint] which extends the [Hint] class, with
  /// the [currSentences] to return as hints.
  MeaningHint({
    required this.currSentences,
    required int n,
    required int max,
    required List<int> values,
  }) : super(n: n, max: max, values: values);

  /// Creates a [MeaningHint] with default values.
  MeaningHint.empty()
      : currSentences = [],
        super.empty();

  /// Creates a [MeaningHint] from [word].
  MeaningHint.fromWord(Word word)
      : currSentences = [],
        super(
          n: 0,
          max: word.sentences.length,
          values: const [0, 1, 2, 3, 4, 5],
        );

  /// Returns the next [Hint] given a [word].
  ///
  /// Returns [MeaningHint.empty] when the [word]
  /// has no sentences to display.
  @override
  Hint getNextHint(Word word) {
    if (word.sentences.isEmpty) {
      return MeaningHint.empty();
    }

    // add the next sentence!
    currSentences.add(word.sentences[this.n]);

    final n = this.n + 1;
    final length = word.sentences.length;

    if (n > length) {
      return MeaningHint.empty();
    }

    // update values
    List<int> newValues = [];
    if (n == 1) {
      newValues = [0, 1, 2, 3, 4];
    } else if (n > 1 && n <= length) {
      newValues = [0, 1, 2, 3];
    }

    return MeaningHint(
      n: n,
      max: length,
      values: newValues,
      currSentences: currSentences,
    );
  }
}

/// A class that represents the hint given for the reading of a word.
class ReadingHint extends Hint {
  /// the hint as a string of text.
  final String text;

  /// Creates a [ReadingHint] which extends the [Hint] class,
  /// with a hint [text].
  ReadingHint({
    required this.text,
    required int n,
    required int max,
    required List<int> values,
  }) : super(n: n, max: max, values: values);

  /// Creates a [ReadingHint] with default values.
  ReadingHint.empty()
      : text = "",
        super.empty();

  /// Creates a [ReadingHint] from [word].
  ReadingHint.fromWord(Word word)
      : text = "",
        super(
          n: 0,
          max: word.reading.length,
          values: const [0, 1, 2, 3, 4, 5],
        );

  /// Returns the next [Hint] given a [word].
  ///
  /// The length of the reading of the [word] define
  /// the quality values to disable. When all the hints
  /// are requested the only value available is 0.
  ///
  /// If the reading is empty or one character long
  /// returns a [ReadingHint.empty].
  @override
  Hint getNextHint(Word word) {
    final reading = word.reading;

    if (reading.isEmpty) {
      return ReadingHint.empty();
    }

    final n = this.n + 1;
    final length = reading.length;
    final ratio = n / length;

    if (n > length || length == 1) {
      return ReadingHint(text: "", n: 0, max: 0, values: [0]);
    }

    List<int> values = [0];

    if (ratio <= 0.4) {
      values = [0, 1, 2, 3, 4];
    } else if (ratio <= 0.5) {
      values = [0, 1, 2, 3];
    } else if (ratio <= 0.8) {
      values = [0, 1, 2];
    }

    return ReadingHint(
      text: reading.substring(0, n),
      n: n,
      max: length,
      values: values,
    );
  }
}
