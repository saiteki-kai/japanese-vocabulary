import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/sentence.dart';
import '../data/models/word.dart';
import '../data/repositories/sentence_repository.dart';
import '../data/repositories/word_repository.dart';

part 'sentence_event.dart';
part 'sentence_state.dart';

class SentenceBloc extends Bloc<SentenceEvent, SentenceState> {
  SentenceBloc({required this.wordRepository, required this.sentenceRepository})
      : super(SentencesInitial()) {
    on<SentencesRetrieved>(_onRetrieved);
    on<SentenceAdded>(_onSentenceAdded);
    on<SentencesAdded>(_onSentencesAdded);
  }

  /// The instance of the repository
  final WordRepository wordRepository;
  final SentenceRepository sentenceRepository;

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
        await wordRepository.addWord(word);
        emit(SentencesLoaded(sentences: word.sentences));
      }
    }
  }

  void _onSentencesAdded(
    SentencesAdded event,
    Emitter<SentenceState> emit,
  ) async {
    final sentences = event.sentences;
    if (sentences.any((element) => element.text.isEmpty) ||
        sentences.any((element) => element.translation.isEmpty)) {
      emit(SentencesInitial());
    } else {
      final word = event.word;
      print("state: " + state.toString());
      print("allora trolli");
      final ids = await sentenceRepository.addSentences(sentences);
      print("ids: " + ids.toString());
      final sentencesAdded = await sentenceRepository.getSentences(ids);
      print("sentencesAdded: " + sentencesAdded.toString());
      final List<Sentence> toAdd = [];
      if (sentencesAdded.contains(null)) {
      } else {
        for (Sentence? s in sentencesAdded) {
          if (s != null) {
            toAdd.add(s);
          }
        }
        word.sentences.addAll(toAdd);
        print("sentences to add: " + toAdd.toString());
        print("word modified into: " + word.toString());
        final success = await wordRepository.addWord(word);
        final wordUpdated = await wordRepository.getWord(success);
        print("success: " + wordUpdated.toString());
      }

      //emit(SentencesLoaded(sentences: word.sentences));
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
