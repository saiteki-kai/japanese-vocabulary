import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';
import 'package:japanese_vocabulary/objectbox.g.dart';

import '../test/utils/params.dart';

void main() async {
  late Store store;
  late WordBloc bloc;
  late WordRepository repo;

  setUp(() async {
    store = await AppDatabase.instance.store;
    repo = WordRepository(box: Future.value(store.box<Word>()));
    bloc = WordBloc(repository: repo);
  });

  tearDown(() async {
    bloc.close();
    store.close();
    await AppDatabase.instance.deleteDatabase();
  });

  setUpWithWords() {
    repo.addWord(word1);
    repo.addWord(word2);
    repo.addWord(word3);
  }

  blocTest<WordBloc, WordState>(
    'emits [WordLoading, WordLoaded] when WordRetrieved is added.',
    build: () => bloc,
    setUp: setUpWithWords,
    act: (bloc) => bloc.add(const WordsRetrieved()),
    expect: () => <WordState>[
      WordLoading(),
      WordsLoaded(
        words: [
          word1..id = 1,
          word2..id = 2,
          word3..id = 3,
        ],
      ),
    ],
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoading, WordLoaded] when WordRetrieved is added when store is empty.',
    build: () => bloc,
    act: (bloc) => bloc.add(const WordsRetrieved()),
    expect: () => <WordState>[
      WordLoading(),
      const WordsLoaded(words: []),
    ],
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoaded] when WordAdded is added when store is empty.',
    seed: () => const WordsLoaded(words: []),
    build: () => bloc,
    act: (bloc) => bloc.add(WordAdded(word: word1)),
    expect: () => <WordState>[
      WordsLoaded(words: [word1..id = 1]),
    ],
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoaded] when WordAdded is added when store is not empty.',
    seed: () => const WordsLoaded(words: []),
    build: () => bloc,
    setUp: setUpWithWords,
    act: (bloc) => bloc.add(WordAdded(word: word4)),
    expect: () => <WordState>[
      WordsLoaded(words: [
        word4..id = 4,
      ]),
    ],
  );

  blocTest<WordBloc, WordState>(
    'emits [WordInitial] when WordAdded is added when the word is invalid.',
    build: () => bloc,
    act: (bloc) => bloc.add(WordAdded(word: invalidWord)),
    expect: () => <WordState>[
      WordInitial(),
    ],
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoaded] when WordAdded is added multiple times.',
    seed: () => const WordsLoaded(words: []),
    build: () => bloc,
    act: (bloc) => {
      bloc.add(WordAdded(word: word1)),
      bloc.add(WordAdded(word: word2)),
    },
    expect: () => <WordState>[
      WordsLoaded(words: [
        word1..id = 1,
      ]),
      WordsLoaded(words: [
        word1..id = 1,
        word2..id = 2,
      ]),
    ],
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoaded] when WordAdded is added multiple times and store not empty.',
    seed: () => const WordsLoaded(words: []),
    build: () => bloc,
    setUp: setUpWithWords,
    act: (bloc) => {
      bloc.add(WordAdded(word: word4)),
      bloc.add(WordAdded(word: word5)),
    },
    expect: () => <WordState>[
      WordsLoaded(words: [
        word4..id = 4,
      ]),
      WordsLoaded(words: [
        word4..id = 4,
        word5..id = 5,
      ]),
    ],
  );
}
