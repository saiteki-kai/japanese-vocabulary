import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/review_bloc.dart';
import 'package:japanese_vocabulary/ui/screens/review_screen/review_screen.dart';
import 'package:japanese_vocabulary/ui/widgets/loading_indicator.dart';
import 'package:mocktail/mocktail.dart';
import '../utils/mocks.dart';
import '../utils/params.dart';

main() {
  late ReviewBloc bloc;

  setUp(() {
    bloc = MockReviewBloc();
  });

  tearDown(() {
    bloc.close();
  });

  Future<void> setUpWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const ReviewScreen(),
        ),
      ),
    );
  }

  group('check number of reviews of the day', () {
    testWidgets(
      "no reviews are selected for today",
      (WidgetTester tester) async {
        when(() => bloc.state).thenReturn(ReviewEmpty());
        await tester.pumpAndSettle();

        await setUpWidget(tester);

        expect(find.textContaining("0"), findsOneWidget);
      },
    );

    testWidgets(
      "100 reviews are selected for today",
      (WidgetTester tester) async {
        when(() => bloc.state).thenReturn(
          ReviewLoaded(review: review1, current: 1, total: 100, isLast: false),
        );
        await tester.pumpAndSettle();

        await setUpWidget(tester);

        expect(find.textContaining("100"), findsOneWidget);
      },
    );
  });

  testWidgets(
    "check review loading indicator",
    (WidgetTester tester) async {
      when(() => bloc.state).thenReturn(ReviewLoading());
      await tester.pumpAndSettle();

      await setUpWidget(tester);

      final loadingFinder = find.byType(LoadingIndicator);
      expect(loadingFinder, findsOneWidget);
    },
  );
}
