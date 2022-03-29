import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final WordRepository repository;

  WordBloc({required this.repository}) : super(WordInitial()) {
    on<WordEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
