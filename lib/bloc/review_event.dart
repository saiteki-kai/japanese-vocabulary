part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

/// Start a review session and return the first review.
class ReviewSessionStarted extends ReviewEvent {}

/// Update a review and returns the next review in the session.
class ReviewSessionUpdated extends ReviewEvent {
  /// Creates a [ReviewEvent] with a [review] to update based on the [quality].
  const ReviewSessionUpdated(this.review, this.quality);

  /// The review to update.
  final Review review;

  /// The quality value selected by the user.
  final int quality;

  @override
  List<Object> get props => [review, quality];
}
