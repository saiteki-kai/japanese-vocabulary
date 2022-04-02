part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final Review review;
  final bool isLast;

  const ReviewLoaded({required this.review, required this.isLast});

  @override
  List<Object> get props => [review, isLast];
}
