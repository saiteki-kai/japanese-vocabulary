import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../utils/mocks.dart';
import '../utils/params.dart';

void main() async {
  late WordBloc bloc;
  late WordRepository repo;

  void setUpEmpty() {
    when(repo.getWords).thenAnswer((_) async => []);
  }

  void setUpWithWords() {
    when(repo.getWords).thenAnswer((_) async => [word1, word2, word3]);
  }

  setUp(() async {
    repo = MockWordRepository();
    bloc = WordBloc(repository: repo);
    registerFallbackValue(FakeWord());

    when(() => repo.addWord(any()))
        .thenAnswer((inv) async => inv.positionalArguments[0].id);
  });

  tearDown(() async {
    bloc.close();
    reset(repo);
  });

  blocTest<WordBloc, WordState>(
    'emits [WordLoading, WordLoaded] when WordRetrieved is added.',
    build: () => bloc,
    setUp: setUpWithWords,
    act: (bloc) => bloc.add(WordsRetrieved()),
    expect: () => <WordState>[
      WordLoading(),
      WordsLoaded(words: [word1, word2, word3]),
    ],
    verify: (_) {
      verify(() => repo.getWords()).called(1);
    },
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoading, WordLoaded] when WordRetrieved is added when store is empty.',
    build: () => bloc,
    setUp: setUpEmpty,
    act: (bloc) => bloc.add(WordsRetrieved()),
    expect: () => <WordState>[
      WordLoading(),
      const WordsLoaded(words: []),
    ],
    verify: (_) {
      verify(() => repo.getWords()).called(1);
    },
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoaded] when WordAdded is added when store is not empty.',
    seed: () => const WordsLoaded(words: []),
    build: () => bloc,
    setUp: setUpWithWords,
    act: (bloc) => bloc.add(WordAdded(word: word1)),
    expect: () => <WordState>[
      WordsLoaded(words: [word1]),
    ],
    verify: (_) {
      verify(() => repo.addWord(any())).called(1);
    },
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoaded] when WordAdded is added when store is empty.',
    seed: () => const WordsLoaded(words: []),
    build: () => bloc,
    setUp: setUpEmpty,
    act: (bloc) => bloc.add(WordAdded(word: word1)),
    expect: () => <WordState>[
      WordsLoaded(words: [word1]),
    ],
    verify: (_) {
      verify(() => repo.addWord(any())).called(1);
    },
  );

  blocTest<WordBloc, WordState>(
    'emits [WordInitial] when WordAdded is added when the word is invalid.',
    build: () => bloc,
    setUp: setUpEmpty,
    act: (bloc) => bloc.add(WordAdded(word: invalidWord)),
    expect: () => <WordState>[
      WordInitial(),
    ],
    verify: (_) {
      verifyNever(() => repo.addWord(any()));
    },
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoaded] when WordAdded is added multiple times.',
    build: () => bloc,
    setUp: setUpEmpty,
    act: (bloc) => {
      bloc.add(WordAdded(word: word1)),
      bloc.add(WordAdded(word: word2)),
    },
    verify: (_) {
      verifyNever(() => repo.addWord(any()));
    },
  );

  blocTest<WordBloc, WordState>(
    'emits [WordLoaded] when WordAdded is added multiple times and store not empty.',
    build: () => bloc,
    setUp: setUpWithWords,
    act: (bloc) => {
      bloc.add(WordAdded(word: word4)),
      bloc.add(WordAdded(word: word5)),
    },
    verify: (_) {
      verifyNever(() => repo.addWord(any()));
    },
  );
}
