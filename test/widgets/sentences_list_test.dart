import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/ui/screens/word_details_screen/widgets/sentences_list.dart';
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
    when(() => bloc.state).thenReturn(WordLoaded(word: wordNoSentence));

    await setUpWidget(tester, wordNoSentence);

    final noSentence =
        (tester.widget(find.byKey(const Key("noSentenceTest"))) as Text).data;

    expect(noSentence, equals("No senteces found"));
  });

  testWidgets("sentence list", (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(WordLoaded(word: wordSentence));

    await setUpWidget(tester, wordSentence);

    final textSentence =
        (tester.widget(find.byKey(const Key("textSentenceTest"))) as Text).data;

    expect(textSentence, equals("sentence text"));
  });
}
