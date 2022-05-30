import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/ui/screens/review_session_screen/widgets/review_hint_button.dart';
import 'package:japanese_vocabulary/utils/hints.dart';

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

  testWidgets("hint initialized", (WidgetTester tester) async {
    const hint = Hint(n: 0, max: 3, text: "", values: []);

    await setUpWidget(tester, hint);

    expect(find.text("3"), findsOneWidget);
  });

  testWidgets("first hint", (WidgetTester tester) async {
    const hint = Hint(n: 1, max: 3, text: "に", values: []);

    await setUpWidget(tester, hint);

    expect(find.text("2"), findsOneWidget);
  });

  testWidgets("second hint", (WidgetTester tester) async {
    const hint = Hint(n: 2, max: 3, text: "にほ", values: []);

    await setUpWidget(tester, hint);

    expect(find.text("1"), findsOneWidget);
  });

  testWidgets("last hint", (WidgetTester tester) async {
    const hint = Hint(n: 3, max: 3, text: "にほん", values: []);

    await setUpWidget(tester, hint);

    expect(find.text("0"), findsOneWidget);
  });
}
