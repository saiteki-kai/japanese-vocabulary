part of 'sentence_bloc.dart';

abstract class SentenceEvent extends Equatable {
  const SentenceEvent();

  @override
  List<Object> get props => [];
}

class SentencesRetrieved extends SentenceEvent {
  final Word word;
  const SentencesRetrieved({required this.word});

  @override
  List<Object> get props => [word];
}

class SentenceAdded extends SentenceEvent {
  final Word word;
  final Sentence sentence;
  const SentenceAdded({required this.word, required this.sentence});
  @override
  List<Object> get props => [sentence];
}
