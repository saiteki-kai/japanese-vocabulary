import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/sentence.dart';
import '../data/models/word.dart';
import '../data/repositories/sentence_repository.dart';
import 'word_bloc.dart';

part 'sentence_event.dart';
part 'sentence_state.dart';

class SentenceBloc extends Bloc<SentenceEvent, SentenceState> {
  SentenceBloc({required this.repository}) : super(SentencesInitial()) {
    on<SentencesRetrieved>(_onRetrieved);
    on<SentenceAdded>(_onSentenceAdded);
    on<SentencesAdded>(_onSentencesAdded);
  }

  /// The instance of the repository.
  final SentenceRepository repository;

  void _onSentenceAdded(
      SentenceAdded event, Emitter<SentenceState> emit) async {
    /// If one of the text fields is empty, returns to the initial state,
    ///
    /// otherwise the new sentence will be added to the repository and to the list of sentences.
    emit(SentenceAdding());
    final Sentence sentence = event.sentence;
    if (sentence.text.isEmpty || sentence.translation.isEmpty) {
      emit(SentencesInitial());
    } else {
      if (state is SentencesLoaded) {
        final id = await repository.addSentence(sentence);
        final sentences = state.props as List<Sentence>;
        final sentenceAdded = await repository.getSentence(id);
        sentences.add(sentenceAdded!);
        emit(SentencesLoaded(sentences: sentences));
      }
    }
  }

  void _onSentencesAdded(
      SentencesAdded event, Emitter<SentenceState> emit) async {
    /// If one of the text fields is empty, returns to the initial state,
    ///
    /// otherwise the new sentences will be added to the repository and to the list of sentences.
    final sentences = event.sentences;
    if (sentences.any((element) => element.text.isEmpty) ||
        sentences.any((element) => element.translation.isEmpty)) {
      emit(SentencesInitial());
    } else {
      final ids = await repository.addSentences(sentences);
      final sentencesAdded = await repository.getSentences(ids);
      final List<Sentence> toAdd = [];
      for (Sentence? s in sentencesAdded) {
        if (s != null) {
          toAdd.add(s);
        }
      }
      if (state is WordLoaded) {
        toAdd.addAll((state.props.first as Word).sentences);
      }
      emit(SentencesLoaded(sentences: toAdd));
    }
  }

  void _onRetrieved(
      SentencesRetrieved event, Emitter<SentenceState> emit) async {
    /// Returns the list of sentences related to a word.
    emit(SentencesLoading());
    final sentences = event.word?.sentences.toList() ?? [];
    emit(SentencesLoaded(sentences: sentences));
  }
}
