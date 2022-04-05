import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/ui/screens/word_item.dart';

void main() {
  final Word word = Word(
      id: 0,
      text: "普通",
      reading: "ふつう",
      jlpt: 4,
      meaning: "normal; ordinary; regular",
      pos: "Noun, Na-adjective");

  testWidgets("Test widget view list, null case", (WidgetTester tester) async {
    await tester.pumpWidget(const WordItem(word: null));

    final textFinder = find.text("Error");
    expect(textFinder, findsOneWidget);
  });
}
