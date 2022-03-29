import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:japanese_vocabulary/data/repositories/review_repository.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository repository;

  ReviewBloc({required this.repository}) : super(ReviewInitial()) {
    on<ReviewEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
