import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/models/sort_option.dart';
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
    registerFallbackValue(FakeWord());
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

    group("sorting", () {
      setUp(() {
        when(() => box.getAll()..sort()).thenReturn(
          <Word>[wordsWithReview1, wordsWithReview2, wordsWithReview3],
        );
      });

      test("ascending", () async {
        final sorted = await repo.getWords(
          sort: const SortOption(field: SortField.streak, descending: false),
        );

        expect(sorted, equals(expectedSorting[SortField.streak]));
      });
      test("descending", () async {
        final sorted = await repo.getWords(
          sort: const SortOption(field: SortField.accuracy, descending: true),
        );

        expect(sorted, equals(expectedSorting[SortField.accuracy]!.reversed));
      });
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

  group('insert word', () {
    test('simple insertion', () async {
      when(() => box.put(any()))
          .thenAnswer((inv) => inv.positionalArguments[0].id);

      final id = await repo.addWord(word1);
      expect(id, word1.id, reason: "Id should've been ${word1.id}");
    });

    test('simple edit', () async {
      when(() => box.put(any()))
          .thenAnswer((inv) => inv.positionalArguments[0].id);

      final id = await repo.addWord(word1);
      expect(id, word1.id, reason: "Id should've been ${word1.id}");

      final word = word1.copyWith(
        text: "Gracias",
        reading: "Gra see uhs",
        jlpt: 1,
        meaning: "Thanks",
        pos: "n,vi",
      );

      final id2 = await repo.addWord(word);
      expect(id2, id, reason: "Id should've been $id2");
    });
  });
}
