import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_button/group_button.dart';
import 'package:japanese_vocabulary/bloc/review_bloc.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/review_session_screen.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/next_review_button.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_answer.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_hint.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_hint_button.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_item.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_quality_selector.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/show_button.dart';
import 'package:japanese_vocabulary/ui/widgets/loading_indicator.dart';
import 'package:mocktail/mocktail.dart';

import '../utils/mocks.dart';
import '../utils/params.dart';

void main() {
  late ReviewBloc bloc;

  setUp(() {
    bloc = MockReviewBloc();
  });

  tearDown(() {
    bloc.close();
  });

  setUpWidget(WidgetTester tester, Review review, {bool isLast = false}) async {
    when(() => bloc.state).thenReturn(ReviewInitial());

    // Provide a review for the test
    final state = ReviewLoaded(review: review, isLast: isLast);
    when(() => bloc.state).thenReturn(state);

    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const ReviewSessionScreen(),
        ),
      ),
    );
  }

  testWidgets("check loading", (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(ReviewLoading());

    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const ReviewSessionScreen(),
        ),
      ),
    );

    final loadingFinder = find.byType(LoadingIndicator);
    expect(loadingFinder, findsOneWidget);
  });

  testWidgets("review without associated words", (WidgetTester tester) async {
    await setUpWidget(tester, review1);

    expect(find.text("Error"), findsOneWidget);
  });

  testWidgets("check correct answer", (WidgetTester tester) async {
    await setUpWidget(tester, meaningReviewWithWord);

    final answer = meaningReviewWithWord.word.target?.meaning;
    expect(answer, isNotNull);

    final reviewAnswerFinder = find.widgetWithText(ReviewAnswer, answer!);

    expect(
      reviewAnswerFinder,
      findsOneWidget,
      reason: "The correct answer should be $answer.",
    );
  });

  testWidgets("show / hide answer", (WidgetTester tester) async {
    await setUpWidget(tester, readingReviewWithWord);

    final reviewItemFinder = find.byType(ReviewItem);
    expect(
      reviewItemFinder,
      findsOneWidget,
      reason: "There should be one ReviewItem.",
    );

    final showButtonFinder = find.widgetWithText(ShowButton, "SHOW");
    expect(
      showButtonFinder,
      findsOneWidget,
      reason: "The show button should exist and display 'show' as text.",
    );

    final hideButtonFinder = find.widgetWithText(ShowButton, "HIDE");
    expect(
      hideButtonFinder,
      findsNothing,
      reason: "The show button should exist and display 'hide' as text.",
    );

    final answerFinder = find.byType(ReviewAnswer);
    expect(
      answerFinder,
      findsOneWidget,
      reason: "There should be one ReviewAnswer.",
    );

    final reviewAnswer = tester.widget<ReviewAnswer>(answerFinder.first);
    expect(
      reviewAnswer.hidden.value,
      true,
      reason: "The value should be true.",
    );

    // Show answer
    await tester.tap(showButtonFinder.first);
    await tester.pump();

    expect(
      reviewAnswer.hidden.value,
      false,
      reason: "The value should be false.",
    );

    expect(hideButtonFinder, findsOneWidget);
    expect(showButtonFinder, findsNothing);

    // Hide answer
    await tester.tap(hideButtonFinder.first);
    await tester.pump();

    expect(
      reviewAnswer.hidden.value,
      true,
      reason: "The value should be true.",
    );

    expect(hideButtonFinder, findsNothing);
    expect(showButtonFinder, findsOneWidget);
  });

  group("check next / summary button", () {
    Future<List<Finder>> findButtons(find) async {
      final nextReviewButtonFinder = find.byType(NextReviewButton);

      final nextButtonFinder = find.descendant(
        of: nextReviewButtonFinder.first,
        matching: find.text("NEXT"),
      );
      final summaryButtonFinder = find.descendant(
        of: nextReviewButtonFinder.first,
        matching: find.text("SUMMARY"),
      );

      return [nextButtonFinder, summaryButtonFinder];
    }

    testWidgets("show next button when the current review is not the last",
        (WidgetTester tester) async {
      await setUpWidget(tester, readingReviewWithWord, isLast: false);

      final buttons = await findButtons(find);
      final nextButtonFinder = buttons[0];
      final summaryButtonFinder = buttons[1];

      expect(nextButtonFinder, findsOneWidget);
      expect(summaryButtonFinder, findsNothing);
    });

    testWidgets("show summary button when the current review is the last",
        (WidgetTester tester) async {
      await setUpWidget(tester, readingReviewWithWord, isLast: true);

      final buttons = await findButtons(find);
      final nextButtonFinder = buttons[0];
      final summaryButtonFinder = buttons[1];

      expect(nextButtonFinder, findsNothing);
      expect(summaryButtonFinder, findsOneWidget);
    });
  });

  testWidgets("the review is updated when the next button is tapped.",
      (WidgetTester tester) async {
    final review = meaningReviewWithWord;
    await setUpWidget(tester, review);

    final wordText = review.word.target!.text;

    final wordTextFinder = find.widgetWithText(ReviewItem, wordText);
    expect(
      wordTextFinder,
      findsOneWidget,
      reason: "There word text of the current review should be $wordText",
    );

    final answerFinder = find.byType(ReviewAnswer);
    expect(
      answerFinder,
      findsOneWidget,
      reason: "There should be one ReviewAnswer.",
    );

    final showButtonFinder = find.widgetWithText(TextButton, "SHOW");
    expect(
      showButtonFinder,
      findsOneWidget,
      reason: "The show button should exist.",
    );

    // Show answer
    await tester.tap(showButtonFinder.first);
    await tester.pump();

    final groupButtonFinder = find.byType(GroupButton);
    expect(
      groupButtonFinder,
      findsOneWidget,
      reason: "The GroupButton widget should exist.",
    );
    final button4 = find.descendant(
      of: groupButtonFinder.first,
      matching: find.text("4"),
    );

    // Select the quality value 4
    await tester.tap(button4.first);
    await tester.pump();

    final nextReviewTextFinder = find.widgetWithText(TextButton, "NEXT");
    expect(
      nextReviewTextFinder,
      findsOneWidget,
      reason: "The next button should exist.",
    );

    final nextReviewButtonFinder = find.descendant(
      of: find.byType(NextReviewButton),
      matching: find.byType(TextButton),
    );

    // Tap on next button
    await tester.tap(nextReviewButtonFinder.first);
    await tester.pump();

    verify(() {
      bloc.add(ReviewSessionUpdated(review: review, quality: 4));
    }).called(1);
  });

  group('reading hint', () {
    testWidgets("no hint asked and answer hidden", (WidgetTester tester) async {
      await setUpWidget(tester, readingReviewWithWord);

      final groupButtonFinder = find.descendant(
        of: find.byType(ReviewQualitySelector),
        matching: find.byType(GroupButton),
      );
      expect(groupButtonFinder, findsOneWidget);

      final GroupButton groupButton = tester.widget(groupButtonFinder);
      expect(
          groupButton.controller!.disabledIndexes, equals([0, 1, 2, 3, 4, 5]));
      expect(groupButton.controller!.selectedIndex, isNull);
    });

    testWidgets("no hint asked and answer shown", (WidgetTester tester) async {
      await setUpWidget(tester, readingReviewWithWord);

      // tap show button
      final showButtonFinder = find.widgetWithText(ShowButton, "SHOW");
      await tester.tap(showButtonFinder.first);
      await tester.pump();

      final groupButtonFinder = find.descendant(
        of: find.byType(ReviewQualitySelector),
        matching: find.byType(GroupButton),
      );
      expect(groupButtonFinder, findsOneWidget);

      final GroupButton groupButton = tester.widget(groupButtonFinder);
      expect(groupButton.controller!.disabledIndexes, equals([]));
      expect(groupButton.controller!.selectedIndex, isNull);
    });

    testWidgets("check hints", (WidgetTester tester) async {
      expectOnHintAsked(
        Finder groupButtonFinder,
        int n,
        String hintText,
        List<int> disabledValues,
      ) {
        final GroupButton groupButton = tester.widget(groupButtonFinder);
        expect(find.widgetWithText(ReviewHintButton, "$n"), findsOneWidget);
        expect(find.widgetWithText(ReviewHint, hintText), findsOneWidget);
        expect(groupButton.controller!.disabledIndexes, equals(disabledValues));
      }

      await setUpWidget(tester, readingReviewWithWord);

      final reading = readingReviewWithWord.word.target!.reading;

      final hintButtonFinder = find.byType(ReviewHintButton);
      expect(hintButtonFinder, findsOneWidget);

      final qualitySelectorFinder = find.byType(ReviewQualitySelector);
      expect(qualitySelectorFinder, findsOneWidget);

      final groupButtonFinder = find.descendant(
        of: qualitySelectorFinder,
        matching: find.byType(GroupButton),
      );
      expect(groupButtonFinder, findsOneWidget);

      // tap show button
      final showButtonFinder = find.widgetWithText(ShowButton, "SHOW");
      await tester.tap(showButtonFinder.first);
      await tester.pump();

      String hintText = "＿＿＿＿＿";
      expectOnHintAsked(groupButtonFinder, 5, hintText, []);

      // ask hint
      await tester.tap(hintButtonFinder.first);
      await tester.pump();

      hintText = "${reading.substring(0, 1)}＿＿＿＿";
      expectOnHintAsked(groupButtonFinder, 4, hintText, [5]);

      // ask hint
      await tester.tap(hintButtonFinder.first);
      await tester.pump();

      hintText = "${reading.substring(0, 2)}＿＿＿";
      expectOnHintAsked(groupButtonFinder, 3, hintText, [5]);

      // ask hint
      await tester.tap(hintButtonFinder.first);
      await tester.pump();

      hintText = "${reading.substring(0, 3)}＿＿";
      expectOnHintAsked(groupButtonFinder, 2, hintText, [3, 4, 5]);

      // ask hint
      await tester.tap(hintButtonFinder.first);
      await tester.pump();

      hintText = "${reading.substring(0, 4)}＿";
      expectOnHintAsked(groupButtonFinder, 1, hintText, [3, 4, 5]);

      // ask hint
      await tester.tap(hintButtonFinder.first);
      await tester.pump();

      expectOnHintAsked(groupButtonFinder, 0, reading, [1, 2, 3, 4, 5]);
    });
  });

  group('meaning hint', () {

    testWidgets("no hint asked and answer hidden", (WidgetTester tester) async {
      await setUpWidget(tester, meaningReviewWithWord);

      final groupButtonFinder = find.descendant(
        of: find.byType(ReviewQualitySelector),
        matching: find.byType(GroupButton),
      );
      expect(groupButtonFinder, findsOneWidget);

      final GroupButton groupButton = tester.widget(groupButtonFinder);
      expect(
          groupButton.controller!.disabledIndexes, equals([0, 1, 2, 3, 4, 5]));
      expect(groupButton.controller!.selectedIndex, isNull);
    });

    testWidgets("no hint asked and answer shown", (WidgetTester tester) async {
      await setUpWidget(tester, meaningReviewWithWord);

      // tap show button
      final showButtonFinder = find.widgetWithText(ShowButton, "SHOW");
      await tester.tap(showButtonFinder.first);
      await tester.pump();

      final groupButtonFinder = find.descendant(
        of: find.byType(ReviewQualitySelector),
        matching: find.byType(GroupButton),
      );
      expect(groupButtonFinder, findsOneWidget);

      final GroupButton groupButton = tester.widget(groupButtonFinder);
      expect(groupButton.controller!.disabledIndexes, equals([]));
      expect(groupButton.controller!.selectedIndex, isNull);
    });

    testWidgets("check hints", (WidgetTester tester) async {
      expectOnHintAsked(
        Finder groupButtonFinder,
        int n,
        String hintText,
        List<int> disabledValues,
      ) {
        final GroupButton groupButton = tester.widget(groupButtonFinder);
        expect(find.widgetWithText(ReviewHintButton, "$n"), findsOneWidget);
        expect(find.widgetWithText(ReviewHint, hintText), findsOneWidget);
        expect(groupButton.controller!.disabledIndexes, equals(disabledValues));
      }

      await setUpWidget(tester, meaningReviewWithWord);

      final sentences = meaningReviewWithWord.word.target!.sentences;

      final hintButtonFinder = find.byType(ReviewHintButton);
      expect(hintButtonFinder, findsOneWidget);

      final qualitySelectorFinder = find.byType(ReviewQualitySelector);
      expect(qualitySelectorFinder, findsOneWidget);

      final groupButtonFinder = find.descendant(
        of: qualitySelectorFinder,
        matching: find.byType(GroupButton),
      );
      expect(groupButtonFinder, findsOneWidget);

      // tap show button
      final showButtonFinder = find.widgetWithText(ShowButton, "SHOW");
      await tester.tap(showButtonFinder.first);
      await tester.pump();

      String hintText = "";
      final GroupButton groupButton = tester.widget(groupButtonFinder);
      expect(find.widgetWithText(ReviewHintButton, "3"), findsOneWidget);
      expect(groupButton.controller!.disabledIndexes, equals([]));

      // ask hint 1
      await tester.tap(hintButtonFinder.first);
      await tester.pump();

      hintText = sentences[0].text;
      expectOnHintAsked(groupButtonFinder, 2, hintText, [5]);

      // ask hint 2
      await tester.tap(hintButtonFinder.first);
      await tester.pump();

      hintText = sentences[1].text;
      expectOnHintAsked(groupButtonFinder, 1, hintText, [4, 5]);

      // ask hint 3
      await tester.tap(hintButtonFinder.first);
      await tester.pump();

      hintText = sentences[2].text;
      expectOnHintAsked(groupButtonFinder, 0, hintText, [4, 5]);
    });
  });

}
