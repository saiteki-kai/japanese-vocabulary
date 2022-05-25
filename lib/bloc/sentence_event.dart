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
