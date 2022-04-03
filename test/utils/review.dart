import 'package:japanese_vocabulary/data/models/review.dart';

class ReviewUtils {
  static Review createReviewByDate(DateTime? date) {
    return Review(
      ef: 2.5,
      interval: 0,
      repetition: 0,
      correctAnswers: 0,
      incorrectAnswers: 0,
      nextDate: date,
      type: "meaning",
    );
  }

  static final nullDateReview = createReviewByDate(null);
  static final review1 = createReviewByDate(DateTime(DateTime.now().year - 1));
  static final review2 = createReviewByDate(DateTime(DateTime.now().year + 1));
}
