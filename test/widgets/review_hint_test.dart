import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_hint.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_meaning_hint.dart';
import 'package:japanese_vocabulary/utils/hint.dart';

import '../utils/params.dart';

void main() {
  setUpWidget(WidgetTester tester, Hint hint) async {
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: ReviewHint(hint: ValueNotifier(hint)),
      ),
    );
  }

  group('reading hint', () {
    testWidgets("initialized", (WidgetTester tester) async {
      final hint = ReadingHint(n: 0, max: 3, text: "", values: []);

      await setUpWidget(tester, hint);

      expect(find.text("＿＿＿"), findsOneWidget);
    });

    testWidgets("first hint", (WidgetTester tester) async {
      final hint = ReadingHint(n: 1, max: 3, text: "に", values: []);

      await setUpWidget(tester, hint);

      expect(find.text("に＿＿"), findsOneWidget);
    });

    testWidgets("second hint", (WidgetTester tester) async {
      final hint = ReadingHint(n: 2, max: 3, text: "にほ", values: []);

      await setUpWidget(tester, hint);

      expect(find.text("にほ＿"), findsOneWidget);
    });

    testWidgets("last hint", (WidgetTester tester) async {
      final hint = ReadingHint(n: 3, max: 3, text: "にほん", values: []);

      await setUpWidget(tester, hint);

      expect(find.text("にほん"), findsOneWidget);
    });
  });

  group('meaning hint', () {
    testWidgets("initialized", (WidgetTester tester) async {
      final hint = MeaningHint(n: 0, max: 3, currSentences: [], values: []);

      await setUpWidget(tester, hint);

      final finder = find.byType(ReviewMeaningHint);
      expect(finder, findsNothing);
    });

    testWidgets("first hint", (WidgetTester tester) async {
      final hint = MeaningHint(
        n: 1,
        max: 3,
        currSentences: [sentence1],
        values: [0, 1, 2, 3, 4, 5],
      );

      await setUpWidget(tester, hint);

      final finder = find.byType(PageView);
      final PageView mywidget = tester.widget(finder);
      expect(mywidget.controller.page, equals(0));

      expect(find.text(sentence1.text), findsOneWidget);
    });

    testWidgets("second hint", (WidgetTester tester) async {
      final hint = MeaningHint(
        n: 2,
        max: 3,
        currSentences: [sentence1, sentence2],
        values: [0, 1, 2, 3, 4, 5],
      );

      await setUpWidget(tester, hint);

      final finder = find.byType(PageView);
      final PageView mywidget = tester.widget(finder);
      expect(mywidget.controller.page, equals(1));

      expect(find.text(sentence2.text), findsOneWidget);

      mywidget.controller.jumpToPage(0);
      await tester.pump();

      expect(find.text(sentence1.text), findsOneWidget);
    });

    testWidgets("last hint", (WidgetTester tester) async {
      final hint = MeaningHint(
        n: 3,
        max: 3,
        currSentences: [sentence1, sentence2, sentence3],
        values: [0, 1, 2, 3, 4, 5],
      );

      await setUpWidget(tester, hint);

      final finder = find.byType(PageView);
      final PageView mywidget = tester.widget(finder);
      expect(mywidget.controller.page, equals(2));

      expect(find.text(sentence3.text), findsOneWidget);

      mywidget.controller.jumpToPage(1);
      await tester.pump();
      expect(find.text(sentence2.text), findsOneWidget);

      mywidget.controller.jumpToPage(0);
      await tester.pump();
      expect(find.text(sentence1.text), findsOneWidget);
    });
  });
}
