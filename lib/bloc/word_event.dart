part of 'word_bloc.dart';

abstract class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

class GetWord extends WordEvent {}

class AddWordEvent extends WordEvent {}
