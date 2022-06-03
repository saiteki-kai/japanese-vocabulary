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

  setUpWithWords2() {
    repo.addWord(word1);
    repo.addWord(word2);
    repo.addWord(word5);
    repo.addWord(word4);
    repo.addWord(word6);
  }

  blocTest<WordBloc, WordState>(
    'emits [WordLoading, WordLoaded] when WordsRetrieved is added.',
    build: () => bloc,
    setUp: setUpWithWords,
    act: (bloc) => bloc.add(const WordsRetrieved()),
    expect: () {
      final w1 = word1;
      w1.id = 1;
      w1.meaningReview.targetId = 1;
      w1.readingReview.targetId = 2;
      final w2 = word2;
      w2.id = 2;
      w2.meaningReview.targetId = 3;
      w2.readingReview.targetId = 4;
      final w3 = word3;
      w3.id = 3;
      w3.meaningReview.targetId = 5;
      w3.readingReview.targetId = 6;

      return <WordState>[
        WordLoading(),
        WordsLoaded(words: [w1, w2, w3]),
      ];
    },
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoading, WordLoaded] when WordsRetrieved is added when store is empty.',
    build: () => bloc,
    act: (bloc) => bloc.add(const WordsRetrieved()),
    expect: () => <WordState>[
      WordLoading(),
      const WordsLoaded(words: []),
    ],
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoading, WordLoaded] when WordsRetrieved is added and search for a word in the db.',
    build: () => bloc,
    setUp: setUpWithWords,
    act: (bloc) => bloc.add(const WordsRetrieved(search: "習")),
    expect: () {
      final word = word2;
      word.id = 2;
      word.meaningReview.targetId = 3;
      word.readingReview.targetId = 4;

      return <WordState>[
        WordLoading(),
        WordsLoaded(words: [word]),
      ];
    },
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoading, WordLoaded] when WordsRetrieved is added and search for a word not in the db.',
    build: () => bloc,
    setUp: setUpWithWords,
    act: (bloc) => bloc.add(const WordsRetrieved(search: "習g")),
    expect: () => <WordState>[
      WordLoading(),
      const WordsLoaded(words: []),
    ],
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoading, WordLoaded] when WordsRetrieved is added and search for multiple words in the db.',
    build: () => bloc,
    setUp: setUpWithWords2,
    act: (bloc) => bloc.add(const WordsRetrieved(search: "gracia")),
    expect: () {
      final w1 = word5;
      w1.id = 3;
      w1.meaningReview.targetId = 5;
      w1.readingReview.targetId = 6;

      final w2 = word6;
      w2.id = 5;
      w2.meaningReview.targetId = 9;
      w2.readingReview.targetId = 10;

      return <WordState>[
        WordLoading(),
        WordsLoaded(words: [w1, w2]),
      ];
    },
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoaded] when WordAdded is added when store is empty.',
    seed: () => const WordsLoaded(words: []),
    build: () => bloc,
    act: (bloc) => bloc.add(WordAdded(word: word1)),
    expect: () {
      final word = word1;
      word.id = 1;
      word.meaningReview.targetId = 1;
      word.readingReview.targetId = 2;

      return <WordState>[
        WordsLoaded(words: [word]),
      ];
    },
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoaded] when WordAdded is added when store is not empty.',
    seed: () => const WordsLoaded(words: []),
    build: () => bloc,
    setUp: setUpWithWords,
    act: (bloc) => bloc.add(WordAdded(word: word4)),
    expect: () {
      final word = word4;
      word.id = 4;
      word.meaningReview.targetId = 7;
      word.readingReview.targetId = 8;

      return <WordState>[
        WordsLoaded(words: [word]),
      ];
    },
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
    expect: () {
      final w1 = word1;
      w1.id = 1;
      w1.meaningReview.targetId = 1;
      w1.readingReview.targetId = 2;

      final w2 = word2;
      w2.id = 2;
      w2.meaningReview.targetId = 3;
      w2.readingReview.targetId = 4;

      return <WordState>[
        WordsLoaded(words: [w1]),
        WordsLoaded(words: [w1, w2]),
      ];
    },
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
    expect: () {
      final w1 = word4;
      w1.id = 4;
      w1.meaningReview.targetId = 7;
      w1.readingReview.targetId = 8;

      final w2 = word5;
      w2.id = 5;
      w2.meaningReview.targetId = 9;
      w2.readingReview.targetId = 10;

      return <WordState>[
        WordsLoaded(words: [w1]),
        WordsLoaded(words: [w1, w2]),
      ];
    },
  );
}
