import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/repositories/review_repository.dart';
import 'package:japanese_vocabulary/objectbox.g.dart';
import 'package:mocktail/mocktail.dart';

import '../utils/mocks.dart';
import '../utils/params.dart';

void main() async {
  late Store store;
  late ReviewRepository repo;
  late Box<Review> box;

  final allReviews = [nullDateReview, review1, review2];
  final todayReviews = [nullDateReview, review1];

  setUp(() {
    store = MockStore();
    box = MockReviewBox();
    when(() => store.box<Review>()).thenReturn(box);
    repo = ReviewRepository(store: Future.value(store));
    registerFallbackValue(FakeReview());
  });

  tearDown(() {
    reset(box);
  });

  test("get all reviews", () async {
    when(box.getAll).thenAnswer((_) => allReviews);

    final reviews = await repo.getReviews();
    expect(reviews, equals(allReviews));
  });

  test("get today's reviews", () async {
    final queryBuilderMock = MockQueryBuilder<Review>();
    final queryMock = MockQuery<Review>();

    when(() => box.query(any())).thenReturn(queryBuilderMock);
    when(queryBuilderMock.build).thenReturn(queryMock);
    when(queryMock.find).thenReturn(todayReviews);

    final reviews = await repo.getTodayReviews();
    expect(reviews, equals(todayReviews));

    final notNullReview = reviews.firstWhere((e) => e.nextDate != null);
    expect(
      notNullReview.nextDate!.millisecondsSinceEpoch,
      lessThan(DateTime.now().millisecondsSinceEpoch),
      reason: "The date must be less than the current one",
    );

    verify(() => box.query(any()).build().find()).called(1);
  });

  test("empty all reviews", () async {
    when(box.getAll).thenAnswer((_) => []);

    final reviews = await repo.getReviews();
    expect(reviews, equals([]));
  });

  test("empty today's reviews", () async {
    final queryBuilderMock = MockQueryBuilder<Review>();
    final queryMock = MockQuery<Review>();

    when(() => box.query(any())).thenReturn(queryBuilderMock);
    when(queryBuilderMock.build).thenReturn(queryMock);
    when(queryMock.find).thenReturn([]);

    final reviews = await repo.getTodayReviews();
    expect(reviews, equals([]));

    verify(() => box.query(any()).build().find()).called(1);
  });

  test("update a review", () async {
    when(() => box.put(any()))
        .thenAnswer((invocation) => invocation.positionalArguments[0].id);

    final review = review1..id = 111;

    // keep the same values
    final id1 = await repo.updateReview(review);
    expect(id1, equals(review.id));

    // update the ef value
    final updatedReview = review.copyWith(ef: 2.3);
    final id2 = await repo.updateReview(updatedReview);
    expect(id2, equals(review.id));

    verify(() => box.put(any())).called(2);
  });
}
