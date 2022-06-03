import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/models/review.dart';
import '../data/repositories/review_repository.dart';
import '../utils/sm2.dart';

part 'review_event.dart';
part 'review_state.dart';

/// Business logic to handle a review session.
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc({required this.repository}) : super(ReviewInitial()) {
    on<ReviewSessionStarted>(_onSessionStarted);
    on<ReviewSessionUpdated>(_onSessionUpdated);
  }

  /// A [ReviewRepository] instance.
  final ReviewRepository repository;

  final List<Review> _session = [];
  int _currentIndex = 0;

  /// Starts a review session and returns the first review.
  ///
  /// Returns the [ReviewLoaded] with the first review of the session.
  /// If the session is empty returns [ReviewError].
  void _onSessionStarted(
    ReviewSessionStarted _,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    final reviews = await repository.getTodayReviews();

    if (reviews.isNotEmpty) {
      _session.removeWhere((element) => true);
      _session.addAll(reviews);

      emit(
        ReviewLoaded(
          review: _session[0],
          current: 1,
          total: _session.length,
          isLast: false,
        ),
      );
    } else {
      emit(const ReviewError(message: "Empty session, no reviews found."));
    }
  }

  /// Schedule the next date review of the [ReviewSessionUpdated.review] given
  /// a [ReviewSessionUpdated.quality] value.
  ///
  /// Returns a [ReviewLoaded] with next word to review or [ReviewFinished]
  /// if the session has ended.
  void _onSessionUpdated(
    ReviewSessionUpdated event,
    Emitter<ReviewState> emit,
  ) async {
    final review = SM2.schedule(event.review, event.quality);
    await repository.updateReview(review);

    _currentIndex = _currentIndex + 1;

    if (_currentIndex < _session.length) {
      final isLast = _currentIndex == _session.length - 1;

      emit(
        ReviewLoaded(
          review: _session[_currentIndex],
          current: _currentIndex + 1,
          total: _session.length,
          isLast: isLast,
        ),
      );
    } else {
      emit(ReviewFinished());
    }
  }
}
