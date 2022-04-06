part of 'word_bloc.dart';

abstract class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

/// This [WordRetrived] manages the events concerning the [Word].
class WordRetrived extends WordEvent {}
