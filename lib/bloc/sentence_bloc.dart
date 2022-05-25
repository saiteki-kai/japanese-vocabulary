import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/sentence.dart';
import '../data/models/word.dart';
import '../data/repositories/sentence_repository.dart';

part 'sentence_event.dart';
part 'sentence_state.dart';

class SentenceBloc extends Bloc<SentenceEvent, SentenceState> {
  SentenceBloc({required this.repository}) : super(SentencesInitial()) {
    on<SentencesRetrieved>(_onRetrieved);
  }

  /// The instance of the repository.
  final SentenceRepository repository;

  void _onRetrieved(
    SentencesRetrieved event,
    Emitter<SentenceState> emit,
  ) async {
    /// Returns the list of sentences related to a word.
    emit(SentencesLoading());
    final sentences = event.word?.sentences.toList() ?? [];
    emit(SentencesLoaded(sentences: sentences));
  }
}
