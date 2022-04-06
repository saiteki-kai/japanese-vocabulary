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

  setUp(() async {
    bloc = WordBloc(repository: wordRepository);

    final List<Word> words = [];
    words.add(Word(
      id: 0,
      text: "言葉",
      reading: "ことば",
      jlpt: 5,
      meaning: "word; phrase; expression; term",
      pos: "Noun",
    ));
    words.add(Word(
      id: 0,
      text: "復習",
      reading: "ふくしゅう",
      jlpt: 4,
      meaning: "review (of learned material); revision",
      pos: "Noun, Suru verb",
    ));
    words.add(Word(
      id: 0,
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
    expect: () => <WordState>[WordLoading(), WordLoaded(box.getAll())],
  );

  blocTest<WordBloc, WordState>(
    'emits [Wordloading, Wordloaded] when WordRetrived is added when store is empty.',
    setUp: () async => (await store).box<Word>().removeAll(),
    build: () => bloc,
    act: (bloc) => bloc.add(WordRetrieved()),
    expect: () => <WordState>[WordLoading(), const WordLoaded([])],
  );
}
