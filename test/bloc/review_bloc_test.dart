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
    when(repo.getReviews).thenAnswer((_) async => []);
    when(repo.getTodayReviews).thenAnswer((_) async => []);
  }

  void setUpWithReviews() {
    when(repo.getReviews).thenAnswer((_) async {
      return [meaningReviewWithWord, review1, review2];
    });
    when(repo.getTodayReviews).thenAnswer((_) async {
      return [meaningReviewWithWord, review1];
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
      ReviewLoaded(review: meaningReviewWithWord, isLast: false),
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
      ..add(ReviewSessionUpdated(review: review1, quality: 4)),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(review: meaningReviewWithWord, isLast: false),
      ReviewLoaded(review: review1, isLast: true),
    ],
    verify: (_) {
      verify(() => repo.getTodayReviews()).called(1);
      verify(() => repo.updateReview(any())).called(1);
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoaded, ReviewLoaded, ReviewLoaded, ReviewFinished] when ReviewSessionUpdated is added twice and the session is finished.',
    build: () => bloc,
    setUp: setUpWithReviews,
    act: (bloc) => bloc
      ..add(ReviewSessionStarted())
      ..add(ReviewSessionUpdated(review: review1, quality: 4))
      ..add(ReviewSessionUpdated(review: review2, quality: 4)),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(review: meaningReviewWithWord, isLast: false),
      ReviewLoaded(review: review1, isLast: true),
      ReviewFinished(),
    ],
    verify: (_) {
      verify(() => repo.getTodayReviews()).called(1);
      verify(() => repo.updateReview(any())).called(2);
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewError] when ReviewSessionStarted is added and session is empty.',
    build: () => bloc,
    setUp: setUpEmpty,
    act: (bloc) => bloc..add(ReviewSessionStarted()),
    expect: () => <ReviewState>[
      ReviewLoading(),
      const ReviewError(message: "Empty session, no reviews found."),
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
      ReviewSessionUpdated(review: review1, quality: 4),
    ),
    expect: () => <ReviewState>[ReviewFinished()],
    verify: (_) {
      verify(() => repo.updateReview(any())).called(1);
    },
  );
}
