import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/review_bloc.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/repositories/review_repository.dart';

import 'utils/review.dart';

void main() async {
  late ReviewBloc bloc;

  final store = await AppDatabase.instance.store;
  final box = store.box<Review>();

  setUp(() {
    bloc = ReviewBloc(repository: ReviewRepository());
    box.removeAll();
    box.put(ReviewUtils.nullDateReview);
    box.put(ReviewUtils.review1);
    box.put(ReviewUtils.review2);
  });

  tearDown(() {
    bloc.close();
    box.removeAll();
  });

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewLoaded] when ReviewRetrieved is added.',
    build: () => bloc,
    act: (bloc) => bloc.add(ReviewSessionStarted()),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(review: ReviewUtils.nullDateReview, isLast: false),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoaded, ReviewLoaded] when ReviewSessionUpdated is added.',
    build: () => bloc,
    act: (bloc) => bloc
      ..add(ReviewSessionStarted())
      ..add(ReviewSessionUpdated(ReviewUtils.review1, 4)),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(review: ReviewUtils.nullDateReview, isLast: false),
      ReviewLoaded(review: ReviewUtils.review1, isLast: true),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoaded, ReviewLoaded] when ReviewSessionUpdated is added.',
    build: () => bloc,
    act: (bloc) => bloc
      ..add(ReviewSessionStarted())
      ..add(ReviewSessionUpdated(ReviewUtils.review1, 4))
      ..add(ReviewSessionUpdated(ReviewUtils.review2, 4)),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(review: ReviewUtils.nullDateReview, isLast: false),
      ReviewLoaded(review: ReviewUtils.review1, isLast: true),
      ReviewFinished(),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewError] when ReviewSessionStarted is added and session is empty.',
    build: () => bloc,
    setUp: box.removeAll,
    act: (bloc) => bloc..add(ReviewSessionStarted()),
    expect: () => <ReviewState>[
      ReviewLoading(),
      const ReviewError(message: "Empty session, no reviews found."),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewFinished] when ReviewUpdated is added and ReviewRetrieved is not added previously.',
    build: () => bloc,
    act: (bloc) => bloc.add(ReviewSessionUpdated(ReviewUtils.review1, 4)),
    expect: () => <ReviewState>[ReviewFinished()],
  );
}
