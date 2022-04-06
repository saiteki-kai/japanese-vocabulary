part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

class ReviewInitial extends ReviewState {}

/// A [ReviewState] that waits for the review session to start.
class ReviewLoading extends ReviewState {}

/// A [ReviewState] that contains the [review] to be reviewed.
class ReviewLoaded extends ReviewState {
  /// Creates a [ReviewState] with [review] to return and a boolean value
  /// [isLast] to specify whether [review] is the last one in the session.
  const ReviewLoaded({required this.review, required this.isLast});

  /// The next [review] in the session.
  final Review review;

  /// A boolean to specify whether [review] is the last one in the session.
  final bool isLast;

  @override
  List<Object> get props => [review, isLast];
}

/// A [ReviewState] to handle errors.
class ReviewError extends ReviewState {
  /// Creates a [ReviewState] to handle errors. A [message] is required to
  /// specify information about the error.
  const ReviewError({required this.message});

  /// A message to specify information about the error.
  final String message;

  @override
  List<Object> get props => [message];
}

/// A [ReviewState] to indicate when the session has ended.
class ReviewFinished extends ReviewState {}
