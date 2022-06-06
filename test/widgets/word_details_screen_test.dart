import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/models/sentence.dart';
import 'package:japanese_vocabulary/ui/screens/word_details_screen/word_details_screen.dart';
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

  Future<void> setUpWidget(tester, int id) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: WordDetailsScreen(
            wordId: id,
          ),
        ),
      ),
    );
  }

  testWidgets("sentence with empty or partially filled fields",
      (WidgetTester tester) async {
    final word = word4;
    final state = WordLoaded(word: word);

    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, word.id);

    final floatingFinder = find.byKey(const Key("sentence-floating"));
    expect(floatingFinder, findsNWidgets(1));

    await tester.tap(floatingFinder);
    await tester.pumpAndSettle();

    final textFinder = find.byKey(const Key("sentence-text-d"));
    final textController = (tester.widget(textFinder) as TextField).controller;
    final translationFinder = find.byKey(const Key("sentence-translation-d"));
    final addFinder = find.byKey(const Key("sentence-button-d"));
    expect(textFinder, findsNWidgets(1));

    // Case: empty fields.
    await tester.tap(addFinder);
    await tester.pumpAndSettle();
    expect(textFinder, findsNWidgets(1));

    // Case: only sentence text.
    await tester.enterText(textFinder, "test");
    await tester.tap(addFinder);
    await tester.pumpAndSettle();
    expect(textFinder, findsNWidgets(1));

    textController?.clear();

    // Case: only translation.
    await tester.enterText(translationFinder, "test");
    await tester.tap(addFinder);
    await tester.pumpAndSettle();
    expect(textFinder, findsNWidgets(1));

    verifyNever(() {
      bloc.add(WordAdded(word: word));
    });
  });

  testWidgets("add a valid sentence", (WidgetTester tester) async {
    final word = word4;
    final state = WordLoaded(word: word);

    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, word.id);

    final floatingFinder = find.byKey(const Key("sentence-floating"));
    expect(floatingFinder, findsNWidgets(1));

    await tester.tap(floatingFinder);
    await tester.pumpAndSettle();

    final textFinder = find.byKey(const Key("sentence-text-d"));
    final translationFinder = find.byKey(const Key("sentence-translation-d"));
    final addFinder = find.byKey(const Key("sentence-button-d"));
    expect(textFinder, findsNWidgets(1));
    expect(addFinder, findsNWidgets(1));

    const text = "text";
    const translation = "translation";

    (tester.widget(textFinder) as TextField).controller?.text = text;
    (tester.widget(translationFinder) as TextField).controller?.text =
        translation;

    await tester.tap(addFinder);
    await tester.pumpAndSettle();

    verify(() {
      bloc.add(
        WordAdded(
          word: word4
            ..sentences.add(
              Sentence(text: text, translation: translation),
            ),
        ),
      );
    }).called(1);

    expect(textFinder, findsNothing);
    expect(word.sentences.length, 1);
  });

  testWidgets("add a duplicated sentence", (WidgetTester tester) async {
    final word = wordSentences;
    final state = WordLoaded(word: word);

    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, 2);

    final floatingFinder = find.byKey(const Key("sentence-floating"));
    expect(floatingFinder, findsNWidgets(1));

    await tester.tap(floatingFinder);
    await tester.pumpAndSettle();

    final textFinder = find.byKey(const Key("sentence-text-d"));
    final translationFinder = find.byKey(const Key("sentence-translation-d"));
    final addFinder = find.byKey(const Key("sentence-button-d"));
    expect(textFinder, findsNWidgets(1));
    expect(addFinder, findsNWidgets(1));

    const text = "text1";
    const translation = "translation1";

    (tester.widget(textFinder) as TextField).controller?.text = text;
    (tester.widget(translationFinder) as TextField).controller?.text =
        translation;

    await tester.tap(addFinder);
    await tester.pumpAndSettle();

    verifyNever(() {
      bloc.add(WordAdded(word: word));
    });

    expect(addFinder, findsOneWidget);
  });
}
