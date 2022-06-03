import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_session_appbar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() {
  setUpWidget(WidgetTester tester, int current, int total) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReviewSessionAppBar(current: current, total: total),
      ),
    );
  }

  testWidgets("progress 100%", (tester) async {
    await setUpWidget(tester, 1, 1);
    expect(find.text("1/1"), findsOneWidget);

    final progressFinder = find.byType(LinearPercentIndicator);
    expect(progressFinder, findsOneWidget);

    final LinearPercentIndicator indicator = tester.widget(progressFinder);
    expect(indicator.percent, equals(1 / 1));
  });

  testWidgets("valid values", (tester) async {
    await setUpWidget(tester, 3, 5);
    expect(find.text("3/5"), findsOneWidget);

    final progressFinder = find.byType(LinearPercentIndicator);
    expect(progressFinder, findsOneWidget);

    final LinearPercentIndicator indicator = tester.widget(progressFinder);
    expect(indicator.percent, equals(3 / 5));
  });

  testWidgets("invalid values", (tester) async {
    await setUpWidget(tester, 3, 0);
    expect(find.text("3/0"), findsOneWidget);

    final progressFinder = find.byType(LinearPercentIndicator);
    expect(progressFinder, findsOneWidget);

    final LinearPercentIndicator indicator = tester.widget(progressFinder);
    expect(indicator.percent, equals(0));
  });
}
