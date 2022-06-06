import 'package:bloc_test/bloc_test.dart';
import 'package:japanese_vocabulary/bloc/review_bloc.dart';
import 'package:japanese_vocabulary/bloc/settings_bloc.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/settings.dart';
import 'package:japanese_vocabulary/data/models/sort_option.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/review_repository.dart';
import 'package:japanese_vocabulary/data/repositories/settings_repository.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';
import 'package:japanese_vocabulary/objectbox.g.dart';
import 'package:mocktail/mocktail.dart';

class MockWordBox extends Mock implements Box<Word> {}

class MockReviewBox extends Mock implements Box<Review> {}

class MockWordRepository extends Mock implements WordRepository {}

class MockReviewRepository extends Mock implements ReviewRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockWordBloc extends MockBloc<WordEvent, WordState> implements WordBloc {}

class MockReviewBloc extends MockBloc<ReviewEvent, ReviewState>
    implements ReviewBloc {}

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class MockQueryBuilder<T> extends Mock implements QueryBuilder<T> {}

class MockQuery<T> extends Mock implements Query<T> {}

class FakeWord extends Fake implements Word {}

class FakeReview extends Fake implements Review {}

class FakeSettings extends Fake implements Settings {}

class FakeSortOption extends Fake implements SortOption {}
