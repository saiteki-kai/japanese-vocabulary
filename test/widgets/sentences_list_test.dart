import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/ui/screens/word_details_screen/widgets/sentences_list.dart';
import 'package:japanese_vocabulary/ui/widgets/sentence_item.dart';
import 'package:mocktail/mocktail.dart';

import '../utils/mocks.dart';
import '../utils/params.dart';

void main() {
  late WordBloc bloc;

  setUp(() {
    bloc = MockWordBloc();
  });

  tearDown(() {
    bloc.close();
  });

  Future<void> setUpWidget(tester, Word word) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: SentencesList(word: word),
        ),
      ),
    );
  }

  testWidgets("empty sentence list", (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(WordLoaded(word: word3));

    await setUpWidget(tester, word3);

    final noSentence =
        (tester.widget(find.byKey(const Key("noSentenceTest"))) as Text).data;

    expect(noSentence, equals("No sentences found"));
  });

  testWidgets("sentence list", (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(WordLoaded(word: wordSentences));

    await setUpWidget(tester, wordSentences);

    final textSentence = find.byKey(const Key("textSentenceTest"));
    final sentencesFound = tester.widgetList(textSentence);
    expect((sentencesFound.first as Text).data, "text1");
    expect((sentencesFound.last as Text).data, "text2");
  });

  testWidgets("delete a sentence", (WidgetTester tester) async {
    final word = wordSentences;
    final state = WordLoaded(word: word);

    final sentenceItemFinder = find.byType(SentenceItem);

    when(() => bloc.state).thenReturn(state);

    final word2 = wordSentences.copyWith();

    await setUpWidget(tester, word);

    expect(sentenceItemFinder, findsNWidgets(2));

    final deleteBtnFinder = find.byKey(const Key("sentence-delete"));
    expect(deleteBtnFinder, findsNWidgets(2));

    await tester.tap(deleteBtnFinder.first);
    await tester.pumpAndSettle();

    final confirmBtnFinder = find.byKey(const Key("alert-confirm"));
    expect(confirmBtnFinder, findsOneWidget);

    await tester.tap(confirmBtnFinder);
    await tester.pumpAndSettle();
    verify(() {
      bloc.add(WordAdded(word: word2..sentences.removeAt(0)));
    }).called(1);

    await setUpWidget(tester, word2);

    expect(sentenceItemFinder, findsOneWidget);
  });

  testWidgets("valid sentence editing", (WidgetTester tester) async {
    final word = wordSentences;
    final state = WordLoaded(word: word);

    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, word);

    final sentenceItemFinder = find.byType(SentenceItem);
    expect(sentenceItemFinder, findsNWidgets(2));

    SentenceItem firstSentenceItem =
        tester.widgetList(sentenceItemFinder).first as SentenceItem;

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
