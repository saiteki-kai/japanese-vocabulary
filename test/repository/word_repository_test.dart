import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';
import 'package:japanese_vocabulary/objectbox.g.dart';
import 'package:mocktail/mocktail.dart';

import '../utils/mocks.dart';
import '../utils/params.dart';

void main() async {
  late WordRepository repo;
  late Box<Word> box;

  setUp(() {
    box = MockWordBox();
    repo = WordRepository(box: Future.value(box));
    registerFallbackValue(FakeReview());
  });

  tearDown(() {
    reset(box);
  });

  group("get words", () {
    test("not empty list", () async {
      final words = [word1, word2, word3];
      when(box.getAll).thenReturn(words);

      final res = await repo.getWords();
      expect(res, equals(words));
    });

    test("empty list", () async {
      when(box.getAll).thenReturn([]);
      final res = await repo.getWords();
      expect(res, equals([]));
    });
  });


  group("get word", () {
    test("get word with existing id", () async {
      when(() => box.get(1)).thenReturn(word1);

      final word = await repo.getWord(1);
      expect(word, equals(word1));
    });

    test("get word with id zero", () async {
      when(() => box.get(0)).thenReturn(null);

      final word1 = await repo.getWord(0);
      expect(word1, isNull);
    });

    test("get word with negative id ", () async {
      when(() => box.get(-1)).thenReturn(null);

      final word2 = await repo.getWord(-1);
      expect(word2, isNull);
    });
  });
}
