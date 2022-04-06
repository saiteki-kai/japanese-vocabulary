import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_item.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_type_tag.dart';
import 'utils/review.dart';

void main() {
  final readingReview = ReviewUtils.readingReviewWithWord;
  final meaningReview = ReviewUtils.meaningReviewWithWord;

  for (Review review in [readingReview, meaningReview]) {
    testWidgets("check reading review information",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReviewItem(
            hidden: ValueNotifier(false),
            review: review,
            onToggleAnswer: () {},
          ),
        ),
      );

      // check word text
      final wordTextFinder = find.text(review.word.target!.text);
      expect(
        wordTextFinder,
        findsOneWidget,
        reason: "the word text should be ${review.word.target!.text}",
      );

      // check if the type displayed is correct
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
}
