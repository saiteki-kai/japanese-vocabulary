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

/// This [WordLoaded] returns a list of [Word].
class WordLoaded extends WordState {
  final List<Word> words;
  const WordLoaded(this.words);

  @override
  List<Object> get props => [words];
}
