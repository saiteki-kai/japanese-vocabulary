import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repositories/review_repository.dart';

import '../data/models/review.dart';
import '../utils/sm2.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc({required this.repository}) : super(ReviewInitial()) {
    on<ReviewSessionStarted>(_onSessionStarted);
    on<ReviewSessionUpdated>(_onSessionUpdated);
  }

  final ReviewRepository repository;

  final List<Review> _session = [];
  int _currentIndex = 0;

  /// Get today's reviews and start a review session
  void _onSessionStarted(_, emit) async {
    emit(ReviewLoading());

    final reviews = await repository.getTodayReviews();

    if (reviews.isNotEmpty) {
      _session.removeWhere((element) => true);
      _session.addAll(reviews);

      emit(ReviewLoaded(review: _session[0], isLast: false));
    }
  }

  /// Schedule the next date review of the Review given a quality value
  /// and returns the next word to review.
  void _onSessionUpdated(ReviewSessionUpdated event, emit) async {
    final review = SM2.schedule(event.review, event.quality);
    await repository.updateReview(review);

    if (_currentIndex < _session.length) {
      _currentIndex = _currentIndex + 1;
      final isLast = _currentIndex == _session.length - 1;

      emit(ReviewLoaded(review: _session[_currentIndex], isLast: isLast));
    }
  }
}
