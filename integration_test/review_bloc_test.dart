import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/review_bloc.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/repositories/review_repository.dart';
import 'package:objectbox/objectbox.dart';

import '../test/utils/db.dart';
import '../test/utils/params.dart';

void main() async {
  late Store store;
  late ReviewRepository repo;
  late ReviewBloc bloc;

  setUp(() async {
    store = await AppDatabase.instance.store;
    repo = ReviewRepository(box: Future.value(store.box<Review>()));
    bloc = ReviewBloc(repository: repo);
  });

  tearDown(() async {
    bloc.close();
    store.close();
    await AppDatabase.instance.deleteDatabase();
  });

  setUpWithReviews() {
    repo.updateReview(readingReviewWithWord);
    repo.updateReview(review1);
    repo.updateReview(review2);
  }

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewLoaded] when ReviewRetrieved is added.',
    build: () => bloc,
    setUp: setUpWithReviews,
    act: (bloc) => bloc.add(ReviewSessionStarted()),
    expect: () {
      final r = addReviewExpectedIds(readingReviewWithWord, 1, 1);

      return <ReviewState>[
        ReviewLoading(),
        ReviewLoaded(review: r, isLast: false),
      ];
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoaded, ReviewLoaded] when ReviewSessionUpdated is added.',
    build: () => bloc,
    setUp: setUpWithReviews,
    act: (bloc) => bloc
      ..add(ReviewSessionStarted())
      ..add(ReviewSessionUpdated(review: review1, quality: 4)),
    expect: () {
      final r1 = addReviewExpectedIds(readingReviewWithWord, 1, 1);
      final r2 = addReviewExpectedIds(review1, 2, null);

      return <ReviewState>[
        ReviewLoading(),
        ReviewLoaded(review: r1, isLast: false),
        ReviewLoaded(review: r2, isLast: true),
      ];
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoaded, ReviewLoaded, ReviewFinished] when ReviewSessionUpdated is added.',
    build: () => bloc,
    setUp: setUpWithReviews,
    act: (bloc) => bloc
      ..add(ReviewSessionStarted())
      ..add(ReviewSessionUpdated(review: review1, quality: 4))
      ..add(ReviewSessionUpdated(review: review2, quality: 4)),
    expect: () {
      final r1 = addReviewExpectedIds(readingReviewWithWord, 1, 1);
      final r2 = addReviewExpectedIds(review1, 2, null);

      return <ReviewState>[
        ReviewLoading(),
        ReviewLoaded(review: r1, isLast: false),
        ReviewLoaded(review: r2, isLast: true),
        ReviewFinished(),
      ];
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewError] when ReviewSessionStarted is added and session is empty.',
    build: () => bloc,
    act: (bloc) => bloc..add(ReviewSessionStarted()),
    expect: () => <ReviewState>[
      ReviewLoading(),
      const ReviewError(message: "Empty session, no reviews found."),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewFinished] when ReviewUpdated is added and ReviewRetrieved is not added previously.',
    build: () => bloc,
    setUp: setUpWithReviews,
    act: (bloc) =>
        bloc..add(ReviewSessionUpdated(review: review1..id = 1, quality: 4)),
    expect: () => <ReviewState>[
      ReviewFinished(),
    ],
  );
}
