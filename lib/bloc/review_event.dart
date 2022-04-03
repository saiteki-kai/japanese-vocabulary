part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class ReviewSessionStarted extends ReviewEvent {}

class ReviewSessionUpdated extends ReviewEvent {
  const ReviewSessionUpdated(this.review, this.quality);

  final Review review;
  final int quality;

  @override
  List<Object> get props => [review, quality];
}
