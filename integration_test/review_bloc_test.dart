import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/review_bloc.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/repositories/review_repository.dart';
import 'package:objectbox/objectbox.dart';

import '../test/utils/params.dart';

void main() async {
  late Store store;
  late Box<Review> box;
  late ReviewBloc bloc;

  setUp(() async {
    store = await AppDatabase.instance.store;
    box = store.box<Review>();

    bloc = ReviewBloc(repository: ReviewRepository(box: Future.value(box)));

    box.removeAll();
    box.put(nullDateReview);
    box.put(review1);
    box.put(review2);
  });

  tearDown(() async {
    bloc.close();
    box.removeAll();
    store.close();
    await AppDatabase.instance.deleteDatabase();
  });

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewLoaded] when ReviewRetrieved is added.',
    build: () => bloc,
    act: (bloc) => bloc.add(ReviewSessionStarted()),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(review: nullDateReview..id = 1, isLast: false),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoaded, ReviewLoaded] when ReviewSessionUpdated is added.',
    build: () => bloc,
    act: (bloc) => bloc
      ..add(ReviewSessionStarted())
      ..add(ReviewSessionUpdated(review: review1, quality: 4)),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(review: nullDateReview..id = 1, isLast: false),
      ReviewLoaded(review: review1..id = 2, isLast: true),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoaded, ReviewLoaded] when ReviewSessionUpdated is added.',
    build: () => bloc,
    act: (bloc) => bloc
      ..add(ReviewSessionStarted())
      ..add(ReviewSessionUpdated(review: review1, quality: 4))
      ..add(ReviewSessionUpdated(review: review2, quality: 4)),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(review: nullDateReview..id = 1, isLast: false),
      ReviewLoaded(review: review1..id = 2, isLast: true),
      ReviewFinished(),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewError] when ReviewSessionStarted is added and session is empty.',
    build: () => bloc,
    setUp: () => box.removeAll(),
    act: (bloc) => bloc..add(ReviewSessionStarted()),
    expect: () => <ReviewState>[
      ReviewLoading(),
      const ReviewError(message: "Empty session, no reviews found."),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewFinished] when ReviewUpdated is added and ReviewRetrieved is not added previously.',
    build: () => bloc,
    act: (bloc) => bloc.add(
      ReviewSessionUpdated(review: review1..id = 1, quality: 4),
    ),
    expect: () => <ReviewState>[ReviewFinished()],
  );
}
