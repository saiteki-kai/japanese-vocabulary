import '../../objectbox.g.dart';
import '../app_database.dart';
import '../../data/models/word.dart';
import '../../data/models/review.dart';

class WordRepository {
  /// A database instance.
  Future<Store> get _store => AppDatabase.instance.store;

  /// The method that allows the insertion of a word in the repository
  ///
  /// It creates a meaning and a reading review associated to this word
  Future<int> addWord(Word word) async {
    final box = (await _store).box<Word>();

    final Review meaning = Review(
      ef: 2.5,
      interval: 0,
      repetition: 0,
      correctAnswers: 0,
      incorrectAnswers: 0,
      type: 'meaning',
      nextDate: DateTime.now(),
    );
    final Review reading = Review(
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

    return box.put(word);
  }

  /// This method returns all the words in the repository
  Future<List<Word>> getWords() async {
    final box = (await _store).box<Word>();
    return box.getAll();
  }

  /// Returns the word with the specified [id].
  ///
  /// Returns null if the word not exists or the [id] is not valid.
  Future<Word?> getWord(int id) async {
    if (id <= 0) {
      return null;
    } else {
      final box = (await _store).box<Word>();
      return box.get(id);
    }
  }
}