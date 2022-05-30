import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/models/sort_option.dart';
import 'package:japanese_vocabulary/data/models/word.dart';

import 'utils/params.dart';

void main() {
  test("next review property", () {
    // word with one null next review date
    expect(wordsWithReview1.nextReview, equals(DateTime(2022)));

    // word with both null next review dates
    expect(wordsWithReview2.nextReview, isNull);

    // word with both next review dates
    expect(wordsWithReview3.nextReview, equals(DateTime(2024)));
  });

  test("accuracy property", () {
    // word with both reviews
    expect(
      wordsWithReview1.meanAccuracy.toStringAsPrecision(2),
      equals("0.58"),
    );

    // word with one review
    expect(
      wordsWithOneReview.meanAccuracy.toStringAsPrecision(2),
      equals("0.22"),
    );

    // word with no reviews
    expect(
      word1.meanAccuracy.toStringAsPrecision(2),
      equals("0.0"),
    );
  });

  group("sorting", () {
    List<Word> words = [];

    setUp(() {
      words = [wordsWithReview1, wordsWithReview2, wordsWithReview3];
    });

    for (SortField field in SortField.values) {
      group("sort by ${field.name}", () {
        test("ascending", () {
          final sorted = words
            ..sort((a, b) =>
                Word.sortBy(a, b, attribute: field, descending: false));

          expect(sorted, equals(expectedSorting[field]));
        });

        test("descending", () {
          final sorted = words
            ..sort((a, b) =>
                Word.sortBy(a, b, attribute: field, descending: true));

          expect(sorted, equals(expectedSorting[field]!.reversed));
        });
      });
    }
  });
}
