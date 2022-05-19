part of 'sentence_bloc.dart';

abstract class SentenceState extends Equatable {
  const SentenceState();

  @override
  List<Object> get props => [];
}

class SentencesInitial extends SentenceState {}

class SentencesLoading extends SentenceState {}

class SentenceAdding extends SentenceState {}

class SentencesLoaded extends SentenceState {
  final List<Sentence> sentences;
  const SentencesLoaded({required this.sentences});

  @override
  List<Object> get props => [sentences];
}

class SentenceError extends SentenceState {
  final String message;
  const SentenceError({required this.message});

  @override
  List<Object> get props => [message];
}
