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

    box.removeAll();
    box.put(nullDateReview);
    box.put(review1);
    box.put(review2);
  });

  tearDown(() async {
    box.removeAll();
    store.close();
    await AppDatabase.instance.deleteDatabase();
  });

  test("get all reviews", () async {
    List<Review> reviews = await repo.getReviews();
    expect(reviews.length, 3);

    box.removeAll();
    reviews = await repo.getReviews();
    expect(reviews.length, 0);
  });

  test("get today's reviews", () async {
    List<Review> reviews = await repo.getTodayReviews();
    expect(reviews.length, 2);

    final notNullReview = reviews.lastWhere((e) => e.nextDate != null);
    expect(notNullReview.nextDate?.millisecondsSinceEpoch ?? double.infinity,
        lessThan(DateTime.now().millisecondsSinceEpoch));

    box.removeAll();
    reviews = await repo.getReviews();
    expect(reviews.length, 0);
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
      expect(box.getAll().length, 4);
    });
  });
}
