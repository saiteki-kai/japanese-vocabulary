import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';

void main() {
  final wordRepository = WordRepository();
  final store = AppDatabase.instance.store;

  group("get word", () {
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

    test("get word with existing id", () async {
      final res1 = await wordRepository.getWord(1);
      expect(res1, isNotNull);
      expect(res1!.id, 1);

      final res2 = await wordRepository.getWord(2);
      expect(res2, isNotNull);
      expect(res2!.id, 2);

      final res3 = await wordRepository.getWord(3);
      expect(res3, isNotNull);
      expect(res3!.id, 3);
    });

    test("get word with not valid id", () async {
      final res1 = await wordRepository.getWord(0);
      expect(res1, isNull);

      final res2 = await wordRepository.getWord(-1);
      expect(res2, isNull);

      final res3 = await wordRepository.getWord(-100);
      expect(res3, isNull);
    });

    test("get word with not existing id", () async {
      final res1 = await wordRepository.getWord(4);
      expect(res1, isNull);

      final res2 = await wordRepository.getWord(5);
      expect(res2, isNull);

      final res3 = await wordRepository.getWord(42);
      expect(res3, isNull);
    });

  });
}
