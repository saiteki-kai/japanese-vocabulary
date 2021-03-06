part of 'word_bloc.dart';

abstract class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

class WordRetrieved extends WordEvent {
  const WordRetrieved({required this.wordId});
  final int wordId;

  @override
  List<Object> get props => [wordId];
}

class WordAdded extends WordEvent {
  final Word word;
  const WordAdded({required this.word});

  @override
  List<Object> get props => [word];
}

class WordsRetrieved extends WordEvent {
  final String search;
  final SortOption? sort;
  const WordsRetrieved({this.search = "", this.sort});

  @override
  List<Object> get props => [search];
}
