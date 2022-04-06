import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/word.dart';

class ReviewUtils {
  static Review createReviewByDate(
    DateTime? date, {
    Word? word,
    String type = "meaning",
  }) {
    final review = Review(
      ef: 2.5,
      interval: 0,
      repetition: 0,
      correctAnswers: 0,
      incorrectAnswers: 0,
      nextDate: date,
      type: type,
    );

    if (word != null) {
      review.word.target = word;
    }

    return review;
  }

  static final nullDateReview = createReviewByDate(null);
  static final review1 = createReviewByDate(DateTime(DateTime.now().year - 1));
  static final review2 = createReviewByDate(DateTime(DateTime.now().year + 1));
  static final readingReviewWithWord = createReviewByDate(
    null,
    type: "reading",
    word: Word(
      jlpt: 3,
      meaning: "word; phrase; expression; term",
      pos: "noun",
      reading: "ことば",
      text: "言葉",
      id: 0,
    ),
  );
  static final meaningReviewWithWord = createReviewByDate(
    null,
    type: "meaning",
    word: Word(
      jlpt: 3,
      meaning: "word; phrase; expression; term",
      pos: "noun",
      reading: "ことば",
      text: "言葉",
      id: 0,
    ),
  );
}
