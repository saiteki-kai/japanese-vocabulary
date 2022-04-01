import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/repositories/review_repository.dart';

void main() async {
  final store = await AppDatabase.instance.store;

  Review createReviewByDate(DateTime? date) {
    return Review(
      id: 0,
      ef: 2.5,
      interval: 0,
      repetition: 0,
      correctAnswers: 0,
      incorrectAnswers: 0,
      nextDate: date,
      type: "meaning",
    );
  }

  final nullDateReview = createReviewByDate(null);
  final review1 = createReviewByDate(DateTime(DateTime.now().year - 1));
  final review2 = createReviewByDate(DateTime(DateTime.now().year + 1));

  final box = store.box<Review>();
  final repo = ReviewRepository();

  setUp(() {
    box.put(nullDateReview);
    box.put(review1);
    box.put(review2);
  });

  tearDown(() {
    store.box<Review>().removeAll();
  });

  test("get all reviews", () async {
    final reviews = await repo.getAllReviews();
    expect(reviews.length, 3);
  });

  test("get today's reviews", () async {
    final reviews = await repo.getTodayReviews();
    expect(reviews.length, 1);
    expect(reviews[0].nextDate?.millisecondsSinceEpoch ?? double.infinity,
        lessThan(DateTime.now().millisecondsSinceEpoch));
  });
}
