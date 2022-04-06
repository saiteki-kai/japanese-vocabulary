import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';

void main() {
  final wordRepository = WordRepository();
  final store = AppDatabase.instance.store;

  group("get words", () {
    setUp(() async {
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
      (await store).box<Word>().putMany(words);
    });

    tearDown(() async {
      (await store).box<Word>().removeAll();
    });

    test("get words length", () async {
      final res = await wordRepository.getWords();
      expect(res.length, 3);
    });

    test("get words empty list", () async {
      (await store).box<Word>().removeAll();
      final res = await wordRepository.getWords();
      expect(res.length, 0);
    });
  });
}
