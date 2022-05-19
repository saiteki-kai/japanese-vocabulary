import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/utils/hints.dart';

void main() {
  group("word reading hints", () {
    group("invalid parameters", () {
      test("number of hints less or equal to zero", () {
        expect(
          () => Hint(n: -1, max: 0, text: "", values: []),
          throwsAssertionError,
        );
      });

      test("number of hints exceeded", () {
        expect(
          () => Hint(n: 2, max: 1, text: "", values: []),
          throwsAssertionError,
        );
      });
    });

    group("valid parameters", () {
      test("next of 1 character long reading", () {
        final hint = Hint.empty().getNextReadingHint("あ");
        expect(hint.text, equals(""));
        expect(hint.n, equals(0));
        expect(hint.max, equals(0));
        expect(hint.values, equals([]));
      });

      test("2 characters", () {
        const reading = "うん";
        final hint = Hint.fromReading(reading);
        expect(hint.text, equals(""));
        expect(hint.n, equals(0));
        expect(hint.max, equals(2));

        final hint1 = hint.getNextReadingHint(reading);
        expect(hint1.text, equals("う"));
        expect(hint1.n, equals(1));
        expect(hint1.max, equals(2));
        expect(hint1.values, equals([0, 1, 2, 3]));

        final hint2 = hint1.getNextReadingHint(reading);
        expect(hint2.text, equals("うん"));
        expect(hint2.n, equals(2));
        expect(hint2.max, equals(2));
        expect(hint2.values, equals([]));
      });

      test("4 characters", () {
        const reading = "たとえば";
        final hint = Hint.fromReading(reading);

        final hint1 = hint.getNextReadingHint(reading);
        expect(hint1.text, equals("た"));
        expect(hint1.values, equals([0, 1, 2, 3, 4]));

        final hint2 = hint1.getNextReadingHint(reading);
        expect(hint2.text, equals("たと"));
        expect(hint2.values, equals([0, 1, 2, 3]));

        final hint3 = hint2.getNextReadingHint(reading);
        expect(hint3.text, equals("たとえ"));
        expect(hint3.values, equals([0, 1, 2]));

        final hint4 = hint3.getNextReadingHint(reading);
        expect(hint4.text, equals("たとえば"));
        expect(hint4.values, equals([]));
      });

      test("7 characters", () {
        const reading = "ユニットテスト";
        final hint = Hint.fromReading(reading);

        final hint1 = hint.getNextReadingHint(reading);
        expect(hint1.text, equals("ユ"));
        expect(hint1.values, equals([0, 1, 2, 3, 4]));

        final hint2 = hint1.getNextReadingHint(reading);
        expect(hint2.text, equals("ユニ"));
        expect(hint2.values, equals([0, 1, 2, 3, 4]));

        final hint3 = hint2.getNextReadingHint(reading);
        expect(hint3.text, equals("ユニッ"));
        expect(hint3.values, equals([0, 1, 2, 3]));

        final hint4 = hint3.getNextReadingHint(reading);
        expect(hint4.text, equals("ユニット"));
        expect(hint4.values, equals([0, 1, 2]));

        final hint5 = hint4.getNextReadingHint(reading);
        expect(hint5.text, equals("ユニットテ"));
        expect(hint5.values, equals([0, 1, 2]));

        final hint6 = hint5.getNextReadingHint(reading);
        expect(hint6.text, equals("ユニットテス"));
        expect(hint6.values, equals([]));

        final hint7 = hint6.getNextReadingHint(reading);
        expect(hint7.text, equals("ユニットテスト"));
        expect(hint7.values, equals([]));
      });
    });
  });
}
