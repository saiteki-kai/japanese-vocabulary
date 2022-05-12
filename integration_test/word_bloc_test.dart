import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';

void main() async {
  final store = await AppDatabase.instance.store;
  final box = store.box<Word>();
  final wordRepository = WordRepository(box: Future.value(box));

  late WordBloc bloc;
  final List<Word> words = [];
  final invalidWord = Word(
    text: "言葉",
    reading: "",
    jlpt: 5,
    meaning: "",
    pos: "Noun",
  );

  setUp(() async {
    bloc = WordBloc(repository: wordRepository);
    words.add(Word(
      text: "言葉",
      reading: "ことば",
      jlpt: 5,
      meaning: "word; phrase; expression; term",
      pos: "Noun",
    ));
    words.add(Word(
      text: "復習",
      reading: "ふくしゅう",
      jlpt: 4,
      meaning: "review (of learned material); revision",
      pos: "Noun, Suru verb",
    ));
    words.add(Word(
      text: "普通",
      reading: "ふつう",
      jlpt: 4,
      meaning: "normal; ordinary; regular",
      pos: "Noun, Na-adjective",
    ));

    box.removeAll();
    box.putMany(words);
  });

  tearDown(() async {
    box.removeAll();
    bloc.close();
  });

  blocTest<WordBloc, WordState>(
    'emits [Wordloading, Wordloaded] when WordRetrived is added.',
    build: () => bloc,
    act: (bloc) => bloc.add(WordsRetrieved()),
    expect: () => <WordState>[WordLoading(), WordsLoaded(words: box.getAll())],
  );

  blocTest<WordBloc, WordState>(
    'emits [Wordloading, Wordloaded] when WordRetrived is added when store is empty.',
    setUp: () async => box.removeAll(),
    build: () => bloc,
    act: (bloc) => bloc.add(WordsRetrieved()),
    expect: () => <WordState>[WordLoading(), const WordsLoaded(words: [])],
  );

  blocTest<WordBloc, WordState>(
    'Testing insertion of a word correctly set',
    setUp: () => {box.removeAll()}, // to ensure words inside the db is empty.
    seed: () => const WordsLoaded(words: []),
    build: () => bloc,
    act: (bloc) => bloc.add(WordAdded(word: words[0])),
    expect: () => <WordState>[
      WordsLoaded(words: [words[0]]),
    ],
  );

  blocTest<WordBloc, WordState>(
    'Testing insertion of a word with empty fields',
    setUp: () => {box.removeAll()}, // to ensure words inside the db is empty.
    build: () => bloc,
    act: (bloc) => bloc.add(WordAdded(word: invalidWord)),
    expect: () => <WordState>[WordInitial()],
  );
}
