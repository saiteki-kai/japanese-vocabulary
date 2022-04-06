import '../data/models/review.dart';

/// An implementation of the SuperMemo 2 spaced repetition algorithm.
///
// https://www.supermemo.com/en/archives1990-2015/english/ol/sm2
class SM2 {
  /// Schedules a [review] with a new date based on the [quality] value.
  ///
  /// Throws a [FormatException] if the quality value is out of the range [0, 5].
  /// Returns an updated [Review] with the values obtained by the algorithm.
  static Review schedule(Review review, int quality) {
    if (quality > 5 || quality < 0) {
      throw const FormatException("The quality must be in the range [0, 5].");
    }

    double ef = review.ef;
    int repetition = review.repetition;
    int interval = review.interval;

    int corrects = review.correctAnswers;
    int incorrects = review.incorrectAnswers;

    if (quality >= 3) {
      if (repetition == 0) {
        interval = 1;
        repetition = 1;
      } else if (repetition == 1) {
        interval = 6;
        repetition = 2;
      } else {
        interval = (interval * ef).round();
        repetition = repetition + 1;
      }

      corrects = corrects + 1;
    } else {
      repetition = 0;
      interval = 1;

      incorrects = incorrects + 1;
    }

    ef = ef + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));

    if (ef < 1.3) {
      ef = 1.3;
    }

    final next = DateTime.now().add(Duration(days: interval));

    return review.copyWith(
      ef: ef,
      interval: interval,
      repetition: repetition,
      correctAnswers: corrects,
      incorrectAnswers: incorrects,
      nextDate: next,
    );
  }
}
