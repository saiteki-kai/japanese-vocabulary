import '../../objectbox.g.dart';
import '../../data/models/sentence.dart';

class SentenceRepository {
  const SentenceRepository({required Future<Box<Sentence>> box}) : _box = box;

  // A database instance.
  final Future<Box<Sentence>> _box;

  /// The method that allows the insertion of a sentence in the repository
  Future<int> addSentence(Sentence sentence) async {
    final box = await _box;
    return box.put(sentence);
  }

  Future<List<int>> addSentences(List<Sentence> sentences) async {
    final box = await _box;
    return box.putMany(sentences);
  }

  /// Returns the list of all sentences with the specified ids
  Future<List<Sentence?>> getSentences(List<int> ids) async {
    final box = await _box;
    return box.getMany(ids);
  }

  /// Returns the sentence with the specified [id].
  ///
  /// Returns null if the sentence not exists or the [id] is not valid.
  Future<Sentence?> getSentence(int id) async {
    if (id <= 0) return null;

    final box = await _box;

    return box.get(id);
  }
}
