import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repositories/word_repository.dart';
import '../../data/models/word.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  WordBloc({required this.repository}) : super(WordInitial()) {
    on<AddWordEvent>(_onAddWordEvent);
  }

  final WordRepository repository;

  void _onAddWordEvent(AddWordEvent event, Emitter<WordState> emit) async {
    //final WordRepository repository = WordBloc.repository;
    //should emit a state for returning to the visualization page

    //final cleared = await repository.clear();
    //print("cleared");

    if (event.word.text.isEmpty ||
        event.word.meaning.isEmpty ||
        event.word.reading.isEmpty) {
      print("error");
      emit(WordInitial());
    } else {
      final added = await repository.addWord(event.word);
      print("added");
      final get = await repository.getWords();
      print(get.toString());
      emit(WordAdded());
    }

    //final get = await repository.getWords();
    //print(get.toString());
  }
}
