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
    expect(reviews.length, 2);

    final notNullReview = reviews.lastWhere((e) => e.nextDate != null);
    expect(notNullReview.nextDate?.millisecondsSinceEpoch ?? double.infinity,
        lessThan(DateTime.now().millisecondsSinceEpoch));
  });

  group("update a review", () {
    test("review already present in the database", () async {
      List<Review> reviews = box.getAll();
      Review r = reviews[0];

      final id1 = await repo.updateReview(r);
      expect(id1, equals(r.id));
      expect(reviews.length, 3);

      final updatedReview = r.copyWith(ef: 2.3);

      final id2 = await repo.updateReview(updatedReview);
      expect(id2, equals(r.id));

      expect(r.ef, 2.5);
      expect(updatedReview.ef, 2.3);

      reviews = box.getAll();
      expect(reviews.length, 3);

      // refetch instance
      reviews = box.getAll();
      r = reviews[0];
      expect(r.ef, 2.3);
      expect(reviews.length, 3);
    });

    test("review not present in the database", () async {
      final newReview = createReviewByDate(null);
      final id3 = await repo.updateReview(newReview);
      expect(id3, equals(4));
    });
  });
}
