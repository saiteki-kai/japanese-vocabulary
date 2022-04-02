import '../../objectbox.g.dart';
import '../app_database.dart';
import '../models/word.dart';

class WordRepository {
  Future<Store> get _store async => await AppDatabase.instance.store;

  Future<Word?> getWord(int id) async {
    if (id <= 0) {
      return null;
    }
    else {
      final box = (await _store).box<Word>();
      return box.get(id);
    }
  }
}
