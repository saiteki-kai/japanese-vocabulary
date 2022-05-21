import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_button/group_button.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/models/sentence.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/ui/widgets/sentence.dart';
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
/*

    final state = WordInitial();
    when(() => bloc.state).thenReturn(state);

    bloc.add(WordAdded(word: word));
    bloc.add(WordsRetrieved());

    if (state is WordsLoaded) {(state as WordsLoaded).words.first}

*/
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
    Word word = word4;
    WordState state = WordLoaded(word: word);

    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, word.id);

    final floatingFinder = find.byKey(const Key("sentence-floating"));
    expect(floatingFinder, findsNWidgets(1));

    await tester.tap(floatingFinder);
    await tester.pump();

    final textFinder = find.byKey(const Key("sentence-text-d"));
    final textController = (tester.widget(textFinder) as TextField).controller;
    final translationFinder = find.byKey(const Key("sentence-translation-d"));
    final addFinder = find.byKey(const Key("sentence-button-d"));
    expect(textFinder, findsNWidgets(1));

    // case: empty fields
    await tester.tap(addFinder);
    await tester.pump();
    expect(textFinder, findsNWidgets(1));

    // case: only sentence text
    await tester.enterText(textFinder, "test");
    await tester.tap(addFinder);
    await tester.pump();
    expect(textFinder, findsNWidgets(1));

    textController?.clear();

    // case: only translation
    await tester.enterText(translationFinder, "test");
    await tester.tap(addFinder);
    await tester.pump();
    expect(textFinder, findsNWidgets(1));
  });

  testWidgets("add a valid sentence", (WidgetTester tester) async {
    final word = word4;
    WordState state = WordLoaded(word: word);

    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester, word.id);

    final floatingFinder = find.byKey(const Key("sentence-floating"));
    expect(floatingFinder, findsNWidgets(1));

    await tester.tap(floatingFinder);
    await tester.pump();

    final textFinder = find.byKey(const Key("sentence-text-d"));
    final textController = (tester.widget(textFinder) as TextField).controller;
    final translationFinder = find.byKey(const Key("sentence-translation-d"));
    final addFinder = find.byKey(const Key("sentence-button-d"));
    expect(textFinder, findsNWidgets(1));

    await tester.enterText(textFinder, "text");
    await tester.enterText(translationFinder, "translation");

    final sentence = Sentence(text: "text", translation: "translation");
    word.sentences.add(sentence);

    await tester.tap(addFinder);
    await tester.pump();
    expect(textFinder, findsNothing);
    expect(bloc.state, WordLoaded(word: word));
  });
}
