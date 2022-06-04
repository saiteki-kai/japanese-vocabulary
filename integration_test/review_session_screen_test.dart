import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_button/group_button.dart';
import 'package:integration_test/integration_test.dart';
import 'package:japanese_vocabulary/bloc/review_bloc.dart';
import 'package:japanese_vocabulary/data/app_database.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/repositories/review_repository.dart';

import 'package:japanese_vocabulary/objectbox.g.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/review_session_screen.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/next_review_button.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/show_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../test/utils/params.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Store store;
  late ReviewRepository repo;
  late ReviewBloc bloc;

  setUp(() async {
    store = await AppDatabase.instance.store;
    repo = ReviewRepository(box: Future.value(store.box<Review>()));
    bloc = ReviewBloc(repository: repo);
  });

  tearDown(() async {
    bloc.close();
    store.close();
    await AppDatabase.instance.deleteDatabase();
  });

  Future<void> setUpReviewSession(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc..add(ReviewSessionStarted()),
          child: const ReviewSessionScreen(),
        ),
      ),
    );
  }

  Future<void> pressNextButton(WidgetTester tester) async {
    final showButtonFinder = find.byType(ShowButton);
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
    expect(nextReviewTextFinder, findsOneWidget);

    final nextReviewButtonFinder = find.descendant(
      of: find.byType(NextReviewButton),
      matching: find.byType(TextButton),
    );

    // Tap on next button
    await tester.tap(nextReviewButtonFinder.first);
    await tester.pump();
  }

  void checkPercentage(
    WidgetTester tester,
    int current,
    int total,
  ) {
    expect(find.text("$current/$total"), findsOneWidget);

    final progressFinder = find.byType(LinearPercentIndicator);
    expect(progressFinder, findsOneWidget);

    final LinearPercentIndicator indicator = tester.widget(progressFinder);
    expect(indicator.percent, equals(current / total));
  }

  testWidgets("review without word", (WidgetTester tester) async {
    await repo.updateReview(review1);
    await setUpReviewSession(tester);

    expect(find.text("Error"), findsOneWidget);
    expect(find.byType(LinearPercentIndicator), findsNothing);
  });

  testWidgets("review session with 1 review", (WidgetTester tester) async {
    await repo.updateReview(readingReviewWithWord);
    await setUpReviewSession(tester);

    checkPercentage(tester, 1, 1);
  });

  testWidgets("review session with 3 reviews", (WidgetTester tester) async {
    await repo.updateReview(readingReviewWithWord);
    await repo.updateReview(meaningReviewWithWord);
    await repo.updateReview(review1..word.target = word3);

    await setUpReviewSession(tester);
    await tester.pumpAndSettle();

    checkPercentage(tester, 1, 3);

    await pressNextButton(tester);
    checkPercentage(tester, 2, 3);

    await pressNextButton(tester);
    checkPercentage(tester, 3, 3);
  });
}
