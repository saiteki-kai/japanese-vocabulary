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
  });

  tearDown(() {
    bloc.close();
    box.removeAll();
  });

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoading, ReviewLoaded] when ReviewRetrieved is added.',
    build: () => bloc,
    act: (bloc) => bloc.add(ReviewRetrieved()),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(review: ReviewUtils.nullDateReview, isLast: false),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoaded] when ReviewUpdated is added.',
    build: () => bloc,
    act: (bloc) => bloc
      ..add(ReviewRetrieved())
      ..add(ReviewUpdated(ReviewUtils.review1, 4)),
    expect: () => <ReviewState>[
      ReviewLoading(),
      ReviewLoaded(review: ReviewUtils.nullDateReview, isLast: false),
      ReviewLoaded(review: ReviewUtils.review1, isLast: true),
    ],
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [] when ReviewUpdated is added and ReviewRetrieved is not added previously.',
    build: () => bloc,
    act: (bloc) => bloc.add(ReviewUpdated(ReviewUtils.review1, 4)),
    expect: () => <ReviewState>[],
  );
}
