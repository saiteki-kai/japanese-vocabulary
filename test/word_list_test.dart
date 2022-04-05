import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/ui/screens/word_item.dart';

void main() {
  testWidgets("Test widget view list, null case", (WidgetTester tester) async {
    await tester.pumpWidget(const WordItem(word: null));

    final textFinder = find.text("Error");
    expect(textFinder, findsOneWidget);
  });
}
