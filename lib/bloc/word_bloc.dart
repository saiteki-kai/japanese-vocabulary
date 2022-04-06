import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repositories/word_repository.dart';
import '../data/models/word.dart';

part 'word_event.dart';
part 'word_state.dart';

/// This [WordBloc] manages the business logic.
class WordBloc extends Bloc<WordEvent, WordState> {
  WordBloc({required this.repository}) : super(WordInitial()) {
    on<AddWordEvent>(_onAddWordEvent);
    on<WordRetrived>(_onRetrieved);
  }

  /// The instance of the repository
  final WordRepository repository;

  void _onAddWordEvent(AddWordEvent event, Emitter<WordState> emit) async {
    /// If one of the text fields is empty, the app will return to the initial state of the insertion
    ///
    /// otherwise the app will go to the word added state, closing the insertion page
    if (event.word.text.isEmpty ||
        event.word.meaning.isEmpty ||
        event.word.reading.isEmpty) {
      emit(WordInitial());
    } else {
      final added = await repository.addWord(event.word);
      emit(WordAdded());
    }
  }

  void _onRetrieved(WordRetrived event, emit) async {
    emit(WordLoading());
    final words = await repository.getWords();
    emit(WordLoaded(words));
  }
}
