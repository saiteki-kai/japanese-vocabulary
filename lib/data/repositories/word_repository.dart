import '../../objectbox.g.dart';
import '../app_database.dart';
import '../models/word.dart';

class WordRepository {
  /// A database instance.
  Future<Store> get _store async => await AppDatabase.instance.store;

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
