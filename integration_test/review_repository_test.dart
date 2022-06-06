import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/repositories/review_repository.dart';
import 'package:japanese_vocabulary/objectbox.g.dart';

import '../test/utils/params.dart';

void main() async {
  late Store store;
  late Box<Review> box;
  late ReviewRepository repo;

  setUp(() async {
    store = await AppDatabase.instance.store;
    box = store.box<Review>();
    repo = ReviewRepository(box: Future.value(box));
  });

  tearDown(() async {
    box.removeAll();
    store.close();
    await AppDatabase.instance.deleteDatabase();
  });

  setUpWithReviews() {
    box.put(readingReviewWithWord);
    box.put(review1);
    box.put(review2);
  }

  test("get all reviews", () async {
    setUpWithReviews();
    List<Review> reviews = await repo.getReviews();
    expect(reviews.length, 3);

    box.removeAll();
    reviews = await repo.getReviews();
    expect(reviews.length, 0);
  });

  test("check number of today's reviews", () async {
    setUpWithReviews();

    List<Review> reviews = await repo.getTodayReviews();
    expect(reviews.length, 2);

    final notNullReview = reviews.lastWhere((e) => e.nextDate != null);
    expect(notNullReview.nextDate?.millisecondsSinceEpoch ?? double.infinity,
        lessThan(DateTime.now().millisecondsSinceEpoch));

    box.removeAll();
    reviews = await repo.getReviews();
    expect(reviews.length, 0);
  });

  test("check today's reviews if no reviews exists", () async {
    // if 0 reviews exist than should be that today reviews.length == 0
    box.removeAll();
    final List<Review> reviews = await repo.getReviews();
    expect(reviews.length, 0);

    final List<Review> todayReviews = await repo.getTodayReviews();
    expect(todayReviews.length, equals(0));
  });

  test("check today's reviews if some reviews exists", () async {
    // if n reviews exist than should be that 0 <= todayreviews.length <= n
    final List<Review> reviews = await repo.getReviews();
    expect(reviews.length, greaterThan(0));

    final List<Review> todayReviews = await repo.getTodayReviews();
    expect(todayReviews.length, greaterThanOrEqualTo(0));
    expect(todayReviews.length, lessThanOrEqualTo(reviews.length));
  });

  group("update a review", () {
    test("check word relationship", () async {
      Review review = readingReviewWithWord;
      final word = readingReviewWithWord.word.target?..id = 1;

      // add review with word
      final id1 = await repo.updateReview(review);

      // assign id given by the database
      review.id = id1;

      List<Review> reviews = await repo.getReviews();
      expect(reviews, equals([review]));
      expect(reviews[0].word.target, equals(word));

      // make update the ef field
      review = review.copyWith(ef: 2.0);

      // update the review
      final id2 = await repo.updateReview(review);
      expect(id2, equals(id1));

      // check the word
      reviews = await repo.getReviews();
      expect(reviews, equals([review]));
      expect(reviews[0].word.target, equals(word));
    });

    test("review already present in the database", () async {
      setUpWithReviews();

      List<Review> reviews = box.getAll();
      Review r = reviews[0];
      final associatedWord = r.word.target;

      final id1 = await repo.updateReview(r);
      expect(id1, equals(r.id));
      expect(reviews.length, 3);

      final updatedReview = r.copyWith(ef: 2.3)..word.target = associatedWord;

      final id2 = await repo.updateReview(updatedReview);
      expect(id2, equals(r.id));

      expect(r.ef, 2.5);
      expect(updatedReview.ef, 2.3);

      expect(updatedReview.word.target, equals(associatedWord));

      reviews = box.getAll();
      expect(reviews.length, 3);

      // refetch instance
      reviews = box.getAll();
      r = reviews[0];
      expect(r.ef, 2.3);
      expect(r.word.target, equals(associatedWord));
      expect(reviews.length, 3);
    });

    test("review not present in the database", () async {
      setUpWithReviews();

      final newReview = createReviewByDate(null);
      final id3 = await repo.updateReview(newReview);

      expect(id3, equals(4));
      expect(box.getAll().length, 4);
    });
  });
}
