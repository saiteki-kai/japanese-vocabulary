import '../../objectbox.g.dart';
import '../app_database.dart';
import '../../data/models/word.dart';
import '../../data/models/review.dart';

class WordRepository {
  Future<Store> get _store async => await AppDatabase.instance.store;
  Future<int> addWord(Word word) async {
    final store = await _store;

    final Review meaning = Review(
      id: 0,
      ef: 2.5,
      interval: 0,
      repetition: 0,
      correctAnswers: 0,
      incorrectAnswers: 0,
      type: 'meaning',
      nextDate: DateTime.now(),
    );
    final Review reading = Review(
      id: 0,
      ef: 2.5,
      interval: 0,
      repetition: 0,
      correctAnswers: 0,
      incorrectAnswers: 0,
      type: 'reading',
      nextDate: DateTime.now(),
    );
    word.meaningReview.target = meaning;
    word.readingReview.target = reading;
    meaning.word.target = word;
    reading.word.target = word;

    return store.box<Word>().put(word);
  }
}
