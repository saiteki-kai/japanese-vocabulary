import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repositories/word_repository.dart';
import '../data/models/word.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final WordRepository repository;

  WordBloc({required this.repository}) : super(WordInitial()) {
    on<WordRetrived>(_onRetrived);
  }
  _onRetrived(WordRetrived event, emit) async {
    emit(WordLoading());
    final words = await repository.getWords();
    emit(WordLoaded(words));
  }
}
