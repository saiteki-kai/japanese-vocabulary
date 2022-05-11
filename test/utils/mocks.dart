import 'package:bloc_test/bloc_test.dart';
import 'package:japanese_vocabulary/bloc/review_bloc.dart';
import 'package:japanese_vocabulary/bloc/word_bloc.dart';
import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/word.dart';
import 'package:japanese_vocabulary/data/repositories/review_repository.dart';
import 'package:japanese_vocabulary/data/repositories/word_repository.dart';
import 'package:japanese_vocabulary/objectbox.g.dart';
import 'package:mocktail/mocktail.dart';

class MockWordBox extends Mock implements Box<Word> {}

class MockReviewBox extends Mock implements Box<Review> {}

class MockWordRepository extends Mock implements WordRepository {}

class MockReviewRepository extends Mock implements ReviewRepository {}

class MockWordBloc extends MockBloc<WordEvent, WordState> implements WordBloc {}

class MockReviewBloc extends MockBloc<ReviewEvent, ReviewState>
    implements ReviewBloc {}

class FakeWord extends Fake implements Word {}

class FakeReview extends Fake implements Review {}
