part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  const ReviewLoaded({required this.review, required this.isLast});

  final Review review;
  final bool isLast;

  @override
  List<Object> get props => [review, isLast];
}

class ReviewError extends ReviewState {
  const ReviewError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class ReviewFinished extends ReviewState {}
