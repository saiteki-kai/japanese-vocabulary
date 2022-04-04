import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';

import 'word_instances.dart';

void main() async {
  final store = await AppDatabase.instance.store;
  final box = store.box<Word>();
  final word_repository = WordRepository();
  final review_box = store.box<Review>();

  setUp(() {
    //print("setup");
    box.removeAll();
    review_box.removeAll();
    //print(review_box.getAll().toString());
  });
  tearDown(() {
    //print("teardown");
    box.removeAll();
    review_box.removeAll();
    //print(review_box.getAll().toString());
  });

  test('Testing simple insertion', () async {
    expect(box.getAll().length, 0);
    final res = await word_repository.addWord(WordTestInstances.word1);
    expect(res, 1, reason: "Id should've been 1");
    expect(box.getAll().length, 1, reason: "# elements should've been 1");
  });

  test('Testing word-reviews relations', () async {
    final res = await word_repository.addWord(WordTestInstances.word1);

    final word = box.get(res);
    expect(word?.meaningReview.target, isNotNull);
    expect(word?.readingReview.target, isNotNull);
    expect(box.getAll().length, 1);
    expect(review_box.getAll().length, 2);
    //print(review_box.getAll().toString());
    expect(
        review_box
            .getAll()
            .where((element) => element.word.targetId == res)
            .length,
        2);
  });
}
