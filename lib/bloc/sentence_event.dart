part of 'sentence_bloc.dart';

abstract class SentenceEvent extends Equatable {
  const SentenceEvent();

  @override
  List<Object> get props => [];
}

class SentencesRetrieved extends SentenceEvent {
  final Word? word;
  const SentencesRetrieved({required this.word});

  @override
  List<Object> get props => [word?.sentences ?? []];
}

class SentenceAdded extends SentenceEvent {
  final Sentence sentence;
  const SentenceAdded({required this.sentence});
  @override
  List<Object> get props => [sentence];
}

class SentencesAdded extends SentenceEvent {
  final List<Sentence> sentences;
  const SentencesAdded({required this.sentences});
  @override
  List<Object> get props => [sentences];
}
