import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_item.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_type_tag.dart';
import 'package:japanese_vocabulary/utils/hints.dart';

import '../utils/params.dart';

void main() {
  final readingReview = readingReviewWithWord;
  final meaningReview = meaningReviewWithWord;

  setupWidget(WidgetTester tester, Review review) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReviewItem(
          hidden: ValueNotifier(false),
          review: review,
          onToggleAnswer: () {},
          hint: ValueNotifier(Hint.empty()),
          onAskHint: () {},
        ),
      ),
    );
  }

  group("reading review information", () {
    for (Review review in [readingReview, meaningReview]) {
      testWidgets("word text", (WidgetTester tester) async {
        await setupWidget(tester, review);

        final wordTextFinder = find.text(review.word.target!.text);
        expect(
          wordTextFinder,
          findsOneWidget,
          reason: "the word text should be ${review.word.target!.text}",
        );
      });

      testWidgets("check if the type displayed is correct",
          (WidgetTester tester) async {
        await setupWidget(tester, review);

        final typeTextFinder = find.widgetWithText(
          ReviewTypeTag,
          review.type.toUpperCase(),
        );
        expect(
          typeTextFinder,
          findsOneWidget,
          reason: "the review type should be ${review.type}",
        );
      });
    }
  });
}
