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
  }

  /// The instance of the repository
  final WordRepository repository;

  void _onRetrieved(
      SentencesRetrieved event, Emitter<SentenceState> emit) async {
    emit(SentencesLoading());

    if (event.word.sentences.isNotEmpty) {
      emit(SentencesLoaded(sentences: event.word.sentences));
    } else {
      emit(const SentenceError(message: "sentence not found!"));
    }
  }
}
