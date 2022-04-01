import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repositories/review_repository.dart';

import '../data/models/review.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository repository;

  ReviewBloc({required this.repository}) : super(ReviewInitial()) {
    on<ReviewRetrieved>(_onRetrieved);
  }

  void _onRetrieved(event, emit) async {
    emit(ReviewLoading());

    final reviews = await repository.getTodayReviews();

    emit(ReviewLoaded(reviews));
  }
}
