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
    _currentIndex = 0;
    _session.removeWhere((_) => true);

    emit(ReviewLoading());

    final reviews = await repository.getTodayReviews();

    if (reviews.isNotEmpty) {
      _session.addAll(reviews);

      if (_validWord(emit, _session[0])) {
        emit(ReviewLoaded(
          review: _session[0],
          total: _session.length,
          isLast: false,
        ));
      }
    } else {
      emit(ReviewEmpty());
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
    print(_currentIndex);

    if (_currentIndex < _session.length) {
      final isLast = _currentIndex == _session.length - 1;

      final nextReview = _session[_currentIndex];

      if (_validWord(emit, nextReview)) {
        emit(ReviewLoaded(
          review: nextReview,
          total: _session.length,
          isLast: isLast,
        ));
      }
    } else {
      emit(ReviewFinished());
    }
  }

  _validWord(Emitter<ReviewState> emit, Review review) {
    final valid = review.word.target != null;

    if (!valid) {
      emit(const ReviewError(message: "missing word"));
    }

    return valid;
  }
}
