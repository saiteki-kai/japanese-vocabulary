import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_button/group_button.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/ui/widgets/sentence.dart';
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
    expect(itemsFinder, findsNWidgets(5));
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
    expect(itemsFinder, findsNWidgets(2));

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
    expect(itemsFinder, findsNWidgets(2));

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
  testWidgets("add sentence with empty or partially filled fields",
      (WidgetTester tester) async {
    final state = WordInitial();
    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, null);

    final textController =
        (tester.widget(find.byKey(const Key("sentence-text-i"))) as TextField)
            .controller;

    // case: empty fields
    final scrollView = find.byType(SingleChildScrollView);
    final sentenceButton = find.byKey(const Key("sentence-button"));
    await tester.dragUntilVisible(
        sentenceButton, scrollView, const Offset(-250, 0));

    await tester.tap(sentenceButton);
    await tester.pump();

    Finder sentences = find.byType(SentenceItem);
    expect(sentences, findsNothing);

    // case: only sentence text
    await tester.enterText(find.byKey(const Key("sentence-text-i")), "test");
    await tester.tap(sentenceButton);
    await tester.pump();
    sentences = find.byType(SentenceItem);
    expect(sentences, findsNothing);

    textController?.clear();

    // case: only translation
    await tester.enterText(
        find.byKey(const Key("sentence-translation-i")), "test");
    await tester.tap(sentenceButton);
    await tester.pump();
    sentences = find.byType(SentenceItem);
    expect(sentences, findsNothing);
  });

  testWidgets("add word with sentences", (WidgetTester tester) async {
    final state = WordInitial();
    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, wordSentences);

    final itemsFinder = find.widgetWithText(TextField, "");
    expect(itemsFinder, findsNWidgets(2));

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

    final sentencesFinder = find.byType(SentenceItem);
    expect(sentencesFinder, findsNWidgets(2));

    final firstSentence =
        tester.widgetList<SentenceItem>(sentencesFinder).first;
    final secondSentence =
        tester.widgetList<SentenceItem>(sentencesFinder).last;

    expect((firstSentence.text as Text).data, "text1");

    expect((firstSentence.translation as Text).data, "translation1");

    expect((secondSentence.text as Text).data, "text2");

    expect((secondSentence.translation as Text).data, "translation2");
  });
}
