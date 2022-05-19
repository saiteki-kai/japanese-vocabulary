import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/sentence.dart';
import '../data/models/word.dart';
import '../data/repositories/word_repository.dart';

part 'sentence_event.dart';
part 'sentence_state.dart';

class SentenceBloc extends Bloc<SentenceEvent, SentenceState> {
  SentenceBloc({required this.repository}) : super(SentencesInitial()) {
    on<SentencesRetrieved>(_onRetrieved);
    on<SentenceAdded>(_onSentenceAdded);
  }

  /// The instance of the repository
  final WordRepository repository;

  void _onSentenceAdded(
    SentenceAdded event,
    Emitter<SentenceState> emit,
  ) async {
    emit(
      SentenceAdding(),
    );
    final Sentence sentence = event.sentence;
    if (sentence.text.isEmpty || sentence.translation.isEmpty) {
      emit(SentencesInitial());
    } else {
      final word = event.word;
      if (state is SentencesLoaded) {
        await repository.addWord(word);
        emit(SentencesLoaded(sentences: word.sentences));
      }
    }
  }

  void _onRetrieved(
    SentencesRetrieved event,
    Emitter<SentenceState> emit,
  ) async {
    emit(
      SentencesLoading(),
    );
    final sentences = event.word.sentences;
    if (sentences.isNotEmpty) {
      emit(
        SentencesLoaded(sentences: sentences),
      );
    } else {
      emit(
        const SentenceError(message: "Sentence not found!"),
      );
    }
  }
}
