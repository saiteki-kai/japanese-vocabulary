import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/settings_bloc.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/models/settings.dart';
import 'package:japanese_vocabulary/data/models/sort_option.dart';
import 'package:japanese_vocabulary/ui/screens/words_screen/widgets/sort_list_item.dart';
import 'package:japanese_vocabulary/ui/screens/words_screen/widgets/sorting_section.dart';
import 'package:japanese_vocabulary/utils/sort.dart';
import 'package:mocktail/mocktail.dart';

import '../utils/mocks.dart';
import '../utils/params.dart';

void main() {
  late SettingsBloc settingsBloc;
  late WordBloc wordBloc;

  setUp(() {
    settingsBloc = MockSettingsBloc();
    wordBloc = MockWordBloc();

    registerFallbackValue(FakeSettings());
    registerFallbackValue(FakeSortOption());
  });

  tearDown(() {
    settingsBloc.close();
    wordBloc.close();
  });

  setUpWidget(WidgetTester tester) async {
    when(() => wordBloc.state).thenReturn(
      WordsLoaded(
        words: [wordsWithReview1, wordsWithReview2, wordsWithReview3],
      ),
    );
    when(() => settingsBloc.state).thenReturn(
      const SettingsLoaded(settings: Settings.initial()),
    );

    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: wordBloc),
            BlocProvider.value(value: settingsBloc),
          ],
          child: const Material(child: SortingSection()),
        ),
      ),
    );
  }

  testWidgets("check enabled property", (WidgetTester tester) async {
    await setUpWidget(tester);

    final itemFinder = find.byType(SortListItem);
    expect(itemFinder, findsNWidgets(4));

    // check items
    final items = tester.widgetList<SortListItem>(itemFinder).toList();
    final initialSortField = const SortOption.initial().field;

    for (final item in items) {
      final iconFinder = find.descendant(
        of: find.byWidget(item),
        matching: find.byType(Icon),
      );

      if (item.field == initialSortField) {
        expect(item.enabled, true);
        expect(iconFinder, findsOneWidget);
      } else {
        expect(item.enabled, false);
        expect(iconFinder, findsNothing);
      }
    }
  });

  testWidgets("change sort field", (WidgetTester tester) async {
    await setUpWidget(tester);

    final sortListItemFinder = find.byType(SortListItem);

    // press on the last item (one not enabled)
    await tester.tap(sortListItemFinder.last);
    await tester.pump();

    final sortOption = SortOption(
      field: sortFieldText.keys.last,
      descending: false,
    );

    verify(() {
      settingsBloc.add(SettingsSortChanged(sortOption: sortOption));
    }).called(1);

    verify(() {
      wordBloc.add(WordsRetrieved(sort: sortOption));
    }).called(1);
  });

  testWidgets("change sort mode", (WidgetTester tester) async {
    await setUpWidget(tester);

    final sortListItemFinder = find.byType(SortListItem);

    // press on the first item (the one already enabled)
    await tester.tap(sortListItemFinder.first);
    await tester.pump();

    // check if the order is reversed
    final sortOption = SortOption(
      field: sortFieldText.keys.first,
      descending: true,
    );

    verify(() {
      settingsBloc.add(SettingsSortChanged(sortOption: sortOption));
    }).called(1);

    verify(() {
      wordBloc.add(WordsRetrieved(sort: sortOption));
    }).called(1);
  });
}
