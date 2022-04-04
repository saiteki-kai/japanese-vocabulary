import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';

import 'word_instances.dart';

void main() async {
  late WordBloc bloc;

  final store = await AppDatabase.instance.store;
  final box = store.box<Word>();

  setUp(() {
    bloc = WordBloc(repository: WordRepository());
    box.removeAll();
  });

  tearDown(() {
    bloc.close();
    box.removeAll();
  });

  blocTest<WordBloc, WordState>(
    'Testing insertion of a word correctly set',
    build: () => bloc,
    act: (bloc) => bloc.add(AddWordEvent(word: WordTestInstances.word1)),
    expect: () => <WordState>[WordAdded()],
  );
  blocTest<WordBloc, WordState>(
    'Testing insertion of a word with empty fields',
    build: () => bloc,
    act: (bloc) => bloc.add(AddWordEvent(word: WordTestInstances.word2)),
    expect: () => <WordState>[WordInitial()],
  );
}
