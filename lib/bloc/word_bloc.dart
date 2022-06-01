import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repositories/word_repository.dart';
import '../data/models/word.dart';
import '../data/models/sort_option.dart';

part 'word_event.dart';
part 'word_state.dart';

/// This [WordBloc] manages the business logic.
class WordBloc extends Bloc<WordEvent, WordState> {
  WordBloc({required this.repository}) : super(WordInitial()) {
    on<WordsRetrieved>(_onRetrieved);
    on<WordAdded>(_onWordAdded);
    on<WordRetrieved>(_onGetWord);
  }

  /// The instance of the repository
  final WordRepository repository;

  void _onWordAdded(WordAdded event, Emitter<WordState> emit) async {
    /// If one of the text fields is empty, the app will return to the initial state of the insertion.
    ///
    /// otherwise the app will go to the word added state, closing the insertion page.
    final word = event.word;
    if (word.text.isEmpty || word.meaning.isEmpty || word.reading.isEmpty) {
      emit(WordInitial());
    } else {
      final state = this.state;
      if (state is WordsLoaded) {
        await repository.addWord(word);
        emit(WordsLoaded(words: [...state.words, word]));
      }
      if (state is WordLoaded) {
        await repository.addWord(word);
        emit(WordLoaded(word: word));
      }
    }
  }

  void _onRetrieved(WordsRetrieved event, Emitter<WordState> emit) async {
    /// Returns all the words if 'search' is empty, otherwise it returns
    /// just the words with 'search' as substring of their text.
    emit(WordLoading());
    final words = await repository.getWords(sort: event.sort);

    if (event.search.isNotEmpty) {
      // We are searching something
      final searchedWord = words
          .where((word) => word.text.toLowerCase().contains(event.search))
          .toList();

      emit(WordsLoaded(words: searchedWord));
    } else {
      // We are not searching something so we return the whole list
      emit(WordsLoaded(words: words));
    }
  }

  void _onGetWord(WordRetrieved event, Emitter<WordState> emit) async {
    /// Returns the word with the specified id.
    emit(WordLoading());

    final word = await repository.getWord(event.wordId);
    if (word != null) {
      emit(WordLoaded(word: word));
    } else {
      emit(const WordError(message: "word not found!"));
    }
  }
}
