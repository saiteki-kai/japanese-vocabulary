import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';
import '../../data/models/word.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final WordRepository repository;

  WordBloc({required this.repository}) : super(WordInitial()) {
    on<AddWordEvent>((event, emitter) {
      
    });
  }
}
