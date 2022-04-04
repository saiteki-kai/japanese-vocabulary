part of 'word_bloc.dart';

abstract class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

class WordRetrived extends WordEvent {}
