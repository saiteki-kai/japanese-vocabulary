import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repositories/word_repository.dart';
import '../data/models/word.dart';

part 'word_event.dart';
part 'word_state.dart';

/// This [WordBloc] manages the business logic.
class WordBloc extends Bloc<WordEvent, WordState> {
  WordBloc({required this.repository}) : super(WordInitial()) {
    on<WordRetrieved>(_onRetrieved);
    on<AddWordEvent>(_onAddWordEvent);
    on<GetWordEvent>(_onGetWord);
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
      await repository.addWord(event.word);
      emit(WordAdded());
    }
  }

  void _onRetrieved(WordRetrieved _, Emitter<WordState> emit) async {
    emit(WordLoading());
    final words = await repository.getWords();
    emit(WordsLoaded(words: words));
  }

  void _onGetWord(GetWordEvent event, Emitter<WordState> emit) async {
    emit(WordLoading());

    final word = await repository.getWord(event.wordId);
    if (word != null) {
      emit(WordLoaded(word: word));
    } else {
      emit(const WordError(message: "word not found!"));
    }
  }
}
