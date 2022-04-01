import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repositories/review_repository.dart';

import '../data/models/review.dart';
import '../utils/sm2.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository repository;

  ReviewBloc({required this.repository}) : super(ReviewInitial()) {
    on<ReviewRetrieved>(_onRetrieved);
    on<ReviewUpdated>(_onUpdated);
  }

  void _onRetrieved(_, emit) async {
    emit(ReviewLoading());

    final reviews = await repository.getTodayReviews();

    emit(ReviewLoaded(reviews));
  }

  /// Schedule the next date review of the Review given a quality value
  void _onUpdated(ReviewUpdated event, __) async {
    final review = SM2.schedule(event.review, event.quality);
    await repository.updateReview(review);
  }
}
