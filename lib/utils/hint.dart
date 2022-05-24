import '../data/models/sentence.dart';
import '../data/models/word.dart';

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

  Hint.fromWord(Word word, this.n, this.max, this.values);

  Hint getNextHint(Word word);
}

class MeaningHint extends Hint {
  final List<Sentence> currSentences;

  MeaningHint(
      {required this.currSentences,
      required int n,
      required int max,
      required List<int> values})
      : super(n: n, max: max, values: values);

  MeaningHint.empty()
      : currSentences = [],
        super.empty();

  MeaningHint.fromWord(Word word)
      : currSentences = [],
        super(
          n: 0,
          max: word.sentences.length,
          values: const [0, 1, 2, 3, 4, 5],
        );

  @override
  Hint getNextHint(Word word) {
    if (word.sentences.isEmpty) { return MeaningHint.empty(); }

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

class ReadingHint extends Hint {
  final String text;

  ReadingHint(
      {required this.text,
      required int n,
      required int max,
      required List<int> values})
      : super(n: n, max: max, values: values);

  ReadingHint.empty()
      : text = "",
        super.empty();

  ReadingHint.fromWord(Word word)
      : text = "",
        super(
          n: 0,
          max: word.reading.length,
          values: const [0, 1, 2, 3, 4, 5],
        );

  @override
  Hint getNextHint(Word word) {
    final reading = word.reading;

    if (reading.isEmpty) { return ReadingHint.empty(); }

    final n = this.n + 1;
    final length = reading.length;
    final ratio = n / length;

    if (n > length || length == 1) {
      return ReadingHint.empty();
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
