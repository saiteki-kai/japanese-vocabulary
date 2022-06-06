import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/models/sentence.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_hint_button.dart';
import 'package:japanese_vocabulary/utils/hint.dart';

import '../utils/params.dart';

void main() {
  setUpWidget(WidgetTester tester, Hint hint) async {
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Column(
            children: [
              ReviewHintButton(
                hint: ValueNotifier(hint),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('reading hint', () {
    testWidgets("initialized", (WidgetTester tester) async {
      final hint = ReadingHint(n: 0, max: 3, text: "", values: []);

      await setUpWidget(tester, hint);

      expect(find.text("3"), findsOneWidget);
    });

    testWidgets("first hint", (WidgetTester tester) async {
      final hint = ReadingHint(n: 1, max: 3, text: "に", values: []);

      await setUpWidget(tester, hint);

      expect(find.text("2"), findsOneWidget);
    });

    testWidgets("second hint", (WidgetTester tester) async {
      final hint = ReadingHint(n: 2, max: 3, text: "にほ", values: []);

      await setUpWidget(tester, hint);

      expect(find.text("1"), findsOneWidget);
    });

    testWidgets("last hint", (WidgetTester tester) async {
      final hint = ReadingHint(n: 3, max: 3, text: "にほん", values: []);

      await setUpWidget(tester, hint);

      expect(find.text("0"), findsOneWidget);
    });
  });

  group('meaning hint', () {
    testWidgets("initialized", (WidgetTester tester) async {
      final List<Sentence> sentences = [];
      final hint =
          MeaningHint(n: 0, max: 3, values: [0,1,2,3,4,5], currSentences: sentences);

      await setUpWidget(tester, hint);

      expect(find.text("3"), findsOneWidget);
    });

    testWidgets("first hint", (WidgetTester tester) async {
      final List<Sentence> sentences = [sentence1];
      final hint =
          MeaningHint(n: 1, max: 3, values: [0,1,2,3,4], currSentences: sentences);

      await setUpWidget(tester, hint);

      expect(find.text("2"), findsOneWidget);
    });

    testWidgets("second hint", (WidgetTester tester) async {
      final List<Sentence> sentences = [sentence1, sentence2];
      final hint =
          MeaningHint(n: 2, max: 3, values: [0,1,2,3], currSentences: sentences);

      await setUpWidget(tester, hint);

      expect(find.text("1"), findsOneWidget);
    });

    testWidgets("last hint", (WidgetTester tester) async {
      final List<Sentence> sentences = [sentence1, sentence2, sentence3];
      final hint =
          MeaningHint(n: 3, max: 3, values: [0,1,2,3], currSentences: sentences);

      await setUpWidget(tester, hint);

      expect(find.text("0"), findsOneWidget);
    });
  });
}
