import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/ui/screens/word_item.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  testWidgets("Test widget view list, null case", (WidgetTester tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WordItem(word: null))));

    expect(find.byType(CircularPercentIndicator), findsOneWidget);
    expect(find.text("Error"), findsOneWidget);
  });
}
