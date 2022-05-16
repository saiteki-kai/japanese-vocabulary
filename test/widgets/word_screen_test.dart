import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/ui/screens/words_screen/widgets/word_item.dart';
import 'package:japanese_vocabulary/ui/screens/words_screen/words_screen.dart';
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

  Future<void> setUpWidget(tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const WordScreen(),
        ),
      ),
    );
  }

  testWidgets("empty word list", (WidgetTester tester) async {
    when(() => bloc.state).thenReturn(const WordsLoaded(words: []));

    await setUpWidget(tester);

    final itemsFinder = find.byType(WordItem);
    expect(itemsFinder, findsNothing);
  });

  testWidgets("filled word list", (WidgetTester tester) async {
    final state = WordsLoaded(words: [word1, word2, word3]);
    when(() => bloc.state).thenReturn(state);

    await setUpWidget(tester);

    final itemsFinder = find.byType(WordItem);
    expect(itemsFinder, findsNWidgets(3));
  });
}
