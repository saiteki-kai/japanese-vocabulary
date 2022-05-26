import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/utils/hint.dart';

import 'utils/params.dart';

void main() {
  group("word reading hints", () {
    group("invalid parameters", () {
      test("number of hints less or equal to zero", () {
        expect(
          () => ReadingHint(n: -1, max: 0, text: "", values: []),
          throwsAssertionError,
        );
      });

      test("number of hints exceeded", () {
        expect(
          () => ReadingHint(n: 2, max: 1, text: "", values: []),
          throwsAssertionError,
        );
      });
    });

    group("valid parameters", () {
      test("next of 1 character long reading", () {
        final word = wordReading1Char;
        final hint = ReadingHint.empty().getNextHint(word) as ReadingHint;
        expect(hint.text, equals(""));
        expect(hint.n, equals(0));
        expect(hint.max, equals(0));
        expect(hint.values, equals([0]));
      });

      test("2 characters", () {
        final word = wordReading2Char;
        final hint = ReadingHint.fromWord(word);
        expect(hint.text, equals(""));
        expect(hint.n, equals(0));
        expect(hint.max, equals(2));

        final hint1 = hint.getNextHint(word) as ReadingHint;
        expect(hint1.text, equals("う"));
        expect(hint1.n, equals(1));
        expect(hint1.max, equals(2));
        expect(hint1.values, equals([0, 1, 2, 3]));

        final hint2 = hint1.getNextHint(word) as ReadingHint;
        expect(hint2.text, equals("うん"));
        expect(hint2.n, equals(2));
        expect(hint2.max, equals(2));
        expect(hint2.values, equals([0]));
      });

      test("4 characters", () {
        final word = wordReading4Char;
        final hint = ReadingHint.fromWord(word);

        final hint1 = hint.getNextHint(word) as ReadingHint;
        expect(hint1.text, equals("た"));
        expect(hint1.values, equals([0, 1, 2, 3, 4]));

        final hint2 = hint1.getNextHint(word) as ReadingHint;
        expect(hint2.text, equals("たと"));
        expect(hint2.values, equals([0, 1, 2, 3]));

        final hint3 = hint2.getNextHint(word) as ReadingHint;
        expect(hint3.text, equals("たとえ"));
        expect(hint3.values, equals([0, 1, 2]));

        final hint4 = hint3.getNextHint(word) as ReadingHint;
        expect(hint4.text, equals("たとえば"));
        expect(hint4.values, equals([0]));
      });

      test("7 characters", () {
        final word = wordReading7Char;
        final hint = ReadingHint.fromWord(word);

        final hint1 = hint.getNextHint(word) as ReadingHint;
        expect(hint1.text, equals("ユ"));
        expect(hint1.values, equals([0, 1, 2, 3, 4]));

        final hint2 = hint1.getNextHint(word) as ReadingHint;
        expect(hint2.text, equals("ユニ"));
        expect(hint2.values, equals([0, 1, 2, 3, 4]));

        final hint3 = hint2.getNextHint(word) as ReadingHint;
        expect(hint3.text, equals("ユニッ"));
        expect(hint3.values, equals([0, 1, 2, 3]));

        final hint4 = hint3.getNextHint(word) as ReadingHint;
        expect(hint4.text, equals("ユニット"));
        expect(hint4.values, equals([0, 1, 2]));

        final hint5 = hint4.getNextHint(word) as ReadingHint;
        expect(hint5.text, equals("ユニットテ"));
        expect(hint5.values, equals([0, 1, 2]));

        final hint6 = hint5.getNextHint(word) as ReadingHint;
        expect(hint6.text, equals("ユニットテス"));
        expect(hint6.values, equals([0]));

        final hint7 = hint6.getNextHint(word) as ReadingHint;
        expect(hint7.text, equals("ユニットテスト"));
        expect(hint7.values, equals([0]));
      });
    });
  });

  group("word meaning hints", () {
    group("invalid parameters", () {
      test("number of hints less or equal to zero", () {
        expect(
          () => MeaningHint(n: -1, max: 0, currSentences: [], values: []),
          throwsAssertionError,
        );
      });

      test("number of hints exceeded", () {
        expect(
          () => MeaningHint(n: 2, max: 1, currSentences: [], values: []),
          throwsAssertionError,
        );
      });
    });

    group("valid parameters", () {
      test("ask hints from a word with no sentences", () {
        var hint = MeaningHint.fromWord(wordWithoutSentences);
        expect(hint.currSentences, equals([]));
        expect(hint.n, equals(0));
        expect(hint.max, equals(0));
        expect(hint.values, equals([0, 1, 2, 3, 4, 5]));

        hint = hint.getNextHint(wordWithoutSentences) as MeaningHint;
        expect(hint.currSentences, equals([]));
        expect(hint.n, equals(0));
        expect(hint.max, equals(0));
        expect(hint.values, equals([0, 1, 2, 3, 4, 5]));
      });

      test("ask hints from a word with 3 sentences", () {
        MeaningHint hint = MeaningHint.fromWord(wordWith3Sentences);
        final int length = wordWith3Sentences.sentences.length;
        expect(hint.currSentences, equals([]));
        expect(hint.n, lessThanOrEqualTo(length));
        expect(hint.max, equals(length));
        expect(hint.values, equals([0, 1, 2, 3, 4, 5]));

        // ask for first hint!
        hint = hint.getNextHint(wordWith3Sentences) as MeaningHint;
        expect(hint.currSentences, equals([sentence1]));
        expect(hint.n, lessThanOrEqualTo(length));
        expect(hint.max, equals(length));
        expect(hint.values, equals([0, 1, 2, 3, 4]));

        // ask for second hint!
        hint = hint.getNextHint(wordWith3Sentences) as MeaningHint;
        expect(hint.currSentences, equals([sentence1, sentence2]));
        expect(hint.n, lessThanOrEqualTo(length));
        expect(hint.max, equals(length));
        expect(hint.values, equals([0, 1, 2, 3]));

        // ask for third hint!
        hint = hint.getNextHint(wordWith3Sentences) as MeaningHint;
        expect(hint.currSentences, equals([sentence1, sentence2, sentence3]));
        expect(hint.n, lessThanOrEqualTo(length));
        expect(hint.max, equals(length));
        expect(hint.values, equals([0, 1, 2, 3]));
      });
    });
  });
}
