import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/review_bloc.dart';
import 'package:japanese_vocabulary/data/repositories/review_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../utils/mocks.dart';
import '../utils/params.dart';

void main() async {
  late ReviewBloc bloc;
  late ReviewRepository repo;

  void setUpEmpty() {
    when(repo.getTodayReviews).thenAnswer((_) async => []);
  }

  void setUpWithReviews() {
    when(repo.getTodayReviews).thenAnswer((_) async {
      return [meaningReviewWithWord, readingReviewWithWord];
    });
  }

  setUp(() {
    repo = MockReviewRepository();
    bloc = ReviewBloc(repository: repo);
    registerFallbackValue(FakeReview());

    when(() => repo.updateReview(any())).thenAnswer((x) async {
      return x.positionalArguments[0].id;
    });
  });

  tearDown(() {
    bloc.close();
    reset(repo);
  });

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewLoaded] when ReviewSessionStarted is added.',
    build: () => bloc,
    setUp: setUpWithReviews,
    act: (bloc) => bloc.add(ReviewSessionStarted()),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(
        review: meaningReviewWithWord,
        current: 1,
        total: 2,
        isLast: false,
      ),
    ],
    verify: (_) {
      verify(() => repo.getTodayReviews()).called(1);
      verifyNever(() => repo.updateReview(any()));
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoaded, ReviewLoaded] when [ReviewSessionStarted, ReviewSessionUpdated] are added.',
    build: () => bloc,
    setUp: setUpWithReviews,
    act: (bloc) => bloc
      ..add(ReviewSessionStarted())
      ..add(ReviewSessionUpdated(review: meaningReviewWithWord, quality: 4)),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(
        review: meaningReviewWithWord,
        current: 1,
        total: 2,
        isLast: false,
      ),
      ReviewLoaded(
        review: readingReviewWithWord,
        current: 2,
        total: 2,
        isLast: true,
      ),
    ],
    verify: (_) {
      verify(() => repo.getTodayReviews()).called(1);
      verify(() => repo.updateReview(any())).called(1);
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoaded, ReviewLoaded, ReviewLoaded] when ReviewSessionUpdated is added twice and the session is finished.',
    build: () => bloc,
    setUp: setUpWithReviews,
    act: (bloc) => bloc
      ..add(ReviewSessionStarted())
      ..add(ReviewSessionUpdated(review: meaningReviewWithWord, quality: 4))
      ..add(ReviewSessionUpdated(review: readingReviewWithWord, quality: 4)),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(
        review: meaningReviewWithWord,
        current: 1,
        total: 2,
        isLast: false,
      ),
      ReviewLoaded(
        review: readingReviewWithWord,
        current: 2,
        total: 2,
        isLast: true,
      ),
      ReviewFinished(),
    ],
    verify: (_) {
      verify(() => repo.getTodayReviews()).called(1);
      verify(() => repo.updateReview(any())).called(2);
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewEmpty] when ReviewSessionStarted is added and session is empty.',
    build: () => bloc,
    setUp: setUpEmpty,
    act: (bloc) => bloc..add(ReviewSessionStarted()),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewEmpty(),
    ],
    verify: (_) {
      verify(() => repo.getTodayReviews()).called(1);
      verifyNever(() => repo.updateReview(any()));
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewFinished] when ReviewUpdated is added and ReviewSessionStarted is not added previously.',
    build: () => bloc,
    setUp: setUpWithReviews,
    act: (bloc) => bloc.add(
      ReviewSessionUpdated(review: readingReviewWithWord, quality: 4),
    ),
    expect: () => <ReviewState>[ReviewFinished()],
    verify: (_) {
      verify(() => repo.updateReview(any())).called(1);
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewError] when the review have no valid word.',
    build: () => bloc,
    setUp: () {
      when(repo.getTodayReviews).thenAnswer((_) async {
        return [review1];
      });
    },
    act: (bloc) => bloc.add(ReviewSessionStarted()),
    expect: () => <ReviewState>[
      ReviewLoading(),
      const ReviewError(message: 'missing word'),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewLoaded, ReviewError] when the review have no valid word.',
    build: () => bloc,
    setUp: () {
      when(repo.getTodayReviews).thenAnswer((_) async {
        return [readingReviewWithWord, review1];
      });
    },
    act: (bloc) => bloc
      ..add(ReviewSessionStarted())
      ..add(ReviewSessionUpdated(review: readingReviewWithWord, quality: 4)),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(
        review: readingReviewWithWord,
        current: 1,
        total: 2,
        isLast: false,
      ),
      const ReviewError(message: 'missing word'),
    ],
    verify: (bloc) {
      verify(repo.getTodayReviews).called(1);
    },
  );
}
