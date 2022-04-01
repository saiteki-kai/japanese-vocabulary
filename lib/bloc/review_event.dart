part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class ReviewRetrieved extends ReviewEvent {}

class ReviewUpdated extends ReviewEvent {
  final Review review;
  final int quality;

  const ReviewUpdated(this.review, this.quality);

  @override
  List<Object> get props => [review, quality];
}
