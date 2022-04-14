part of 'word_bloc.dart';

abstract class WordState extends Equatable {
  const WordState();

  @override
  List<Object> get props => [];
}

class WordInitial extends WordState {}

class WordAdded extends WordState {}

/// This [WordLoading] defines the loading of the [WordState].
class WordLoading extends WordState {}

/// This [WordsLoaded] returns a list of [Word].
class WordsLoaded extends WordState {
  final List<Word> words;
  const WordsLoaded({required this.words});

  @override
  List<Object> get props => [words];
}

/// This [WordLoaded] returns a [Word].
class WordLoaded extends WordState {
  final Word word;
  const WordLoaded({required this.word});

  @override
  List<Object> get props => [word];
}

/// This [WordError] returns a [message] error.
class WordError extends WordState {
  final String message;
  const WordError({required this.message});

  @override
  List<Object> get props => [message];
}
