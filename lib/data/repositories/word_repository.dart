import '../../objectbox.g.dart';
import '../../data/models/word.dart';
import '../../data/models/review.dart';
import '../app_database.dart';
import '../models/sentence.dart';
import '../models/sort_option.dart';

class WordRepository {
  const WordRepository({required Future<Box<Word>> box}) : _box = box;

  // A database instance.
  final Future<Box<Word>> _box;

  /// The method that allows the insertion of a word in the repository
  ///
  /// It creates a meaning and a reading review associated to this word
  Future<int> addWord(Word word) async {
    final store = await AppDatabase.instance.store;
    final sentenceBox = store.box<Sentence>();
    final box = await _box;
    final readingReview = word.readingReview;
    final meaningReview = word.meaningReview;
    if (readingReview.target == null) {
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

      meaningReview.target = meaning;
      readingReview.target = reading;
      meaning.word.target = word;
      reading.word.target = word;
    }

    final wordId = word.id;
    final currentWord = wordId == 0 ? null : box.get(word.id);

    final newSentences = word.sentences;
    sentenceBox.putMany(newSentences);

    final id = box.put(word);

    final removedSentences = _removedSentences(currentWord, word);
    sentenceBox.removeMany(removedSentences);

    return id;
  }

  List<int> _removedSentences(Word? currentWord, Word updatedWord) {
    if (currentWord != null) {
      final currentIds = currentWord.sentences.map((s) => s.id).toSet();
      final updatedIds = updatedWord.sentences.map((s) => s.id).toSet();

      return currentIds.difference(updatedIds).toList();
    }

    return [];
  }

  /// This method returns all the words in the repository.
  ///
  /// The words can be sorted by specifying the [sort].
  Future<List<Word>> getWords({SortOption? sort}) async {
    final box = await _box;

    if (sort != null) {
      return box.getAll()
        ..sort((a, b) => Word.sortBy(
              a,
              b,
              attribute: sort.field,
              descending: sort.descending,
            ));
    }

    return box.getAll();
  }

  /// Returns the word with the specified [id].
  ///
  /// Returns null if the word not exists or the [id] is not valid.
  Future<Word?> getWord(int id) async {
    if (id <= 0) return null;

    final box = await _box;

    return box.get(id);
  }
}
