import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_button/group_button.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/ui/widgets/word_insert_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../utils/params.dart';
import '../utils/mocks.dart';

void main() {
  late WordBloc bloc;

  setUp(() {
    bloc = MockWordBloc();
  });

  tearDown(() {
    bloc.close();
  });

  Future<void> setUpWidget(tester, Word? word) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: WordInsert(
            wordToAdd: word,
          ),
        ),
      ),
    );
  }

  testWidgets("no word as param", (WidgetTester tester) async {
    final state = WordInitial();
    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, null);
    final itemsFinder = find.widgetWithText(TextField, "");
    expect(itemsFinder, findsNWidgets(3));
    final itemsFinder2 = find.byType(GroupButton);
    final posBool = (tester.widget(itemsFinder2.first) as GroupButton)
        .controller
        ?.selectedIndexes
        .isEmpty;
    final jlptBool = (tester.widget(itemsFinder2.last) as GroupButton)
        .controller
        ?.selectedIndexes
        .isNotEmpty;
    expect(posBool, true);
    expect(jlptBool, true);
  });

  testWidgets("valid word with invalid pos as param",
      (WidgetTester tester) async {
    final state = WordInitial();
    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, word1);

    final itemsFinder = find.widgetWithText(TextField, "");
    expect(itemsFinder, findsNWidgets(0));

    final textCheck =
        (tester.widget(find.byKey(const Key("text"))) as TextField)
            .controller
            ?.text;
    final readingCheck =
        (tester.widget(find.byKey(const Key("reading"))) as TextField)
            .controller
            ?.text;
    final meaningCheck =
        (tester.widget(find.byKey(const Key("meaning"))) as TextField)
            .controller
            ?.text;

    expect(textCheck, equals("言葉"));
    expect(readingCheck, equals("ことば"));
    expect(meaningCheck, equals("word; phrase; expression; term"));

    final itemsFinder2 = find.byType(GroupButton);
    final posBool = (tester.widget(itemsFinder2.first) as GroupButton)
        .controller
        ?.selectedIndexes
        .isEmpty;
    final jlptBool = (tester.widget(itemsFinder2.last) as GroupButton)
        .controller
        ?.selectedIndexes
        .isNotEmpty;
    expect(posBool, true);
    expect(jlptBool, true);
  });

  testWidgets("word with valid pos as param", (WidgetTester tester) async {
    final state = WordInitial();
    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, word4);

    final itemsFinder = find.widgetWithText(TextField, "");
    expect(itemsFinder, findsNothing);

    final textCheck =
        (tester.widget(find.byKey(const Key("text"))) as TextField)
            .controller
            ?.text;
    final readingCheck =
        (tester.widget(find.byKey(const Key("reading"))) as TextField)
            .controller
            ?.text;
    final meaningCheck =
        (tester.widget(find.byKey(const Key("meaning"))) as TextField)
            .controller
            ?.text;

    expect(textCheck, equals("普通"));
    expect(readingCheck, equals("ふつう"));
    expect(meaningCheck, equals("normal; ordinary; regular"));

    final itemsFinder2 = find.byType(GroupButton);
    final posBool = (tester.widget(itemsFinder2.first) as GroupButton)
        .controller
        ?.selectedIndexes
        .containsAll([1, 11]);
    final jlptBool = (tester.widget(itemsFinder2.last) as GroupButton)
            .controller
            ?.selectedIndex ==
        1;
    expect(posBool, true);
    expect(jlptBool, true);
  });
}
