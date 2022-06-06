import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_button/group_button.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/ui/widgets/sentence_item.dart';
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
    final sentenceButton = find.byKey(const Key("sentence-button-i"));
    await tester.dragUntilVisible(
        sentenceButton, scrollView, const Offset(-250, 0));

    await tester.tap(sentenceButton);
    await tester.pumpAndSettle();

    Finder sentences = find.byType(SentenceItem);
    expect(sentences, findsNothing);

    // case: only sentence text
    await tester.enterText(find.byKey(const Key("sentence-text-i")), "test");
    await tester.tap(sentenceButton);
    await tester.pumpAndSettle();
    sentences = find.byType(SentenceItem);
    expect(sentences, findsNothing);

    textController?.clear();

    // case: only translation
    await tester.enterText(
        find.byKey(const Key("sentence-translation-i")), "test");
    await tester.tap(sentenceButton);
    await tester.pumpAndSettle();
    sentences = find.byType(SentenceItem);
    expect(sentences, findsNothing);
  });

  testWidgets("add a valid sentence", (WidgetTester tester) async {
    final state = WordInitial();
    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, null);

    final textController =
        (tester.widget(find.byKey(const Key("sentence-text-i"))) as TextField)
            .controller;
    final translationController =
        (tester.widget(find.byKey(const Key("sentence-translation-i")))
                as TextField)
            .controller;
    textController?.text = "test";
    translationController?.text = "test";

    final scrollView = find.byType(SingleChildScrollView);
    final sentenceButton = find.byKey(const Key("sentence-button-i"));
    await tester.dragUntilVisible(
        sentenceButton, scrollView, const Offset(-250, 0));

    await tester.tap(sentenceButton);
    await tester.pumpAndSettle();

    final sentences = find.byType(SentenceItem);
    expect(sentences, findsOneWidget);
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

    expect(firstSentence.sentence.text, equals("text1"));

    expect(firstSentence.sentence.translation, equals("translation1"));

    expect(secondSentence.sentence.text, equals("text2"));

    expect(secondSentence.sentence.translation, equals("translation2"));
  });

  testWidgets("delete a sentence", (WidgetTester tester) async {
    final state = WordInitial();
    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, wordSentences);

    final deleteBtnFinder = find.byKey(const Key("sentence-delete"));
    expect(deleteBtnFinder, findsNWidgets(2));

    final scrollView = find.byType(SingleChildScrollView);
    await tester.dragUntilVisible(
        deleteBtnFinder.last, scrollView, const Offset(-250, 0));

    await tester.tap(deleteBtnFinder.first);
    await tester.pumpAndSettle();

    expect(deleteBtnFinder, findsOneWidget);
  });

  testWidgets("valid sentence editing", (WidgetTester tester) async {
    final state = WordInitial();
    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, wordSentences);

    final sentenceItemFinder = find.byType(SentenceItem);
    expect(sentenceItemFinder, findsNWidgets(2));

    SentenceItem firstSentenceItem =
        tester.widgetList(sentenceItemFinder).first as SentenceItem;

    final scrollView = find.byType(SingleChildScrollView);
    await tester.dragUntilVisible(
        sentenceItemFinder.last, scrollView, const Offset(-250, 0));

    String firstSentenceText = firstSentenceItem.sentence.text;
    expect(firstSentenceText, "text1");

    final editBtnFinder = find.byKey(const Key("sentence-edit"));
    expect(editBtnFinder, findsNWidgets(2));

    await tester.tap(editBtnFinder.first);
    await tester.pumpAndSettle();

    final sentenceEditBtnFinder = find.byKey(const Key("sentence-button-d"));
    expect(sentenceEditBtnFinder, findsOneWidget);

    final textFinder = find.byKey(const Key("sentence-text-d"));
    final textWidget = tester.widget(textFinder) as TextField;
    textWidget.controller?.text = "ABC";

    await tester.tap(sentenceEditBtnFinder);
    await tester.pumpAndSettle();

    firstSentenceItem =
        tester.widgetList(sentenceItemFinder).first as SentenceItem;
    firstSentenceText = firstSentenceItem.sentence.text;
    expect(firstSentenceText, "ABC");
  });

  testWidgets("invalid sentence editing", (WidgetTester tester) async {
    final word = wordSentences;
    final state = WordLoaded(word: word);

    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, word);

    final sentenceItemFinder = find.byType(SentenceItem);
    expect(sentenceItemFinder, findsNWidgets(2));

    SentenceItem firstSentenceItem =
        tester.widgetList(sentenceItemFinder).first as SentenceItem;

    final scrollView = find.byType(SingleChildScrollView);
    await tester.dragUntilVisible(
        sentenceItemFinder.last, scrollView, const Offset(-250, 0));

    String firstSentenceText = firstSentenceItem.sentence.text;
    String firstSentenceTranslation = firstSentenceItem.sentence.translation;
    expect(firstSentenceText, "text1");
    expect(firstSentenceTranslation, "translation1");

    final editBtnFinder = find.byKey(const Key("sentence-edit"));
    expect(editBtnFinder, findsNWidgets(2));

    await tester.tap(editBtnFinder.first);
    await tester.pumpAndSettle();

    final sentenceEditBtnFinder = find.byKey(const Key("sentence-button-d"));
    expect(sentenceEditBtnFinder, findsOneWidget);

    final textFinder = find.byKey(const Key("sentence-text-d"));
    final textWidget = tester.widget(textFinder) as TextField;
    final translationFinder = find.byKey(const Key("sentence-translation-d"));
    final translationWidget = tester.widget(translationFinder) as TextField;

    // Case: duplicated sentence
    textWidget.controller?.text = "text2";

    await tester.tap(sentenceEditBtnFinder);
    await tester.pumpAndSettle();

    firstSentenceItem =
        tester.widgetList(sentenceItemFinder).first as SentenceItem;
    firstSentenceText = firstSentenceItem.sentence.text;
    expect(firstSentenceText, "text1");

    // Case: empty text
    textWidget.controller?.text = "";

    await tester.tap(sentenceEditBtnFinder);
    await tester.pumpAndSettle();

    firstSentenceItem =
        tester.widgetList(sentenceItemFinder).first as SentenceItem;
    firstSentenceText = firstSentenceItem.sentence.text;
    expect(firstSentenceText, "text1");

    // Case: empty translation
    translationWidget.controller?.text = "";

    await tester.tap(sentenceEditBtnFinder);
    await tester.pumpAndSettle();

    firstSentenceItem =
        tester.widgetList(sentenceItemFinder).first as SentenceItem;
    firstSentenceTranslation = firstSentenceItem.sentence.translation;
    expect(firstSentenceTranslation, "translation1");
  });
}
