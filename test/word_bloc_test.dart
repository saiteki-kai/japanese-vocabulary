import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';

void main() async {
  final wordRepository = WordRepository();
  final store = await AppDatabase.instance.store;
  final box = store.box<Word>();

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
    act: (bloc) => bloc.add(WordRetrieved()),
    expect: () => <WordState>[WordLoading(), WordsLoaded(box.getAll())],
  );

  blocTest<WordBloc, WordState>(
    'emits [Wordloading, Wordloaded] when WordRetrived is added when store is empty.',
    setUp: () async => box.removeAll(),
    build: () => bloc,
    act: (bloc) => bloc.add(WordRetrieved()),
    expect: () => <WordState>[WordLoading(), const WordsLoaded([])],
  );

  blocTest<WordBloc, WordState>(
    'Testing insertion of a word correctly set',
    setUp: () => {box.removeAll()}, // to ensure words inside the db is empty.
    build: () => bloc,
    act: (bloc) => bloc.add(AddWordEvent(word: words[0])),
    expect: () => <WordState>[WordAdded()],
  );

  blocTest<WordBloc, WordState>(
    'Testing insertion of a word with empty fields',
    setUp: () => {box.removeAll()}, // to ensure words inside the db is empty.
    build: () => bloc,
    act: (bloc) => bloc.add(AddWordEvent(word: invalidWord)),
    expect: () => <WordState>[WordInitial()],
  );
}
