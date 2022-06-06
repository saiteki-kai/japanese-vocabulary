import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/utils/sm2.dart';

void main() {
  final review = Review(
    ef: 2.5,
    interval: 0,
    repetition: 0,
    correctAnswers: 0,
    incorrectAnswers: 0,
    nextDate: DateTime.now(),
    type: "meaning",
  );

  // correct inputs
  for (var q in [0, 1, 2, 3, 4, 5]) {
    test("quality $q", () {
      expect(() => SM2.schedule(review, q), returnsNormally);
    });
  }

  // incorrect inputs
  for (int q in [-1, 6]) {
    test("quality $q", () {
      expect(
        () => SM2.schedule(review, q),
        throwsA(const TypeMatcher<FormatException>()),
      );
    });
  }

  test("3 repetitions with max quality", () {
    final r1 = SM2.schedule(review, 5);

    expect(r1.ef.toStringAsPrecision(2), "2.6", reason: "ef should be 2.6");
    expect(r1.interval, 1, reason: "interval should be 1");
    expect(r1.repetition, 1, reason: "interval should be 1");

    final r2 = SM2.schedule(r1, 5);

    expect(r2.ef.toStringAsPrecision(2), "2.7", reason: "ef should be 2.7");
    expect(r2.interval, 6, reason: "interval should be 6");
    expect(r2.repetition, 2, reason: "interval should be 2");

    final r3 = SM2.schedule(r2, 5);

    expect(r3.ef.toStringAsPrecision(2), "2.8", reason: "ef should be 2.8");
    expect(r3.repetition, 3, reason: "interval should be 3");
    expect(r3.interval, 16, reason: "interval should be 16");
  });

  test("multiple repetitions", () {
    Review oldReview = review;

    final rnd = Random(42);

    for (var i = 0; i < 100; i++) {
      final quality = rnd.nextInt(6);
      Review newReview = SM2.schedule(oldReview, quality);

      // Only for test. Simulate the passing days by using the scheduled oldReview
      newReview = newReview.copyWith(
        nextDate: oldReview.nextDate?.add(Duration(days: newReview.interval)),
      );

      final newEF = double.parse(newReview.ef.toStringAsPrecision(2));
      final oldEF = double.parse(oldReview.ef.toStringAsPrecision(2));

      if (quality == 4) {
        expect(newEF, oldEF, reason: "ef should remain the same");
        expect(
          newReview.correctAnswers,
          equals(oldReview.correctAnswers + 1),
          reason: "the number of correct answers should be one greater",
        );
        expect(
          newReview.incorrectAnswers,
          equals(oldReview.incorrectAnswers),
          reason: "the number of incorrect answers should be the same",
        );
      }

      if (quality < 3) {
        expect(newEF, lessThanOrEqualTo(oldEF), reason: "ef should be lower");
        expect(newReview.repetition, 0, reason: "repetition should be 0");
        expect(
          newReview.nextDate?.millisecondsSinceEpoch ?? 0,
          greaterThan(oldReview.nextDate?.millisecondsSinceEpoch ?? -1),
          reason: "the next review date should be later than the old one",
        );
        expect(
          newReview.nextDate?.millisecondsSinceEpoch ?? 0,
          greaterThan(DateTime.now().millisecondsSinceEpoch),
          reason: "the next review date should be later",
        );
        expect(
          newReview.correctAnswers,
          equals(oldReview.correctAnswers),
          reason: "the number of correct answers should be the same",
        );
        expect(
          newReview.incorrectAnswers,
          equals(oldReview.incorrectAnswers + 1),
          reason: "the number of incorrect answers should be one greater",
        );
      }

      oldReview = newReview;
    }
  });
}
