import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';
import 'package:japanese_vocabulary/objectbox.g.dart';

void main() async {
  late Store store;
  late Box<Word> wordBox;
  late Box<Review> reviewBox;
  late WordRepository repo;

  final List<Word> words = [
    Word(
      text: "言葉",
      reading: "ことば",
      jlpt: 5,
      meaning: "word; phrase; expression; term",
      pos: "Noun",
    ),
    Word(
      text: "復習",
      reading: "ふくしゅう",
      jlpt: 4,
      meaning: "review (of learned material); revision",
      pos: "Noun, Suru verb",
    ),
    Word(
      text: "普通",
      reading: "ふつう",
      jlpt: 4,
      meaning: "normal; ordinary; regular",
      pos: "Noun, Na-adjective",
    ),
  ];

  // Init conditions for each test.
  //
  // At the start of each test the db have three words.
  // At the start of each test the db have zero reviews.
  init() async {
    store = await AppDatabase.instance.store;
    repo = WordRepository(box: Future.value(store.box<Word>()));

    wordBox = store.box<Word>();
    reviewBox = store.box<Review>();
    wordBox.putMany(words);
  }

  // This is done to facilitate testing.
  //
  // otherwise the incremental id should be taken into account.
  tearDown(() async {
    await AppDatabase.instance.deleteDatabase();
  });

  group("get words", () {
    test("get words length", () async {
      await init();

      final res = await repo.getWords();
      expect(res.length, 3);
    });

    test("get words empty list", () async {
      await init();

      wordBox.removeAll();
      final res = await repo.getWords();
      expect(res.length, 0);
    });
  });

  group("get word", () {
    test("get word with existing id", () async {
      await init();

      final res1 = await repo.getWord(1);
      expect(res1, isNotNull);
      expect(res1!.id, 1);

      final res2 = await repo.getWord(2);
      expect(res2, isNotNull);
      expect(res2!.id, 2);

      final res3 = await repo.getWord(3);
      expect(res3, isNotNull);
      expect(res3!.id, 3);
    });

    test("get word with not valid id", () async {
      await init();

      final res1 = await repo.getWord(0);
      expect(res1, isNull);

      final res2 = await repo.getWord(-1);
      expect(res2, isNull);

      final res3 = await repo.getWord(-100);
      expect(res3, isNull);
    });

    test("get word with not existing id", () async {
      await init();

      final res1 = await repo.getWord(4);
      expect(res1, isNull);

      final res2 = await repo.getWord(5);
      expect(res2, isNull);

      final res3 = await repo.getWord(42);
      expect(res3, isNull);
    });
  });

  group('insert word', () {
    test('Testing simple insertion', () async {
      await init();

      wordBox.removeAll();
      reviewBox.removeAll();
      expect(wordBox.getAll().length, 0);

      final res = await repo.addWord(words[0]);
      expect(res, 1, reason: "Id should've been 1");
      expect(wordBox.getAll().length, 1, reason: "# elements should've been 1");
    });

    test('Testing word-reviews relations', () async {
      await init();

      wordBox.removeAll();
      reviewBox.removeAll();
      final res = await repo.addWord(words[0]);
      final word = wordBox.get(res);

      expect(word?.meaningReview.target, isNotNull);
      expect(word?.readingReview.target, isNotNull);
      expect(wordBox.getAll().length, 1);
      expect(reviewBox.getAll().length, 2);
    });
  });
}
