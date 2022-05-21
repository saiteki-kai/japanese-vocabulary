import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repositories/word_repository.dart';
import '../data/models/word.dart';

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
    /// If one of the text fields is empty, the app will return to the initial state of the insertion
    ///
    /// otherwise the app will go to the word added state, closing the insertion page
    final word = event.word;
    final texts = word.sentences.map((e) => e.text);
    print("bloc sentences: " + word.sentences.toString());
    if (word.text.isEmpty ||
        word.meaning.isEmpty ||
        word.reading.isEmpty ||
        texts.length != texts.toSet().length) {
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
      print("wordstate: " + state.toString());
    }
  }

  void _onRetrieved(WordsRetrieved _, Emitter<WordState> emit) async {
    emit(WordLoading());
    final words = await repository.getWords();
    emit(WordsLoaded(words: words));
  }

  void _onGetWord(WordRetrieved event, Emitter<WordState> emit) async {
    emit(WordLoading());

    final word = await repository.getWord(event.wordId);
    if (word != null) {
      emit(WordLoaded(word: word));
    } else {
      emit(const WordError(message: "word not found!"));
    }
  }
}
