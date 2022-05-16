import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/utils/hints.dart';

void main() {
  group("word reading hints", () {
    group("invalid parameters", () {
      test("empty text", () {
        final hint = getReadingHint("", 0);
        expect(hint, isNull);
      });

      test("number of hints less or equal to zero", () {
        expect(
          () => getReadingHint("たとえば", 0),
          throwsA(const TypeMatcher<FormatException>()),
        );
        expect(
          () => getReadingHint("たとえば", -1),
          throwsA(const TypeMatcher<FormatException>()),
        );
      });

      test("number of hints exceeded", () {
        expect(
          () => getReadingHint("たとえば", 5),
          throwsA(const TypeMatcher<FormatException>()),
        );
      });
    });

    group("valid parameters", () {
      test("2 characters", () {
        const reading = "うん";

        final hint1 = getReadingHint(reading, 1);
        expect(hint1?.text, equals("う"));
        expect(hint1?.values, equals([0, 1, 2, 3]));

        final hint2 = getReadingHint(reading, 2);
        expect(hint2?.text, equals("うん"));
        expect(hint2?.values, equals([]));
      });

      test("4 characters", () {
        const reading = "たとえば";

        final hint1 = getReadingHint(reading, 1);
        expect(hint1?.text, equals("た"));
        expect(hint1?.values, equals([0, 1, 2, 3, 4]));

        final hint2 = getReadingHint(reading, 2);
        expect(hint2?.text, equals("たと"));
        expect(hint2?.values, equals([0, 1, 2, 3]));

        final hint3 = getReadingHint(reading, 3);
        expect(hint3?.text, equals("たとえ"));
        expect(hint3?.values, equals([0, 1, 2]));

        final hint4 = getReadingHint(reading, 4);
        expect(hint4?.text, equals("たとえば"));
        expect(hint4?.values, equals([]));
      });

      test("7 characters", () {
        const reading = "ユニットテスト";

        final hint1 = getReadingHint(reading, 1);
        expect(hint1?.text, equals("ユ"));
        expect(hint1?.values, equals([0, 1, 2, 3, 4]));

        final hint2 = getReadingHint(reading, 2);
        expect(hint2?.text, equals("ユニ"));
        expect(hint2?.values, equals([0, 1, 2, 3, 4]));

        final hint3 = getReadingHint(reading, 3);
        expect(hint3?.text, equals("ユニッ"));
        expect(hint3?.values, equals([0, 1, 2, 3]));

        final hint4 = getReadingHint(reading, 4);
        expect(hint4?.text, equals("ユニット"));
        expect(hint4?.values, equals([0, 1, 2]));

        final hint5 = getReadingHint(reading, 5);
        expect(hint5?.text, equals("ユニットテ"));
        expect(hint5?.values, equals([0, 1, 2]));

        final hint6 = getReadingHint(reading, 6);
        expect(hint6?.text, equals("ユニットテス"));
        expect(hint6?.values, equals([]));

        final hint7 = getReadingHint(reading, 7);
        expect(hint7?.text, equals("ユニットテスト"));
        expect(hint7?.values, equals([]));
      });
    });
  });
}
