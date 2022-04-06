part of 'word_bloc.dart';

abstract class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

class GetWord extends WordEvent {}

class AddWordEvent extends WordEvent {
  final Word word;
  const AddWordEvent({required this.word});

  @override
  List<Object> get props => [word];
}

/// This [WordRetrived] manages the events concerning the [Word].
class WordRetrived extends WordEvent {}
