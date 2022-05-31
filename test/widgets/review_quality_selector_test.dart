import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_button/group_button.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_quality_selector.dart';
import 'package:japanese_vocabulary/utils/hint.dart';

import '../utils/params.dart';

void main() {
  setupWidget(WidgetTester tester, {Hint? hint, bool? disabled}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReviewQualitySelector(
          disabled: ValueNotifier(disabled ?? false),
          hint: ValueNotifier(hint ?? ReadingHint.empty()),
          onQualitySelected: (_) {},
        ),
      ),
    );
  }

  testWidgets("no enabled options when disabled", (WidgetTester tester) async {
    await setupWidget(tester, disabled: true);

    final finder = find.byType(GroupButton);
    expect(finder, findsOneWidget);

    final GroupButton groupButton = tester.widget(finder);
    expect(groupButton.controller!.disabledIndexes, equals([0, 1, 2, 3, 4, 5]));
    expect(groupButton.controller!.selectedIndex, isNull);
  });

  group("check the available options when asked for an hint", () {
    group("reading hint", () {
      testWidgets("all options available when no hints are shown",
          (WidgetTester tester) async {
        final hint =
            ReadingHint(n: 0, max: 3, text: "", values: [0, 1, 2, 3, 4, 5]);
        await setupWidget(tester, hint: hint, disabled: false);

        final finder = find.byType(GroupButton);

        final GroupButton groupButton = tester.widget(finder);
        expect(groupButton.controller!.disabledIndexes, equals([]));
      });

      testWidgets("first hint", (WidgetTester tester) async {
        final hint =
            ReadingHint(n: 1, max: 3, text: "", values: [0, 1, 2, 3, 4]);
        await setupWidget(tester, hint: hint, disabled: false);

        final finder = find.byType(GroupButton);

        final GroupButton groupButton = tester.widget(finder);
        expect(groupButton.controller!.disabledIndexes, equals([5]));
      });

      testWidgets("second hint", (WidgetTester tester) async {
        final hint = ReadingHint(n: 2, max: 3, text: "", values: [0, 1, 2]);
        await setupWidget(tester, hint: hint, disabled: false);

        final finder = find.byType(GroupButton);

        final GroupButton groupButton = tester.widget(finder);
        expect(groupButton.controller!.disabledIndexes, equals([3, 4, 5]));
      });

      testWidgets("last hint", (WidgetTester tester) async {
        final hint = ReadingHint(n: 3, max: 3, text: "", values: [0]);
        await setupWidget(tester, hint: hint, disabled: false);

        final finder = find.byType(GroupButton);

        final GroupButton groupButton = tester.widget(finder);
        expect(
            groupButton.controller!.disabledIndexes, equals([1, 2, 3, 4, 5]));
      });
    });

    group("meaning hint", () {
      testWidgets("all options available when no hints are shown",
          (WidgetTester tester) async {
        final hint = MeaningHint(
            n: 0, max: 3, currSentences: [], values: [0, 1, 2, 3, 4, 5]);
        await setupWidget(tester, hint: hint, disabled: false);

        final finder = find.byType(GroupButton);

        final GroupButton groupButton = tester.widget(finder);
        expect(groupButton.controller!.disabledIndexes, equals([]));
      });

      testWidgets("first hint", (WidgetTester tester) async {
        final hint = MeaningHint(
            n: 1, max: 3, currSentences: [sentence1], values: [0, 1, 2, 3, 4]);
        await setupWidget(tester, hint: hint, disabled: false);

        final finder = find.byType(GroupButton);

        final GroupButton groupButton = tester.widget(finder);
        expect(groupButton.controller!.disabledIndexes, equals([5]));
      });

      testWidgets("second hint", (WidgetTester tester) async {
        final hint = MeaningHint(
            n: 2,
            max: 3,
            currSentences: [sentence1, sentence2],
            values: [0, 1, 2, 3]);
        await setupWidget(tester, hint: hint, disabled: false);

        final finder = find.byType(GroupButton);

        final GroupButton groupButton = tester.widget(finder);
        expect(groupButton.controller!.disabledIndexes, equals([4, 5]));
      });

      testWidgets("last hint", (WidgetTester tester) async {
        final hint = MeaningHint(
            n: 3,
            max: 3,
            currSentences: [sentence1, sentence2, sentence3],
            values: [0, 1, 2, 3]);
        await setupWidget(tester, hint: hint, disabled: false);

        final finder = find.byType(GroupButton);

        final GroupButton groupButton = tester.widget(finder);
        expect(groupButton.controller!.disabledIndexes, equals([4, 5]));
      });
    });
  });
}
