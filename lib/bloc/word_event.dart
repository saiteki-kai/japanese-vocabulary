part of 'word_bloc.dart';

abstract class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

class GetWordEvent extends WordEvent {
  const GetWordEvent({required this.wordId});
  final int wordId;

  @override
  List<Object> get props => [wordId];
}

class AddWordEvent extends WordEvent {
  final Word word;
  const AddWordEvent({required this.word});

  @override
  List<Object> get props => [word];
}

/// This [WordRetrieved] manages the events concerning the [Word].
class WordRetrieved extends WordEvent {}
