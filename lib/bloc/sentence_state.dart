part of 'sentence_bloc.dart';

abstract class SentenceState extends Equatable {
  const SentenceState();

  @override
  List<Object> get props => [];
}

class SentencesInitial extends SentenceState {}

/// This [SentencesLoading] defines the loading of the [SentenceState].
class SentencesLoading extends SentenceState {}

/// This [SentencesLoaded] returns a list of [Sentence].
class SentencesLoaded extends SentenceState {
  final List<Sentence> sentences;
  const SentencesLoaded({required this.sentences});

  @override
  List<Object> get props => [sentences];
}

/// This [SentenceError] returns a [message] error.
class SentenceError extends SentenceState {
  final String message;
  const SentenceError({required this.message});

  @override
  List<Object> get props => [message];
}
