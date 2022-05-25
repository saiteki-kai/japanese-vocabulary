import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/sentence.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';
import 'package:japanese_vocabulary/objectbox.g.dart';

import '../test/utils/params.dart';

void main() async {
  late Store store;
  late Box<Word> wordBox;
  late Box<Review> reviewBox;
  late WordRepository repo;

  // At the start of each test the db have no words or reviews.
  setUp(() async {
    store = await AppDatabase.instance.store;
    wordBox = store.box<Word>();
    reviewBox = store.box<Review>();
    repo = WordRepository(box: Future.value(wordBox));
  });

  // Deletes the database at the end of each test
  tearDown(() async {
    store.close();
    await AppDatabase.instance.deleteDatabase();
  });

  group("get words", () {
    setUp(() {
      wordBox.put(word1);
      wordBox.put(word2);
      wordBox.put(word3);
    });

    test("not empty list", () async {
      final res = await repo.getWords();
      expect(res.length, 3);
    });

    test("empty list", () async {
      wordBox.removeAll();
      final res = await repo.getWords();
      expect(res.length, 0);
    });
  });

  group("get word", () {
    setUp(() {
      wordBox.put(word1);
      wordBox.put(word2);
      wordBox.put(word3);
    });

    test("existing id", () async {
      final res = await repo.getWord(1);
      expect(res, isNotNull);
      expect(res, equals(word1..id = 1));
    });

    test("id zero", () async {
      final res = await repo.getWord(0);
      expect(res, isNull);
    });

    test("negative id", () async {
      final res = await repo.getWord(-1);
      expect(res, isNull);
    });

    test("not existing id", () async {
      final res = await repo.getWord(4);
      expect(res, isNull);
    });
  });

  group('insert word', () {
    test('simple insertion', () async {
      expect(wordBox.getAll().length, 0);

      final res = await repo.addWord(word1);
      expect(res, 1, reason: "Id should've been 1");
      expect(wordBox.getAll().length, 1, reason: "# elements should've been 1");
    });

    test('word-reviews relations', () async {
      wordBox.removeAll();
      reviewBox.removeAll();
      final res = await repo.addWord(word1);
      final word = wordBox.get(res);

      expect(word?.meaningReview.target, isNotNull);
      expect(word?.readingReview.target, isNotNull);
      expect(wordBox.getAll().length, 1);
      expect(reviewBox.getAll().length, 2);
    });
    test('word-sentences relations', () async {
      wordBox.removeAll();
      final sentenceBox = store.box<Sentence>();
      sentenceBox.removeAll();

      final res = await repo.addWord(wordSentences);
      final word = wordBox.get(res);

      expect(word?.sentences.length, 2);

      expect(wordBox.getAll().length, 1);
      expect(sentenceBox.getAll().length, 2);
    });
  });
}
